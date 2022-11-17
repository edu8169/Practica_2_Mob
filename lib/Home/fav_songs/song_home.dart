import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica_1/Home/fav_songs/bloc/favorites_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class SongHome extends StatefulWidget {
  final song;
  SongHome({Key? key, required this.song}) : super(key: key);

  @override
  State<SongHome> createState() => _SongHomeState();
}

class _SongHomeState extends State<SongHome> {
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
    )) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _isFavorite = widget.song["is_favorite"];
    return Scaffold(
      appBar: AppBar(
        title: Text('Here you go'),
        actions: [
          BlocConsumer<FavoritesBloc, FavoritesState>(
            listener: (context, state) {
              if (state is AddToFavorite) {
                widget.song["is_favorite"] = true;
                _isFavorite = true;
                setState(() {});
              } else if (state is DeleteFromFavorite) {
                widget.song["is_favorite"] = false;
                _isFavorite = false;
                setState(() {});
              }
            },
            builder: (context, state) {
              print(_isFavorite);
              return IconButton(
                tooltip: "Add to favorites",
                onPressed: () {
                  if (_isFavorite) {
                    BlocProvider.of<FavoritesBloc>(context)
                        .add(OnDeleteFavorite(song: widget.song));
                    widget.song["is_favorite"] = false;
                    _isFavorite = false;
                    setState(() {});
                  } else {
                    BlocProvider.of<FavoritesBloc>(context)
                        .add(OnAddFavorite(song: widget.song));
                    widget.song["is_favorite"] = true;
                    _isFavorite = true;
                    setState(() {});
                  }
                },
                icon: _isFavorite == true
                    ? Icon(Icons.favorite)
                    : Icon(Icons.favorite_border),
              );
            },
          ),
        ],
      ),
      body: Container(
        child: BlocConsumer<FavoritesBloc, FavoritesState>(
          listener: (context, state) {
            if (state is AddToFavorite) {
              setState(() {});
            } else if (state is DeleteFromFavorite) {
              setState(() {});
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 16,
                  child: Image.network(
                    "${widget.song["image"]["url"]}",
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 40.0),
                Text("${widget.song["song_name"]}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                Text(
                  "${widget.song["album"]}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "${widget.song["artist"]}",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 19),
                ),
                Text(
                  "${widget.song["release_date"]}",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                SizedBox(height: 20.0),
                Divider(),
                Text(
                  "Abrir con: ",
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
                SizedBox(height: 20.0),
                if (widget.song["spotify_link"] != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _launchInBrowser(
                              Uri.parse(widget.song["spotify_link"]));
                        },
                        child: Image.asset(
                          "assets/spotify.png",
                          width: 40,
                          height: 40,
                        ),
                        style: ElevatedButton.styleFrom(
                          shadowColor: Colors.transparent,
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(10),
                          primary: Colors.transparent, // <-- Button color
                          onPrimary: Colors.transparent, // <-- Splash color
                        ),
                      ),
                      if (widget.song["song_link"] != null)
                        ElevatedButton(
                          onPressed: () {
                            _launchInBrowser(
                                Uri.parse(widget.song["song_link"]));
                          },
                          child: Image.asset(
                            "assets/dj.png",
                            width: 40,
                            height: 40,
                          ),
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.transparent,
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(10),
                            primary: Colors.transparent, // <-- Button color
                            onPrimary: Colors.transparent, // <-- Splash color
                          ),
                        ),
                      if (widget.song["apple_link"] != null)
                        ElevatedButton(
                          onPressed: () {
                            _launchInBrowser(
                                Uri.parse(widget.song["apple_link"]));
                          },
                          child: Image.asset(
                            "assets/apple.png",
                            width: 40,
                            height: 40,
                          ),
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.transparent,
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(10),
                            primary: Colors.transparent, // <-- Button color
                            onPrimary: Colors.transparent, // <-- Splash color
                          ),
                        ),
                    ],
                  )
              ],
            );
          },
        ),
      ),
    );
  }
}
