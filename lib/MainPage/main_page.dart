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
          children: <Widget>[
            Text(
              'Main Page',
              style: TextStyle(fontSize: 24),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/tag');
              },
              child: Text('Go to Tag Page'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/my');
              },
              child: Text('Go to My Page'),
            ),
          ],
        ),
      ),
    );
  }
}
