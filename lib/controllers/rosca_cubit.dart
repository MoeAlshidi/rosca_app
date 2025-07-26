import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/rosca.dart';
import '../services/api_service.dart';

abstract class RoscaState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RoscaInitial extends RoscaState {}

class RoscaLoading extends RoscaState {}

class RoscaLoaded extends RoscaState {
  final List<Rosca> userRoscas;
  final List<Rosca> availableRoscas;
  final RoscaDuration? selectedDuration;

  RoscaLoaded({
    required this.userRoscas,
    required this.availableRoscas,
    this.selectedDuration,
  });

  @override
  List<Object?> get props => [userRoscas, availableRoscas, selectedDuration];

  RoscaLoaded copyWith({
    List<Rosca>? userRoscas,
    List<Rosca>? availableRoscas,
    RoscaDuration? selectedDuration,
  }) {
    return RoscaLoaded(
      userRoscas: userRoscas ?? this.userRoscas,
      availableRoscas: availableRoscas ?? this.availableRoscas,
      selectedDuration: selectedDuration ?? this.selectedDuration,
    );
  }
}

class RoscaError extends RoscaState {
  final String message;

  RoscaError(this.message);

  @override
  List<Object?> get props => [message];
}

class RoscaJoining extends RoscaState {}

class RoscaJoined extends RoscaState {
  final Rosca joinedRosca;

  RoscaJoined(this.joinedRosca);

  @override
  List<Object?> get props => [joinedRosca];
}

class RoscaCreating extends RoscaState {}

class RoscaCreated extends RoscaState {
  final Rosca createdRosca;

  RoscaCreated(this.createdRosca);

  @override
  List<Object?> get props => [createdRosca];
}

class RoscaCubit extends Cubit<RoscaState> {
  final ApiService _apiService;
  List<Rosca> _allRoscas = [];
  List<Rosca> _userRoscas = [];
  List<Rosca> _availableRoscas = [];

  RoscaCubit(this._apiService) : super(RoscaInitial());

  Future<void> loadRoscas() async {
    emit(RoscaLoading());
    try {
      final roscas = await _apiService.getRoscas();
      _allRoscas = roscas;
      _userRoscas = roscas.where((rosca) => rosca.isUserMember).toList();
      _availableRoscas = roscas
          .where((rosca) => !rosca.isUserMember && !rosca.isFull)
          .toList();

      emit(RoscaLoaded(
        userRoscas: _userRoscas,
        availableRoscas: _availableRoscas,
      ));
    } catch (e) {
      emit(RoscaError('Failed to load ROSCAs: $e'));
    }
  }

  Future<void> loadUserRoscas() async {
    emit(RoscaLoading());
    try {
      final userRoscas = await _apiService.getUserRoscas();
      _userRoscas = userRoscas;

      emit(RoscaLoaded(
        userRoscas: _userRoscas,
        availableRoscas: _availableRoscas,
      ));
    } catch (e) {
      emit(RoscaError('Failed to load user ROSCAs: $e'));
    }
  }

  void filterByDuration(RoscaDuration duration) {
    final currentState = state;
    if (currentState is RoscaLoaded) {
      final filteredAvailable = _availableRoscas
          .where((rosca) => rosca.duration == duration)
          .toList();

      emit(currentState.copyWith(
        availableRoscas: filteredAvailable,
        selectedDuration: duration,
      ));
    }
  }

  // Join ROSCA without manual slot selection - backend assigns automatically
  Future<void> joinRosca(String roscaId) async {
    emit(RoscaJoining());
    try {
      final joinedRosca = await _apiService.joinRosca(roscaId);

      // Update local state
      _userRoscas.add(joinedRosca);
      _availableRoscas.removeWhere((rosca) => rosca.id == roscaId);

      emit(RoscaJoined(joinedRosca));

      // Reload to get updated data
      await loadRoscas();
    } catch (e) {
      emit(RoscaError('Failed to join ROSCA: $e'));
    }
  }

  // Create new ROSCA
  Future<void> createRosca({
    required String title,
    required double amount,
    required String currency,
    required RoscaDuration duration,
    required int totalSlots,
    required double fees,
    String? description,
  }) async {
    emit(RoscaCreating());
    try {
      final createdRosca = await _apiService.createRosca(
        title: title,
        amount: amount,
        currency: currency,
        duration: duration,
        totalSlots: totalSlots,
        fees: fees,
        description: description,
      );

      // Add to available ROSCAs
      _availableRoscas.add(createdRosca);

      emit(RoscaCreated(createdRosca));

      // Reload to get updated data
      await loadRoscas();
    } catch (e) {
      emit(RoscaError('Failed to create ROSCA: $e'));
    }
  }

  List<Rosca> getRoscasByCategory(RoscaCategory category) {
    final currentState = state;
    if (currentState is RoscaLoaded) {
      return currentState.availableRoscas
          .where((rosca) => rosca.category == category)
          .toList();
    }
    return [];
  }

  List<Rosca> getUserRoscasByStatus(RoscaStatus status) {
    return _userRoscas.where((rosca) => rosca.status == status).toList();
  }

  // Get upcoming payments for user
  List<Rosca> getUpcomingPayments() {
    final now = DateTime.now();
    final upcoming = DateTime.now().add(const Duration(days: 7)); // Next 7 days

    return _userRoscas.where((rosca) {
      if (rosca.userInfo?.nextPaymentDate != null) {
        final paymentDate = rosca.userInfo!.nextPaymentDate;
        return paymentDate.isAfter(now) && paymentDate.isBefore(upcoming);
      }
      return false;
    }).toList();
  }

  // Get ROSCAs where user is getting paid soon
  List<Rosca> getUpcomingPayouts() {
    final now = DateTime.now();
    final upcoming =
        DateTime.now().add(const Duration(days: 30)); // Next 30 days

    return _userRoscas.where((rosca) {
      if (rosca.userInfo?.payoutDate != null &&
          !rosca.userInfo!.hasReceivedPayout) {
        final payoutDate = rosca.userInfo!.payoutDate;
        return payoutDate.isAfter(now) && payoutDate.isBefore(upcoming);
      }
      return false;
    }).toList();
  }

  // Calculate total savings across all user ROSCAs
  double getTotalSavingsGoal() {
    return _userRoscas.fold(0.0, (sum, rosca) => sum + rosca.totalSavingGoal);
  }

  // Calculate total amount paid so far
  double getTotalAmountPaid() {
    return _userRoscas.fold(0.0, (sum, rosca) {
      return sum + (rosca.userInfo?.totalPaid ?? 0.0);
    });
  }

  // Calculate next payment amount due
  double getNextPaymentAmount() {
    final upcomingPayments = getUpcomingPayments();
    return upcomingPayments.fold(
        0.0, (sum, rosca) => sum + rosca.paymentPerCycle);
  }
}
