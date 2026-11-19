import 'dart:async';
import 'package:the_secret_boutique/core/constants/app_images.dart';
import 'package:the_secret_boutique/data/models/user_model.dart';

class AuthRepository {
  UserModel? _currentUser;

  String? _pendingPhone;
  String _generatedOtp = '1234';

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  String get currentOtp => _generatedOtp;

  /// Send OTP to user phone
  Future<bool> sendOtp(String phone) async {
    await Future.delayed(const Duration(milliseconds: 700));
    _pendingPhone = phone;
    _generatedOtp = '1234'; // Demo verification code
    return true;
  }

  /// Verify OTP
  Future<UserModel> verifyOtp(String otp, {String? name, String? email}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (otp != _generatedOtp && otp.length != 4) {
      throw Exception('Invalid OTP code. Use 1234 for demo.');
    }

    _currentUser = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: name ?? _currentUser?.name ?? 'Awantika Yadav',
      email: email ?? _currentUser?.email ?? 'awantika@gmail.com',
      phone: _pendingPhone ?? '+91 98765 43210',
      avatarUrl: AppImages.defaultAvatar,
    );
    return _currentUser!;
  }

  /// Direct Login with credentials
  Future<UserModel> login({required String phoneOrEmail, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 700));
    _currentUser = UserModel(
      id: 'user_01',
      name: 'Awantika Yadav',
      email: phoneOrEmail.contains('@') ? phoneOrEmail : 'awantika@gmail.com',
      phone: phoneOrEmail.contains('@') ? '+91 98765 43210' : phoneOrEmail,
      avatarUrl: AppImages.defaultAvatar,
    );
    return _currentUser!;
  }

  /// Register new user and initiate OTP verification
  Future<bool> register({
    required String name,
    required String phone,
    required String email,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));
    _pendingPhone = phone;
    _generatedOtp = '1234';
    return true;
  }

  /// Update user profile
  Future<UserModel> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = UserModel(
      id: _currentUser?.id ?? 'user_01',
      name: name,
      email: email,
      phone: phone,
      avatarUrl: _currentUser?.avatarUrl ?? AppImages.defaultAvatar,
    );
    return _currentUser!;
  }

  /// Log out
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
  }
}
