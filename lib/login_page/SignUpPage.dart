import 'package:capstone/login_page/LoginPage.dart';
import 'package:capstone/login_page/email_login/Test/widget/error_diaalog_widget.dart';
import 'package:capstone/login_page/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:capstone/login_page/email_login/Test/widget/my_button.dart';
import 'package:validators/validators.dart';
import 'package:provider/provider.dart';

import 'exceptions/custom_exception.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  TextEditingController _passwordEditingController = TextEditingController();
  TextEditingController _emailEditingController = TextEditingController();
  TextEditingController _nameEditingController = TextEditingController();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  bool _isEnabled = true;

  @override
  void dispose() {
    _emailEditingController.dispose();
    _nameEditingController.dispose();
    _passwordEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.grey[300],
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _globalKey,
                autovalidateMode: _autovalidateMode,
                child: ListView(
                  shrinkWrap: true,
                  reverse: true,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        'Asher',
                        style: GoogleFonts.bebasNeue(
                          fontSize: 52,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    Center(
                      child: Text(
                        'Welcome to Asher!',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 20,
                        ),
                      ),
                    ),

                    SizedBox(height: 30),

                    // 이메일
                    TextFormField(
                      enabled: _isEnabled,
                      controller: _emailEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                        filled: true,
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            !isEmail(value.trim())) {
                          return '이메일을 입력해주세요';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 20),

                    // 닉네임
                    TextFormField(
                      enabled: _isEnabled,
                      controller: _nameEditingController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Name',
                        prefixIcon: Icon(Icons.account_circle),
                        filled: true,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return '별명을 입력해주세요';
                        }
                        if (value.length < 3 || value.length > 10) {
                          return '이름은 최소 3글자, 최대 10글자 까지 입력 가능합니다';
                        }
                        return null;
                      },
                    ),

                    // 패스워드
                    SizedBox(height: 20),
                    TextFormField(
                      enabled: _isEnabled,
                      controller: _passwordEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                        filled: true,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return '패스워드를 입력해주세요';
                        }
                        if (value.length < 6) {
                          return '6글자 이상 입력 해주세요';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 20),

                    // 패스워드 재확인
                    TextFormField(
                      enabled: _isEnabled,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Confirm Password',
                        prefixIcon: Icon(Icons.lock),
                        filled: true,
                      ),
                      validator: (value) {
                        if (_passwordEditingController.text != value) {
                          return '패스워드가 일치하지 않습니다';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 40),

                    MyButton(
                      onPressed: _isEnabled
                          ? () async {
                              final form = _globalKey.currentState;

                              if (form == null || !form.validate()) {
                                return;
                              }

                              setState(() {
                                _isEnabled = false;
                                _autovalidateMode = AutovalidateMode.always;
                              });

                              // 회원가입 로직 진행
                              try {
                                await context.read<AuthProvider>().signUp(
                                      email: _emailEditingController.text,
                                      name: _nameEditingController.text,
                                      password: _passwordEditingController.text,
                                    );
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text('인증 메일을 전송했습니다'),
                                  duration: Duration(seconds: 120),
                                ));
                              } on CustomException catch (e) {
                                setState(() {
                                  _isEnabled = true;
                                });
                                errorDialogWidget(context, e);
                              }
                            }
                          : null,
                      buttonName: "Sign Up",
                    ),

                    SizedBox(height: 10),

                    TextButton(
                      onPressed: _isEnabled
                          ? () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            }
                          : null,
                      child: Text(
                        '이미 회원이신가요?',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ].reversed.toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
