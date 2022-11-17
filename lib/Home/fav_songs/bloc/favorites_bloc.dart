import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(FavoritesInitial()) {
    on<OnAddFavorite>(add_favorite);
    on<OnDeleteFavorite>(delete_favorite);
  }

  FutureOr<void> add_favorite(event, emit) async {
    try {
      String song_header =
          "${event.song["artist"]} - ${event.song["album"]} - ${event.song["song_name"]}";
      var queryUser = await FirebaseFirestore.instance
          .collection("user_songs")
          .where("user_id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where("header", isEqualTo: song_header);

      var docsRef = await queryUser.get();
      if (docsRef.docs.isEmpty) {
        Map<String, dynamic> upload = {
          "user_id": FirebaseAuth.instance.currentUser!.uid,
          "header": song_header
        };
        upload["song"] = event.song;
        await FirebaseFirestore.instance.collection("user_songs").add(upload);
      }
      emit(AddToFavorite());
    } catch (e) {
      print(e);
    }
  }

  /*FutureOr<void> _readFileFromStorage(ReadFileEvent event, emit) async {
    switch (event.storageName) {
      case "tempDirectory":
        var _tempDir = await getTemporaryDirectory();
        var _fileContent = await _readFile(event.fileTitle, _tempDir);
        emit(ReadFileSuccessState(fileContent: _fileContent));
        break;
      case "externalStorageDirectory":
        if (!await _requestStoragePermission()) {
          emit(ReadFileErrorState(
              error: "Se requiere permiso para leer del almacenamiento"));
        } else {
          var _extDir = await getExternalStorageDirectory();
          var _fileContent = await _readFile(event.fileTitle, _extDir!);

          emit(ReadFileSuccessState(fileContent: _fileContent));
        }
        break;
      default:
    }
  }*/

  FutureOr<void> delete_favorite(event, emit) async {
    try {
      String song_header =
          "${event.song["artist"]} - ${event.song["album"]} - ${event.song["song_name"]}";
      // query para traer el documento con el id del usuario autenticado
      var queryUser = await FirebaseFirestore.instance
          .collection("user_songs")
          .where("user_id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where("header", isEqualTo: song_header);
      // query para sacar la data del documento
      var docsRef = await queryUser.get();
      if (docsRef.docs.isNotEmpty) {
        FirebaseFirestore.instance
            .collection("user_songs")
            .doc(docsRef.docs.first.id)
            .delete();
      }
      emit(DeleteFromFavorite());
    } catch (e) {}
  }
  /*Future<bool> _requestStoragePermission() async {
    var permiso = await Permission.storage.status;
    if (permiso == PermissionStatus.denied) {
      await Permission.storage.request();
    }
    return permiso == PermissionStatus.granted;
  }

  Future<void> _saveFile(String _title, String _content, Directory dir) async {
    if (!await _requestStoragePermission()) {
      throw Exception();
    }
    // crear y escribir archivo
    final File file = File("${dir.path}/$_title.txt");
    await file.writeAsString(_content);
  }

  Future<String> _readFile(String _title, Directory dir) async {
    String _content = "Not found";
    try {
      final File file = File("${dir.path}/$_title.txt");
      _content = await file.readAsString();
      return _content;
    } catch (e) {
      return _content;
    }
  }*/
}
