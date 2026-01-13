import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signUpUser({
    required String? email,
    required String? password,
  }) async {
    String result = 'Authentication is NOT successful.';
    try {
      if (email!.isNotEmpty || password!.isNotEmpty) {
        await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password!,
        );
        result = 'success';
      }
    } catch (err) {
      result = err.toString();
    }
    return result;
  }

  Future<String> logInUser({
    required String email,
    required String password,
  }) async {
    String result = 'Login is NOT successful.';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        saveLoginSession();
        result = 'success';
      }
    } catch (err) {
      result = err.toString();
    }
    return result;
  }

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null; // ผู้ใช้ยกเลิก

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    saveLoginSession();

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signOutUser() async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    final prefs = await SharedPreferences.getInstance();

    if (user != null) {
      for (var info in user.providerData) {
        switch (info.providerId) {
          case 'google.com':
            await prefs.clear();
            await GoogleSignIn().signOut();
            break;
        }
      }

      await prefs.clear();
      await auth.signOut();
    }
  }

  void saveLoginSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }
}
