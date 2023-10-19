import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      home: LogIn(),
    );
  }
}

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: Center(
            child: Form(
              child: Container(
                padding: EdgeInsets.all(40),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(labelText: 'ID'),
                        keyboardType: TextInputType.text,
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: 'Password'),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                      ),
                      SizedBox(height: 30,),
                      ButtonTheme(
                          child: ElevatedButton(onPressed: () {}, child: Text('Login'),),
                          padding: EdgeInsets.only(top: 10)
                      ),
                      SizedBox(height: 30,),
                      ButtonTheme(
                          child: ElevatedButton(onPressed: () {}, child: Text('Sign in'),),
                          padding: EdgeInsets.only(top: 10)
                      ),
                    ],
                  ),
                ),
              ),
            )
        )
    );
  }
}


