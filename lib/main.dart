import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Firebase_GoogleLogin.dart';



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

class Fluttertoast {
  static void showToast({required String msg, required Toast toastLength, required ToastGravity gravity, required int timeInSecForIosWeb, required MaterialColor backgroundColor, required Color textColor, required double fontSize}) {}
}

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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthWidget(),
    );
  }
}

class AuthWidget extends StatefulWidget {
  @override
  AuthWidgetState createState() => AuthWidgetState();
}

class AuthWidgetState extends State<AuthWidget> {
  final _formKey = GlobalKey<FormState>();
  late String email;
  late String password;
  bool isInput = true; //false - result
  bool isSignIn = true; //false - SignUp

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

  List<Widget> getInputWidget() {
    return [
      /*Text(
        isSignIn ? "Sign In" : "Sign Up",
        style: TextStyle(
          color: Colors.indigo,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        textAlign: TextAlign.center,
      ),
      */
      Container(
        margin: EdgeInsets.only(top: 100),
        child: Container(
          margin: EdgeInsets.all(50),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                  TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.account_circle,
                        color: Colors.grey,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                          BorderSide(color: Colors.black,),
                        borderRadius: BorderRadius.all(
                          Radius.circular(35.0),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.black,),
                        borderRadius: BorderRadius.all(
                          Radius.circular(35.0),
                        ),
                      ),
                      hintText: 'email',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      contentPadding:EdgeInsets.all(10)
                    ),
                    keyboardType: TextInputType.emailAddress,
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
                SizedBox(height: 10,),
                TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.key,
                        color: Colors.grey,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.black,),
                        borderRadius: BorderRadius.all(
                          Radius.circular(35.0),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.black,),
                        borderRadius: BorderRadius.all(
                          Radius.circular(35.0),
                        ),
                      ),
                      hintText: 'password',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      contentPadding:EdgeInsets.all(10)
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
                /*
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
                 */
              ],

            ),
          ),
        ),
      ),
      ButtonTheme(
        child: ElevatedButton(
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
        ),
      SizedBox(height: 30,),
      RichText(
        textAlign: TextAlign.right,
        text: TextSpan(
          text: 'Go ',
          style: Theme
              .of(context)
              .textTheme
              .bodyText1,
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
      SizedBox(height: 30,)

    ];
  }

  List<Widget> getResultWidget() {
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
        title: Text(
          isSignIn ? "Sign In" : "Sign Up",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (isInput) ...getInputWidget() else
            ...getResultWidget(),
          Expanded(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.end, // 하단 정렬
              children: <Widget>[
                TextButton(
                  child: Text("Google Login"),
                  onPressed: GoogleLogin.signInWithGoogle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}






