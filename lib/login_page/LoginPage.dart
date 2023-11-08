import 'package:capstone/login_page/SignUpPage.dart';
import 'package:capstone/login_page/email_login/Test/widget/error_diaalog_widget.dart';
import 'package:capstone/login_page/google_login/c_google_login_process.dart';
import 'package:capstone/login_page/providers/auth/auth_provider.dart';
import 'package:capstone/login_page/providers/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:capstone/login_page/email_login/Test/widget/my_button.dart';
import 'package:capstone/login_page/email_login/Test/widget/my_textfield.dart';
import 'package:capstone/login_page/email_login/Test/widget/square_tile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'email_login/Test/controller/auth_controller.dart';
import 'exceptions/custom_exception.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authStatus = context.watch<AuthState>().authStatus;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: null,
          backgroundColor: Colors.grey[300],
          body: Center(
            child: ListView(
              reverse: true,
              children: [
                Center(
                  child: Text(
                    'Asher',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 52,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // logo
                const Icon(
                  Icons.lock,
                  size: 100,
                ),

                const SizedBox(height: 20),

                // welcome back
                Center(
                  child: Text(
                    'Welcome back!',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 20,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // username textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // forgot password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // sign in button

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: MyButton(
                    onPressed: () async {
                      try {
                        await context.read<AuthProvider>().signIn(
                              email: emailController.text,
                              password: passwordController.text,
                            );
                      } on CustomException catch (e) {
                        errorDialogWidget(context, e);
                      }
                      Future.delayed(Duration(seconds: 2), () {
                        if (authStatus == AuthStatus.unauthenticated) {
                          AuthController().navigateToHome(context);
                        }
                      });
                    },
                    buttonName: "Sign In",
                  ),
                ),

                const SizedBox(height: 30),

                // or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // google
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        signInWithGoogle();
                      },
                      child: SquareTile(imagePath: 'lib/images/google.png'),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpPage()));
                      },
                      child: Text(
                        'Register now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                )
              ].reversed.toList(),
            ),
          )),
    );
  }
}
