import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import 'bloc/favorites_bloc.dart';

class SongElement extends StatefulWidget {
  final data;
  final id;
  SongElement({Key? key, required this.data, required this.id})
      : super(key: key);
  @override
  State<SongElement> createState() => _SongElementState();
}

class _SongElementState extends State<SongElement> {
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
    )) {
      throw 'Could not launch $url';
    }
  }

  showAlertDialog(BuildContext context, var song) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancelar"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continuar"),
      onPressed: () {
        BlocProvider.of<FavoritesBloc>(context)
            .add(OnDeleteFavorite(song: song));
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Eliminar de favoritos"),
      content: Text(
          "El elemento sera eliminado de tus favoritos. Quieres continuar?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // set up the AlertDialog

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showNaviagteDialog(BuildContext context, var song) {
    Widget cancelButton = TextButton(
      child: Text("Cancelar"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget redirectButton = TextButton(
      child: Text("Continuar"),
      onPressed: () {
        _launchInBrowser(Uri.parse(song["song_link"]));
      },
    );
    AlertDialog navigate = AlertDialog(
      title: Text("Abrir cancion"),
      content:
          Text("Sera redirigido para abrir la cancion. Quieres Continuar?"),
      actions: [
        cancelButton,
        redirectButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return navigate;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {showNaviagteDialog(context, widget.data["song"])},
      child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(mainAxisSize: MainAxisSize.max, children: [
            Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                width: 290.0,
                height: 270.0,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.7), BlendMode.dstATop),
                        image: NetworkImage(
                          "${widget.data["song"]["image"]["url"]}",
                        ),
                        fit: BoxFit.cover)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        onPressed: () {
                          showAlertDialog(context, widget.data["song"]);
                        },
                        icon: Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.indigo.withOpacity(0.8),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(25.0),
                          topLeft: Radius.zero,
                          bottomLeft: Radius.zero,
                          bottomRight: Radius.zero,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  "${widget.data["song"]["song_name"]}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                Text("${widget.data["song"]["artist"]}"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ])),
    );
  }
}
