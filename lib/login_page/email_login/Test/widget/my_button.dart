import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onPressed;
  final String buttonName;



  const MyButton(
      {super.key, required this.onPressed, required this.buttonName});

  @override
  Widget build(BuildContext context) {
    String buttonText = buttonName;
    if (buttonName == 'Sign In') {
      buttonText = buttonName;
    } else if (buttonName == 'Sign Up') {
      buttonText = buttonName;
    }

    return ElevatedButton(
      onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            textStyle: TextStyle(fontSize: 20),
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
        child: Text(buttonText),
    );
  }
}
