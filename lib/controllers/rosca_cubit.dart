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

class RoscaJoined extends RoscaState {}

class RoscaCubit extends Cubit<RoscaState> {
  final ApiService _apiService;

  RoscaCubit(this._apiService) : super(RoscaInitial());

  Future<void> loadRoscas() async {
    emit(RoscaLoading());
    try {
      final userRoscas = await _apiService.getUserRoscas();
      final availableRoscas = await _apiService.getAvailableRoscas();
      
      emit(RoscaLoaded(
        userRoscas: userRoscas,
        availableRoscas: availableRoscas,
      ));
    } catch (e) {
      emit(RoscaError('Failed to load ROSCAs: ${e.toString()}'));
    }
  }

  Future<void> filterByDuration(RoscaDuration duration) async {
    final currentState = state;
    if (currentState is RoscaLoaded) {
      emit(RoscaLoading());
      try {
        final availableRoscas = await _apiService.getAvailableRoscas(
          duration: duration,
        );
        
        emit(currentState.copyWith(
          availableRoscas: availableRoscas,
          selectedDuration: duration,
        ));
      } catch (e) {
        emit(RoscaError('Failed to filter ROSCAs: ${e.toString()}'));
      }
    }
  }

  Future<void> joinRosca(String roscaId, String slotId) async {
    emit(RoscaJoining());
    try {
      await _apiService.joinRosca(roscaId, slotId);
      emit(RoscaJoined());
      await loadRoscas();
    } catch (e) {
      emit(RoscaError('Failed to join ROSCA: ${e.toString()}'));
    }
  }

  Future<void> leaveRosca(String roscaId) async {
    emit(RoscaLoading());
    try {
      await _apiService.leaveRosca(roscaId);
      await loadRoscas();
    } catch (e) {
      emit(RoscaError('Failed to leave ROSCA: ${e.toString()}'));
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
} 