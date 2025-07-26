import 'dart:async';
import '../models/rosca.dart';
import '../models/user.dart';
import '../models/member.dart';
import '../models/rosca_slot.dart';
import 'mock_data_service.dart';

class ApiService {
  // Simulate network delay
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  Future<List<Rosca>> getRoscas() async {
    await _simulateNetworkDelay();
    return MockDataService.getMockRoscas();
  }

  Future<List<Rosca>> getUserRoscas() async {
    await _simulateNetworkDelay();
    return MockDataService.getUserRoscas();
  }

  Future<List<Rosca>> getAvailableRoscas() async {
    await _simulateNetworkDelay();
    return MockDataService.getAvailableRoscas();
  }

  Future<User> getCurrentUser() async {
    await _simulateNetworkDelay();
    return MockDataService.getMockUser();
  }

  Future<User> login(String email, String password) async {
    await _simulateNetworkDelay();

    // Simulate login validation
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }

    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    return MockDataService.getMockUser();
  }

  Future<User> register({
    required String name,
    required String email,
    required String password,
    String? phoneNumber,
  }) async {
    await _simulateNetworkDelay();

    // Simulate registration validation
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      throw Exception('Name, email, and password are required');
    }

    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    if (!email.contains('@')) {
      throw Exception('Please enter a valid email address');
    }

    return MockDataService.getMockUser();
  }

  // Join ROSCA without slot selection - backend assigns slot automatically
  Future<Rosca> joinRosca(String roscaId) async {
    await _simulateNetworkDelay();

    final roscas = MockDataService.getMockRoscas();
    final rosca = roscas.firstWhere(
      (r) => r.id == roscaId,
      orElse: () => throw Exception('ROSCA not found'),
    );

    if (rosca.isFull) {
      throw Exception('This ROSCA is full');
    }

    if (rosca.isUserMember) {
      throw Exception('You are already a member of this ROSCA');
    }

    // Simulate joining by creating a new ROSCA object with user as member
    final user = MockDataService.getMockUser();
    final userMember = Member(
      id: user.id,
      name: user.name,
      profileImage: user.profileImage,
      isVerified: true,
      cyclePosition: rosca.members.length + 1, // Next available position
    );

    final now = DateTime.now();
    final userInfo = UserRoscaInfo(
      cyclePosition: rosca.members.length + 1,
      nextPaymentDate:
          rosca.nextPaymentDate ?? now.add(const Duration(days: 5)),
      payoutDate: _calculatePayoutDate(rosca, rosca.members.length + 1),
      totalPaid: 0.0, // Just joined, nothing paid yet
      totalToSave: rosca.totalSavingGoal,
      hasReceivedPayout: false,
      cyclesRemaining: rosca.totalSlots,
    );

    return rosca.copyWith(
      members: [...rosca.members, userMember],
      isUserMember: true,
      availableSlots: rosca.availableSlots - 1,
      isFull: rosca.availableSlots - 1 <= 0,
      userInfo: userInfo,
    );
  }

  // Create new ROSCA
  Future<Rosca> createRosca({
    required String title,
    required double amount,
    required String currency,
    required RoscaDuration duration,
    required int totalSlots,
    required double fees,
    String? description,
  }) async {
    await _simulateNetworkDelay();

    // Validation
    if (title.trim().isEmpty) {
      throw Exception('ROSCA title is required');
    }

    if (amount <= 0) {
      throw Exception('Amount must be greater than 0');
    }

    if (totalSlots < 2) {
      throw Exception('ROSCA must have at least 2 slots');
    }

    if (totalSlots > 50) {
      throw Exception('ROSCA cannot have more than 50 slots');
    }

    final now = DateTime.now();
    final startDate = now.add(const Duration(days: 7)); // Start in a week

    // Calculate end date based on duration
    int monthsToAdd;
    switch (duration) {
      case RoscaDuration.monthly:
        monthsToAdd = totalSlots;
        break;
      case RoscaDuration.quarterly:
        monthsToAdd = totalSlots * 3;
        break;
      case RoscaDuration.biMonthly:
        monthsToAdd = totalSlots * 2;
        break;
    }

    final endDate = DateTime(
      startDate.year,
      startDate.month + monthsToAdd,
      startDate.day,
    );

    return Rosca(
      id: 'rosca_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      amount: amount,
      currency: currency,
      duration: duration,
      category: RoscaCategory.recommend, // Default category
      status: RoscaStatus.upcoming,
      totalSlots: totalSlots,
      availableSlots: totalSlots,
      fees: fees,
      members: [], // Empty initially
      slots: MockDataService.getMockSlots(
        totalSlots: totalSlots,
        startDate: startDate,
        duration: duration,
      ),
      startDate: startDate,
      endDate: endDate,
      currentCycle: 1,
      isUserMember: false,
      isFull: false,
      description: description,
    );
  }

  Future<void> logout() async {
    await _simulateNetworkDelay();
    // Simulate logout
  }

  DateTime _calculatePayoutDate(Rosca rosca, int cyclePosition) {
    final startDate = rosca.startDate;
    int monthsToAdd;

    switch (rosca.duration) {
      case RoscaDuration.monthly:
        monthsToAdd = cyclePosition - 1; // 0-based for calculation
        break;
      case RoscaDuration.quarterly:
        monthsToAdd = (cyclePosition - 1) * 3;
        break;
      case RoscaDuration.biMonthly:
        monthsToAdd = (cyclePosition - 1) * 2;
        break;
    }

    return DateTime(
      startDate.year,
      startDate.month + monthsToAdd,
      startDate.day,
    );
  }
}

// Extension to add copyWith method to Rosca (for the mock simulation)
extension RoscaCopyWith on Rosca {
  Rosca copyWith({
    String? id,
    String? title,
    double? amount,
    String? currency,
    RoscaDuration? duration,
    RoscaCategory? category,
    RoscaStatus? status,
    int? totalSlots,
    int? availableSlots,
    double? fees,
    List<Member>? members,
    List<RoscaSlot>? slots,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? nextPaymentDate,
    Member? nextCollector,
    int? currentCycle,
    bool? isUserMember,
    bool? isFull,
    UserRoscaInfo? userInfo,
    String? description,
  }) {
    return Rosca(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      duration: duration ?? this.duration,
      category: category ?? this.category,
      status: status ?? this.status,
      totalSlots: totalSlots ?? this.totalSlots,
      availableSlots: availableSlots ?? this.availableSlots,
      fees: fees ?? this.fees,
      members: members ?? this.members,
      slots: slots ?? this.slots,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      nextPaymentDate: nextPaymentDate ?? this.nextPaymentDate,
      nextCollector: nextCollector ?? this.nextCollector,
      currentCycle: currentCycle ?? this.currentCycle,
      isUserMember: isUserMember ?? this.isUserMember,
      isFull: isFull ?? this.isFull,
      userInfo: userInfo ?? this.userInfo,
      description: description ?? this.description,
    );
  }
}
