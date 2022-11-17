part of 'authlogin_bloc.dart';

abstract class AuthloginEvent extends Equatable {
  const AuthloginEvent();

  @override
  List<Object> get props => [];
}

class VerifyAuthEvent extends AuthloginEvent {}

class AnonymousAuthEvent extends AuthloginEvent {}

class GoogleAuthEvent extends AuthloginEvent {}

class SignOutEvent extends AuthloginEvent {}
