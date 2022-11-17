part of 'authlogin_bloc.dart';

abstract class AuthloginState extends Equatable {
  const AuthloginState();

  @override
  List<Object> get props => [];
}

class AuthloginInitial extends AuthloginState {}

class AuthSuccessState extends AuthloginState {}

class UnAuthState extends AuthloginState {}

class SignOutSuccessState extends AuthloginState {}

class AuthErrorState extends AuthloginState {}

class AuthAwaitingState extends AuthloginState {}
