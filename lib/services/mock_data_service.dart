import '../models/user.dart';
import '../models/rosca.dart';
import '../models/member.dart';
import '../models/rosca_slot.dart';

class MockDataService {
  static User getMockUser() {
    return const User(
      id: 'user_1',
      name: 'Nour Ramy',
      email: 'nour.ramy@example.com',
      phoneNumber: '+96812345678',
      profileImage: null,
      isHrLetterVerified: true,
      isUtilityBillVerified: true,
      isNationalIdVerified: true,
      isIncomeInfoVerified: true,
      isMobileNumberVerified: true,
    );
  }

  static List<Member> getMockMembers({bool includeUser = false}) {
    final members = [
      const Member(
        id: '1',
        name: 'Ahmed Ali',
        profileImage: null,
        isVerified: true,
        cyclePosition: 1,
        hasReceivedPayout: false,
      ),
      const Member(
        id: '2',
        name: 'Sara Mohamed',
        profileImage: null,
        isVerified: true,
        cyclePosition: 2,
        hasReceivedPayout: false,
      ),
      const Member(
        id: '3',
        name: 'Omar Hassan',
        profileImage: null,
        isVerified: false,
        cyclePosition: 3,
        hasReceivedPayout: false,
      ),
      const Member(
        id: '4',
        name: 'Fatima Ibrahim',
        profileImage: null,
        isVerified: true,
        cyclePosition: 4,
        hasReceivedPayout: false,
      ),
      const Member(
        id: '5',
        name: 'Khaled Mahmoud',
        profileImage: null,
        isVerified: true,
        cyclePosition: 5,
        hasReceivedPayout: false,
      ),
    ];

    if (includeUser) {
      final user = getMockUser();
      members.add(Member(
        id: user.id,
        name: user.name,
        profileImage: user.profileImage,
        isVerified: true,
        cyclePosition: 3,
        hasReceivedPayout: false,
      ));
    }

    return members;
  }

  static List<RoscaSlot> getMockSlots(
      {required int totalSlots,
      required DateTime startDate,
      required RoscaDuration duration}) {
    final members = getMockMembers();
    final slots = <RoscaSlot>[];

    // Calculate interval between payments
    int monthsInterval;
    switch (duration) {
      case RoscaDuration.monthly:
        monthsInterval = 1;
        break;
      case RoscaDuration.quarterly:
        monthsInterval = 3;
        break;
      case RoscaDuration.biMonthly:
        monthsInterval = 2;
        break;
    }

    for (int i = 0; i < totalSlots; i++) {
      final date = DateTime(
        startDate.year,
        startDate.month + (i * monthsInterval),
        startDate.day,
      );

      // Assign members to first few slots
      final isAssigned = i < members.length;
      final isAvailable = !isAssigned;
      final isPast = date.isBefore(DateTime.now());

      slots.add(RoscaSlot(
        id: 'slot_$i',
        date: date,
        assignedMember: isAssigned ? members[i % members.length] : null,
        isAvailable: isAvailable,
        isPast: isPast,
      ));
    }

    return slots;
  }

