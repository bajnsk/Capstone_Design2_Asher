import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';






Future<UserCredential?> signInWithGoogle() async {
  try {
    // Google 로그인 시작
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
      clientId: '899195973843-f530dmrhbmvtqtt2daeqe9pv6slkprfa.apps.googleusercontent.com',
    ).signIn();

    // 사용자가 Google 로그인을 취소한 경우 처리
    if (googleUser == null) {
      print('Google 로그인이 취소되었습니다.');
      return null;
    }

    // Google 로그인에 성공한 경우
    final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    final User? user = userCredential.user;

    // 로그인에 성공한 사용자 정보 출력
    print('Google 로그인 성공: ${user?.displayName}');

    return userCredential;
  } catch (e) {
    print('Google 로그인 오류: $e');
    return null;
  }
}


//871697957388-ujfam08p06kaec6nfcojrt2av28al2q2.apps.googleusercontent.com
//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
