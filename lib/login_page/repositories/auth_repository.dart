import 'package:capstone/login_page/exceptions/custom_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;
  final FirebaseFirestore firebaseFirestore;

  const AuthRepository({
    required this.firebaseAuth,
    required this.firebaseFirestore,
    required this.firebaseStorage,
  });

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      bool isVerified = userCredential.user!.emailVerified;
      if (!isVerified) {
        await userCredential.user!.sendEmailVerification();
        await firebaseAuth.signOut();
        throw CustomException(
          code: 'Exception',
          message: '인증되지 않은 이메일',
        );
      }
    } on FirebaseException catch (e) {
      throw CustomException(
        code: e.code,
        message: e.message!,
      );
    } catch (e) {
      throw CustomException(
        code: 'Exception',
        message: e.toString(),
      );
    }
  }

  Future<void> signUp({
    required String email,
    required String name,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      await userCredential.user!.sendEmailVerification();

      await firebaseFirestore.collection('users').doc(uid).set({
        'uid': uid,
        'email': email,
        'name': name,
        'feedCount': 0,
        'like': [],
        'followedFeed': [],
        'friends': [],
        'feedId': [],
        'profileImage': 'https://firebasestorage.googleapis.com/v0/b/capstone2-1ad1d.appspot.com/o/icon-profile.png?alt=media&token=4cd1d2a6-de0b-4263-ad8a-a150394a956d',
        'tag': [],
        'status_message' : '',
      });

      firebaseAuth.signOut();
    } on FirebaseException catch (e) {
      throw CustomException(
        code: e.code,
        message: e.message!,
      );
    } catch (e) {
      throw CustomException(
        code: 'Exception',
        message: e.toString(),
      );
    }
  }
}
