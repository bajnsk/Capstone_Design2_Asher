import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleLogin extends StatelessWidget {
  const GoogleLogin({required Key key}) : super(key: key);

  static Future<UserCredential?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      // 사용자가 Google Sign-In을 취소하거나 실패한 경우
      return null; // 또는 적절한 에러 처리 로직을 추가하세요.
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    if (googleAuth == null) {
      // Google 인증 정보를 얻을 수 없는 경우
      return null; // 또는 적절한 에러 처리 로직을 추가하세요.
    }

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SNS Login"),
      ),
      body: Column(
        children: [
          TextButton(
            child: Text("Google Login"),
            onPressed:signInWithGoogle,
          ),
        ],
      ),
    );
  }
}