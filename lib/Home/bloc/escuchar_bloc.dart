import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:record/record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
part 'escuchar_event.dart';
part 'escuchar_state.dart';

class EscucharBloc extends Bloc<EscucharEvent, EscucharState> {
  final record = Record();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  EscucharBloc() : super(EscucharInitial()) {
    on<OnEscucharEvent>(escuchando);
    on<EscucharEvent>(end);
    on<OnTerminarAntesEvent>(end_sooner);
  }

  Future<FutureOr<void>> escuchando(event, emit) async {
    await record.hasPermission();
    await record.start();
    emit(EscucharLoading());
  }

  Future<FutureOr<void>> end(event, emit) async {
    String? pathToAudio = await record.stop();
    var bytes = File(pathToAudio!).readAsBytesSync();
    String base64Audio = base64Encode(bytes);
    var url = Uri.parse('https://api.audd.io/');
    var response = await http.post(url, body: {
      'api_token': dotenv.env['api_token'],
      'audio': base64Audio,
      'return': 'apple_music,spotify'
    });
    Map<String, dynamic> jsonData =
        new Map<String, dynamic>.from(json.decode(response.body));
    //Aqui se guarda la cancion, solo no se regresa
    var image;
    var artist;
    var song_name;
    var album;
    var release_date;
    var song_link;
    var spotify_link;
    var apple_link;
    var is_favorite = false;
    try {
      image = jsonData["result"]["spotify"]["album"]["images"][0];
    } catch (e) {
      image =
          "https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png";
    }
    try {
      artist = jsonData["result"]["artist"];
    } catch (e) {
      artist = "Artist not available";
    }
    try {
      song_name = jsonData["result"]["title"];
    } catch (e) {
      song_name = "Song name not available";
    }
    try {
      album = jsonData["result"]["album"];
    } catch (e) {
      album = "Album not available";
    }
    try {
      release_date = jsonData["result"]["release_date"];
    } catch (e) {
      release_date = "Release date not available";
    }
    try {
      song_link = jsonData["result"]["song_link"];
    } catch (e) {
      song_link = null;
    }
    try {
      apple_link = jsonData["result"]["apple_music"]["url"];
    } catch (e) {
      apple_link = null;
    }
    try {
      spotify_link = jsonData["result"]["spotify"]["external_urls"]["spotify"];
    } catch (e) {
      spotify_link = null;
    }

    String song_header = "${artist} - ${album} - ${song_name}";
    var queryUser = await FirebaseFirestore.instance
        .collection("user_songs")
        .where("header", isEqualTo: "${song_header}")
        .where("user_id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (queryUser.docs.isNotEmpty) {
      is_favorite = true;
    }

    Map<String, dynamic> song_details = {
      "image": image,
      "artist": artist,
      "song_name": song_name,
      "album": album,
      "release_date": release_date,
      "song_link": song_link,
      "spotify_link": spotify_link,
      "apple_link": apple_link,
      "is_favorite": is_favorite
    };
    print(song_details);
    if (jsonData["status"] == "success") {
      emit(EscucharEnd(song: song_details));
      emit(EscucharInitial());
    } else {
      emit(EscucharInitial());
    }
  }

  Future<FutureOr<void>> end_sooner(event, emit) async {
    await record.stop();
    record.dispose();
    emit(EscucharInitial());
  }
}