  static List<Rosca> getMockRoscas() {
    final now = DateTime.now();
    final user = getMockUser();

    return [
      // Available ROSCAs to join
      Rosca(
        id: '1',
        title: 'Monthly Savings Circle',
        amount: 200, // OMR 200
        currency: 'OMR',
        duration: RoscaDuration.monthly,
        category: RoscaCategory.recommend,
        status: RoscaStatus.upcoming,
        totalSlots: 20,
        availableSlots: 15,
        fees: 5, // OMR 5
        members: getMockMembers().take(5).toList(),
        slots: getMockSlots(
          totalSlots: 20,
          startDate: now.add(const Duration(days: 10)),
          duration: RoscaDuration.monthly,
        ),
        startDate: now.add(const Duration(days: 10)),
        endDate: DateTime(now.year + 1, now.month + 8, now.day),
        nextPaymentDate: now.add(const Duration(days: 10)),
        nextCollector: getMockMembers().first,
        currentCycle: 1,
        isUserMember: false,
        isFull: false,
        description: 'A great way to save money monthly with a trusted group.',
      ),

      Rosca(
        id: '2',
        title: 'High Value Circle',
        amount: 500, // OMR 500
        currency: 'OMR',
        duration: RoscaDuration.monthly,
        category: RoscaCategory.highDemand,
        status: RoscaStatus.upcoming,
        totalSlots: 10,
        availableSlots: 3,
        fees: 15, // OMR 15
        members: getMockMembers(),
        slots: getMockSlots(
          totalSlots: 10,
          startDate: now.add(const Duration(days: 5)),
          duration: RoscaDuration.monthly,
        ),
        startDate: now.add(const Duration(days: 5)),
        endDate: DateTime(now.year, now.month + 10, now.day),
        currentCycle: 1,
        isUserMember: false,
        isFull: false,
        description: 'High-value savings circle for serious savers.',
      ),

      Rosca(
        id: '3',
        title: 'Quarterly Investment',
        amount: 150, // OMR 150
        currency: 'OMR',
        duration: RoscaDuration.quarterly,
        category: RoscaCategory.discoverMore,
        status: RoscaStatus.upcoming,
        totalSlots: 8,
        availableSlots: 5,
        fees: 8, // OMR 8
        members: getMockMembers().take(3).toList(),
        slots: getMockSlots(
          totalSlots: 8,
          startDate: now.add(const Duration(days: 15)),
          duration: RoscaDuration.quarterly,
        ),
        startDate: now.add(const Duration(days: 15)),
        endDate: DateTime(now.year + 2, now.month, now.day),
        currentCycle: 1,
        isUserMember: false,
        isFull: false,
        description: 'Perfect for long-term quarterly savings.',
      ),

      // User's active ROSCA
      Rosca(
        id: '4',
        title: 'My Active Circle',
        amount: 100, // OMR 100
        currency: 'OMR',
        duration: RoscaDuration.monthly,
        category: RoscaCategory.recommend,
        status: RoscaStatus.active,
        totalSlots: 12,
        availableSlots: 0,
        fees: 3, // OMR 3
        members: getMockMembers(includeUser: true).take(6).toList(),
        slots: getMockSlots(
          totalSlots: 12,
          startDate: now.subtract(const Duration(days: 60)),
          duration: RoscaDuration.monthly,
        ),
        startDate: now.subtract(const Duration(days: 60)),
        endDate: DateTime(now.year, now.month + 10, now.day),
        nextPaymentDate: now.add(const Duration(days: 5)),
        nextCollector: getMockMembers()[1],
        currentCycle: 3,
        isUserMember: true,
        isFull: true,
        userInfo: UserRoscaInfo(
          cyclePosition: 3,
          nextPaymentDate: now.add(const Duration(days: 5)),
          payoutDate:
              now.add(const Duration(days: 35)), // User's payout is cycle 3
          totalPaid: 206, // 2 cycles paid (100 + 3) * 2
          totalToSave: 1236, // (100 + 3) * 12
          hasReceivedPayout: false,
          cyclesRemaining: 9,
        ),
        description: 'Your active monthly savings circle.',
      ),

      // User's upcoming payout ROSCA
      Rosca(
        id: '5',
        title: 'Quick Win Circle',
        amount: 75, // OMR 75
        currency: 'OMR',
        duration: RoscaDuration.monthly,
        category: RoscaCategory.highDemand,
        status: RoscaStatus.active,
        totalSlots: 6,
        availableSlots: 0,
        fees: 2, // OMR 2
        members: getMockMembers(includeUser: true).take(6).toList(),
        slots: getMockSlots(
          totalSlots: 6,
          startDate: now.subtract(const Duration(days: 30)),
          duration: RoscaDuration.monthly,
        ),
        startDate: now.subtract(const Duration(days: 30)),
        endDate: DateTime(now.year, now.month + 5, now.day),
        nextPaymentDate: now.add(const Duration(days: 15)),
        nextCollector: getMockMembers(includeUser: true)[5], // User is next!
        currentCycle: 2,
        isUserMember: true,
        isFull: true,
        userInfo: UserRoscaInfo(
          cyclePosition: 2,
          nextPaymentDate: now.add(const Duration(days: 15)),
          payoutDate:
              now.add(const Duration(days: 15)), // User's payout is next!
          totalPaid: 77, // 1 cycle paid (75 + 2)
          totalToSave: 462, // (75 + 2) * 6
          hasReceivedPayout: false,
          cyclesRemaining: 4,
        ),
        description: 'You\'re getting paid next month!',
      ),
    ];
  }

  // Get user's ROSCAs (both active and completed)
  static List<Rosca> getUserRoscas() {
    return getMockRoscas().where((rosca) => rosca.isUserMember).toList();
  }

  // Get available ROSCAs to join
  static List<Rosca> getAvailableRoscas() {
    return getMockRoscas()
        .where((rosca) => !rosca.isUserMember && !rosca.isFull)
        .toList();
  }
}
