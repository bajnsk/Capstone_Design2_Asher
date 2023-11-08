import 'package:capstone/Home/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// 로그인

class AuthController{
  void navigateToHome(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => HomeWidget(),
      // 뒤로 가기 버튼을 숨기려면 아래 코드를 추가합니다.
      settings: RouteSettings(name: '/menu'),
    ));
  }
}

Future<User?> signInWithEmailAndPassword(
    String email, String password) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = userCredential.user;
    print(user);
    return user;
  } catch (e) {
    // 로그인 실패 처리
    print(e.toString());
    return null;
  }
}

Future<User?> signUpWithEmailAndPassword(String email, String password) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = userCredential.user;
    return user;
  } catch (e) {
    // 회원 가입 실패 처리
    print(e.toString());
    return null;
  }
}
