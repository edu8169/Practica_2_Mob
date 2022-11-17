part of 'favorites_bloc.dart';

@immutable
abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object> get props => [];
}

class AddToFavorite extends FavoritesState {}

class DeleteFromFavorite extends FavoritesState {}

class FavoritesInitial extends FavoritesState {}

/*class ReadFileErrorState extends FavoritesState {
  final String error;

  ReadFileErrorState({required this.error});
  @override
  List<Object> get props => [error];
}

class ReadFileSuccessState extends FavoritesState {
  final String fileContent;

  ReadFileSuccessState({required this.fileContent});
  @override
  List<Object> get props => [fileContent];
}*/
