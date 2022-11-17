part of 'escuchar_bloc.dart';

@immutable
abstract class EscucharState extends Equatable {
  const EscucharState();

  @override
  List<Object> get props => [];
}

class EscucharInitial extends EscucharState {}

class EscucharError extends EscucharState {}

class EscucharEnd extends EscucharState {
  final Map<String, dynamic> song;
  EscucharEnd({required this.song});

  @override
  List<Object> get props => [];
}

class EscucharLoading extends EscucharState {}
