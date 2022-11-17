import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica_1/Home/fav_songs/song_element.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/firestore.dart';

import 'bloc/favorites_bloc.dart';

class FavoriteSongs extends StatefulWidget {
  FavoriteSongs({Key? key}) : super(key: key);

  @override
  State<FavoriteSongs> createState() => _FavoriteSongsState();
}

class _FavoriteSongsState extends State<FavoriteSongs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: FirestoreListView(
          query: FirebaseFirestore.instance.collection("user_songs").where(
              "user_id",
              isEqualTo: FirebaseAuth.instance.currentUser!.uid),
          itemBuilder: (BuildContext context,
              QueryDocumentSnapshot<Map<String, dynamic>> document) {
            return SongElement(data: document.data(), id: document.id);
          },
        ));
  }
}

Widget _loadingView() {
  return Center(
    child: CircularProgressIndicator(),
  );
}
