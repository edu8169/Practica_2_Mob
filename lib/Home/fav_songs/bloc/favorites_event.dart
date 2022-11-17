part of 'favorites_bloc.dart';

@immutable
abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();
  @override
  List<Object> get props => [];
}

class OnAddFavorite extends FavoritesEvent {
  final song;

  OnAddFavorite({
    required this.song,
  });

  @override
  List<Object> get props => [];
}

/*class ReadFileEvent extends FavoritesEvent {
  final String fileTitle;
  final String storageName;

  ReadFileEvent({
    required this.fileTitle,
    required this.storageName,
  });
  @override
  List<Object> get props => [fileTitle, storageName];
}*/

class OnDeleteFavorite extends FavoritesEvent {
  final song;

  OnDeleteFavorite({
    required this.song,
  });

  @override
  List<Object> get props => [];
}
