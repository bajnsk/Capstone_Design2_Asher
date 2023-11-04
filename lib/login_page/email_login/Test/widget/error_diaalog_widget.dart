import 'package:capstone/login_page/exceptions/custom_exception.dart';
import 'package:flutter/material.dart';

void errorDialogWidget(BuildContext context, CustomException e) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text(e.code),
        content: Text(e.message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('확인'),
          ),
        ],
      );
    },
  );
}
