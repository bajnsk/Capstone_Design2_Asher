import '../Firebase_LogIn.dart';
import 'package:capstone/Firebase_LogIn.dart';
import 'package:flutter/material.dart';



class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'hi',
              style: TextStyle(fontSize: 24),
            ),
            ElevatedButton(
              onPressed: () {
                // 버튼을 누를 때 signOut 함수를 호출
                AuthFunctions.signOut().then((_) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => AuthWidget()),
                  );
                });
              },
              child: Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}