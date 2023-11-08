import 'package:capstone/Appbar/v_appbar_widget.dart';
import 'package:capstone/login_page/providers/auth/auth_provider.dart';
import 'package:capstone/login_page/repositories/auth_repository.dart';
import 'package:capstone/login_page/repositories/feed_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:capstone/login_page/LoginPage.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'MainPage/main_page.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'login_page/providers/auth/auth_state.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthRepository>(
          create: (context) => AuthRepository(
            firebaseAuth: FirebaseAuth.instance,
            firebaseFirestore: FirebaseFirestore.instance,
            firebaseStorage: FirebaseStorage.instance,
          ),
        ),
        Provider<FeedRepository>(
          create: (context) => FeedRepository(
            firebaseFirestore: FirebaseFirestore.instance,
            firebaseStorage: FirebaseStorage.instance,
          ),
        ),
        StateNotifierProvider<AuthProvider, AuthState>(
          create: (context) => AuthProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Asher',
        debugShowCheckedModeBanner: false, // 디버그 표시 제거
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginPage(),
      ),
    );
  }
}
