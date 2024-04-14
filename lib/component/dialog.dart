import 'package:flutter/material.dart';

class CustomDialogAlert extends StatelessWidget {
  final String title;
  final String message;
  final String closeButtonText;
  final VoidCallback onPressed;
  const CustomDialogAlert(
      {Key? key,
      required this.title,
      required this.message,
      required this.closeButtonText,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        TextButton(onPressed: onPressed, child: Text(closeButtonText))
      ],
    );
  }
}
