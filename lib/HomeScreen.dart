import 'package:capstone/posts/Post.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: 30,
          itemBuilder: (BuildContext context, int index) {
            return Post(
              number: index,
            );
          }
      ),
    );
  }
}
