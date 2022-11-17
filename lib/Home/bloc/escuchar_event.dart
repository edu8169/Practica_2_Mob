part of 'escuchar_bloc.dart';

@immutable
abstract class EscucharEvent extends Equatable {
  const EscucharEvent();
  @override
  List<Object> get props => [];
}

class OnEscucharEvent extends EscucharEvent {}

class OnTerminarAntesEvent extends EscucharEvent {}

class EscucharEndEvent extends EscucharEvent {
  const EscucharEndEvent();
  @override
  List<Object> get props => [];
}
