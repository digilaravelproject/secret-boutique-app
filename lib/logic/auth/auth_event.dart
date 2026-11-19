import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthSendOtpRequested extends AuthEvent {
  final String phone;

  const AuthSendOtpRequested(this.phone);

  @override
  List<Object?> get props => [phone];
}

class AuthVerifyOtpRequested extends AuthEvent {
  final String otp;
  final String? name;
  final String? email;

  const AuthVerifyOtpRequested({
    required this.otp,
    this.name,
    this.email,
  });

  @override
  List<Object?> get props => [otp, name, email];
}

class AuthLoginRequested extends AuthEvent {
  final String phoneOrEmail;
  final String password;

  const AuthLoginRequested({
    required this.phoneOrEmail,
    required this.password,
  });

  @override
  List<Object?> get props => [phoneOrEmail, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String name;
  final String phone;
  final String email;

  const AuthRegisterRequested({
    required this.name,
    required this.phone,
    required this.email,
  });

  @override
  List<Object?> get props => [name, phone, email];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthProfileUpdateRequested extends AuthEvent {
  final String name;
  final String email;
  final String phone;

  const AuthProfileUpdateRequested({
    required this.name,
    required this.email,
    required this.phone,
  });

  @override
  List<Object?> get props => [name, email, phone];
}
