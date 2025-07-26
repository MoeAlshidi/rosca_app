import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/rosca.dart';
import 'mock_data_service.dart';

class ApiService {
  late final Dio _dio;
  static const String _baseUrl = 'https://api.roscaapp.com';

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
    ));
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<User> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    await _saveToken('mock_token_${DateTime.now().millisecondsSinceEpoch}');
    return MockDataService.getMockUser();
  }

  Future<User> register({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    await _saveToken('mock_token_${DateTime.now().millisecondsSinceEpoch}');
    return MockDataService.getMockUser();
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await _removeToken();
  }

  Future<User> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockDataService.getMockUser();
  }

  Future<List<Rosca>> getUserRoscas() async {
    await Future.delayed(const Duration(seconds: 1));
    return MockDataService.getMockRoscas()
        .where((rosca) => rosca.isUserMember)
        .toList();
  }

  Future<List<Rosca>> getAvailableRoscas({
    RoscaDuration? duration,
    RoscaCategory? category,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    var roscas = MockDataService.getMockRoscas()
        .where((rosca) => !rosca.isUserMember)
        .toList();

    if (duration != null) {
      roscas = roscas.where((rosca) => rosca.duration == duration).toList();
    }

    if (category != null) {
      roscas = roscas.where((rosca) => rosca.category == category).toList();
    }

    return roscas;
  }

  Future<Rosca> getRoscaDetails(String roscaId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockDataService.getMockRoscas()
        .firstWhere((rosca) => rosca.id == roscaId);
  }

  Future<void> joinRosca(String roscaId, String slotId) async {
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<void> leaveRosca(String roscaId) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> updateUserVerification({
    bool? isHrLetterVerified,
    bool? isUtilityBillVerified,
    bool? isNationalIdVerified,
    bool? isIncomeInfoVerified,
    bool? isMobileNumberVerified,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
  }
} 