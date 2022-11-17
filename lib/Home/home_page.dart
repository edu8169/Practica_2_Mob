import 'dart:async';

import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/escuchar_bloc.dart';
import 'fav_songs/favorite_songs.dart';
import 'fav_songs/song_home.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _title = "Presione para escuchar";
  bool _listening = false;
  bool _escuchando = false;
  late Timer t;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: BlocConsumer<EscucharBloc, EscucharState>(
                listener: (context, state) {
      if (state is EscucharLoading) {
        _title = "Escuchando...";
        _escuchando = true;
        setState(() {});
      } else if (state is EscucharEnd) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SongHome(song: state.song),
        ));
      } else {
        _title = "Toque para escuchar";
        _escuchando = false;
        setState(() {});
      }
    }, builder: (context, state) {
      return Column(children: [
        SizedBox(height: 80),
        Text(
          _title,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        SizedBox(height: 50),
        AvatarGlow(
          animate: _listening,
          glowColor: Colors.indigo,
          repeatPauseDuration: Duration(milliseconds: 200),
          duration: Duration(milliseconds: 500),
          endRadius: 180.0,
          showTwoGlows: true,
          child: Material(
            elevation: 16.0,
            shape: CircleBorder(),
            child: GestureDetector(
              onTap: () {
                if (state is EscucharLoading) {
                  BlocProvider.of<EscucharBloc>(context)
                      .add(OnTerminarAntesEvent());
                  t.cancel();
                } else {
                  BlocProvider.of<EscucharBloc>(context).add(OnEscucharEvent());
                  t = Timer(Duration(seconds: 6), () {
                    BlocProvider.of<EscucharBloc>(context)
                        .add(EscucharEndEvent());
                  });
                }
              },
              child: CircleAvatar(
                backgroundColor: Colors.grey[100],
                child: Image.asset(
                  'assets/logo.png',
                  height: 90,
                ),
                radius: 90,
              ),
            ),
          ),
        ),
        SizedBox(height: 50),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => FavoriteSongs()));
            },
            child: Icon(Icons.favorite, color: Colors.black),
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(10),
              primary: Colors.white, // <-- Button color
              onPrimary: Colors.red, // <-- Splash color
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Icon(Icons.power_settings_new, color: Colors.black),
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(10),
              primary: Colors.white, // <-- Button color
              onPrimary: Colors.red, // <-- Splash color
            ),
          ),
        ])
      ]);
    })));
  }
}
