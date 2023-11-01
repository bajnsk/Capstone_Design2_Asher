import 'package:flutter/material.dart';

class TagPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tag Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Tag Page',
              style: TextStyle(fontSize: 24),
            ),
            // Add content for Tag Page here
          ],
        ),
      ),
    );
  }
}
