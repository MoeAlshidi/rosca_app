import '../models/user.dart';
import '../models/rosca.dart';
import '../models/member.dart';
import '../models/rosca_slot.dart';

class MockDataService {
  static User getMockUser() {
    return const User(
      id: '1',
      name: 'Nour Ramy',
      email: 'nour.ramy@example.com',
      phoneNumber: '+20123456789',
      profileImage: null,
      isHrLetterVerified: true,
      isUtilityBillVerified: true,
      isNationalIdVerified: true,
      isIncomeInfoVerified: true,
      isMobileNumberVerified: true,
    );
  }

  static List<Member> getMockMembers() {
    return [
      const Member(
        id: '1',
        name: 'Ahmed Ali',
        profileImage: null,
        isVerified: true,
      ),
      const Member(
        id: '2',
        name: 'Sara Mohamed',
        profileImage: null,
        isVerified: true,
      ),
      const Member(
        id: '3',
        name: 'Omar Hassan',
        profileImage: null,
        isVerified: false,
      ),
      const Member(
        id: '4',
        name: 'Fatima Ibrahim',
        profileImage: null,
        isVerified: true,
      ),
      const Member(
        id: '5',
        name: 'Khaled Mahmoud',
        profileImage: null,
        isVerified: true,
      ),
    ];
  }

  static List<RoscaSlot> getMockSlots() {
    final members = getMockMembers();
    final now = DateTime.now();
    final slots = <RoscaSlot>[];

    for (int i = 0; i < 20; i++) {
      final date = DateTime(now.year, now.month + i, 19);
      final isAssigned = i < 5;
      final isAvailable = !isAssigned && i >= 5;

      slots.add(RoscaSlot(
        id: 'slot_$i',
        date: date,
        assignedMember: isAssigned ? members[i % members.length] : null,
        isAvailable: isAvailable,
        isPast: i < 2,
      ));
    }

    return slots;
  }

  static List<Rosca> getMockRoscas() {
    final members = getMockMembers();
    final slots = getMockSlots();

    return [
      Rosca(
        id: '1',
        title: 'Monthly Savings Circle',
        amount: 500000,
        currency: 'EGP',
        duration: RoscaDuration.monthly,
        category: RoscaCategory.recommend,
        totalSlots: 20,
        availableSlots: 15,
        fees: 15,
        members: members.take(5).toList(),
        slots: slots,
        startDate: DateTime.now().add(const Duration(days: 10)),
        nextPaymentDate: DateTime.now().add(const Duration(days: 10)),
        nextCollector: members.first,
        isUserMember: false,
        isFull: false,
      ),
      Rosca(
        id: '2',
        title: 'High Value Circle',
        amount: 1000000,
        currency: 'EGP',
        duration: RoscaDuration.monthly,
        category: RoscaCategory.highDemand,
        totalSlots: 10,
        availableSlots: 3,
        fees: 25,
        members: members,
        slots: slots.take(10).toList(),
        startDate: DateTime.now().add(const Duration(days: 5)),
        isUserMember: false,
        isFull: false,
      ),
      Rosca(
        id: '3',
        title: 'Quarterly Investment',
        amount: 60000,
        currency: 'EGP',
        duration: RoscaDuration.quarterly,
        category: RoscaCategory.discoverMore,
        totalSlots: 8,
        availableSlots: 5,
        fees: 10,
        members: members.take(3).toList(),
        slots: slots.take(8).toList(),
        startDate: DateTime.now().add(const Duration(days: 15)),
        isUserMember: false,
        isFull: false,
      ),
      Rosca(
        id: '4',
        title: 'My Active Circle',
        amount: 200000,
        currency: 'EGP',
        duration: RoscaDuration.monthly,
        category: RoscaCategory.recommend,
        totalSlots: 12,
        availableSlots: 0,
        fees: 12,
        members: members.take(4).toList(),
        slots: slots.take(12).toList(),
        startDate: DateTime.now().subtract(const Duration(days: 30)),
        nextPaymentDate: DateTime.now().add(const Duration(days: 5)),
        nextCollector: members[1],
        isUserMember: true,
        isFull: true,
      ),
    ];
  }
} 