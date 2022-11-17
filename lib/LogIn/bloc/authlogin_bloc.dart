import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import '../UserAuthRepository.dart';

part 'authlogin_event.dart';
part 'authlogin_state.dart';

class AuthloginBloc extends Bloc<AuthloginEvent, AuthloginState> {
  UserAuthRepository _authRepository = UserAuthRepository();

  AuthloginBloc() : super(AuthloginInitial()) {
    on<VerifyAuthEvent>(_authVerfication);
    on<GoogleAuthEvent>(_authUser);
    on<SignOutEvent>(_signOut);
  }

  FutureOr<void> _authVerfication(event, emit) {
    // inicializar datos de la app
    if (_authRepository.isAlreadyAuthenticated()) {
      emit(AuthSuccessState());
    } else {
      emit(UnAuthState());
    }
  }

  FutureOr<void> _signOut(event, emit) async {
    if (FirebaseAuth.instance.currentUser!.isAnonymous) {
      await _authRepository.signOutFirebaseUser();
    } else {
      await _authRepository.signOutGoogleUser();
      await _authRepository.signOutFirebaseUser();
    }
    emit(SignOutSuccessState());
  }

  FutureOr<void> _authUser(event, emit) async {
    emit(AuthAwaitingState());
    try {
      await _authRepository.signInWithGoogle();
      emit(AuthSuccessState());
    } catch (e) {
      print("Error al autenticar: $e");
      emit(AuthErrorState());
    }
  }
}
