import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:practica_1/LogIn/login.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:practica_1/Home/songs/bloc/favorites_bloc.dart';

import 'Home/bloc/escuchar_bloc.dart';
import 'Home/fav_songs/bloc/favorites_bloc.dart';
import 'Home/home_page.dart';
import 'LogIn/bloc/authlogin_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Firebase.initializeApp();

  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (context) => AuthloginBloc()..add(VerifyAuthEvent()),
    ),
    BlocProvider(
      create: (context) => EscucharBloc(),
    ),
    BlocProvider(
      create: (context) => FavoritesBloc(),
    )
  ], child: Main()));
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primaryColorDark: Colors.indigo),
        darkTheme: ThemeData.dark(),
        home: BlocConsumer<AuthloginBloc, AuthloginState>(
            builder: ((context, state) {
          if (state is AuthSuccessState) {
            return HomePage();
          } else if (state is UnAuthState ||
              state is AuthErrorState ||
              state is SignOutSuccessState) {
            return LoginPage();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }), listener: (context, state) {
          const SnackBar(
            content: Text("Favor de autenticarse"),
          );
        }));
  }
}
