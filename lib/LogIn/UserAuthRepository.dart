import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserAuthRepository {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ["email"]);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // true -> go home page
  // false -> go login page
  bool isAlreadyAuthenticated() {
    return _auth.currentUser != null;
  }

  Future<void> signOutGoogleUser() async {
    await _googleSignIn.signOut();
  }

  Future<void> signOutFirebaseUser() async {
    await _auth.signOut();
  }

  Future<void> signInWithGoogle() async {
    //Google sign in
    final googleUser = await _googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;

    // credenciales de usuario autenticado con Google
    print(
        "------------------------------------------------------- Auth login 1");
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // firebase sign in con credenciales de Google
    final authResult = await _auth.signInWithCredential(credential);

    // Extraer token**
    print(
        "--------------------------------------------------------Auth login 2");
    User user = authResult.user!;
    final firebaseToken = await user.getIdToken();
    await _createUserCollectionFirebase(_auth.currentUser!.uid, googleUser);
  }
}

Future<void> _createUserCollectionFirebase(String uid, googleUser) async {
  var userDoc =
      await FirebaseFirestore.instance.collection("user").doc(uid).get();
  if (!userDoc.exists) {
    await FirebaseFirestore.instance.collection("user").doc(uid).set(
        {"photo_url": googleUser.photoUrl, "username": googleUser.displayName});
  } else {
    return;
  }
}
