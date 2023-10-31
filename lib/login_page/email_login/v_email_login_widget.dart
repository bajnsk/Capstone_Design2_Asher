import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../google_login/c_google_login_process.dart';

// 이메일 로그인 구현 컨트롤러와 위젯
// getResult 위젯을 mainpagewidget 객체로 교환

showToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

class AuthWidget extends StatefulWidget {
  @override
  AuthWidgetState createState() => AuthWidgetState();
}

class AuthWidgetState extends State<AuthWidget>{
  final _formKey = GlobalKey<FormState>();

  late String email;
  late String password;
  bool isInput = true; //false - result
  bool isSignIn = true; //false - SingUp

  signIn() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        print(value);
        if (value.user!.emailVerified) {
          //이메일 인증 여부
          setState(() {
            isInput = false;
          });
        } else {
          showToast('emailVerified error');
        }
        return value;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showToast('user-not-found');
      } else if (e.code == 'wrong-password') {
        showToast('wrong-password');
      } else {
        print(e.code);
      }
    }
  }

  signOut() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      isInput = true;
    });
  }

  signUp() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        if (value.user!.email != null) {
          FirebaseAuth.instance.currentUser?.sendEmailVerification();
          setState(() {
            isInput = false;
          });
        }
        return value;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showToast('weak-password');
      } else if (e.code == 'email-already-in-use') {
        showToast('email-already-in-use');
      } else {
        showToast('other error');
        print(e.code);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // 로그인 세션이 없을 경우의 화면
  List<Widget> getInputWidget() {
    return [
      Text(
        isSignIn ? "SignIn" : "SignUp",
        style: TextStyle(
          color: Colors.indigo,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        textAlign: TextAlign.center,
      ),
      Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'email'),
              validator: (value) {
                if (value?.isEmpty ?? false) {
                  return 'Please enter email';
                }
                return null;
              },
              onSaved: (String? value) {
                email = value ?? "";
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'password',
              ),
              obscureText: true,
              validator: (value) {
                if (value?.isEmpty ?? false) {
                  return 'Please enter password';
                }
                return null;
              },
              onSaved: (String? value) {
                password = value ?? "";
              },
            ),
          ],
        ),
      ),
      ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              _formKey.currentState?.save();
              print('email: $email, password : $password');
              if (isSignIn) {
                signIn();
              } else {
                signUp();
              }
            }
          },
          child: Text(isSignIn ? "SignIn" : "SignUp")),
      ElevatedButton(
        onPressed: () async {
          UserCredential? userCredential = await signInWithGoogle();
          final user = userCredential?.user;
          if (user != null) {
            // 로그인 성공, 사용자 정보(userCredential.user)를 사용할 수 있습니다.
            print('Google 로그인 성공: ${user.displayName}');
            // 여기에서 추가 작업 수행 가능
          } else {
            print('Google 로그인 실패 또는 취소');
          }
        },
        child: Text('Google 로그인'),
      ),
      RichText(
        textAlign: TextAlign.right,
        text: TextSpan(
          text: 'Go ',
          style: Theme.of(context).textTheme.bodyText1,
          children: <TextSpan>[
            TextSpan(
                text: isSignIn ? "SignUp" : "SignIn",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    setState(() {
                      isSignIn = !isSignIn;
                    });
                  }),
          ],
        ),
      ),
    ];
  }

  // 로그인 성공 시 화면 MainPageWidget
  List<Widget> MainPageWidget() {
    String resultEmail = FirebaseAuth.instance.currentUser!.email!;
    return [
      Text(
        isSignIn
            ? "$resultEmail 로 로그인 하셨습니다.!"
            : "$resultEmail 로 회원가입 하셨습니다.! 이메일 인증을 거쳐야 로그인이 가능합니다.",
        style: TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.bold,
        ),
      ),
      ElevatedButton(
          onPressed: () {
            if (isSignIn) {
              signOut();
            } else {
              setState(() {
                isInput = true;
                isSignIn = true;
              });
            }
          },
          child: Text(isSignIn ? "SignOut" : "SignIn")),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Auth Test"),
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: isInput ? getInputWidget() : MainPageWidget()
      ),
    );
  }
}
