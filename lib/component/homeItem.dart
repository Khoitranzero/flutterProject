import 'package:flutter/material.dart';

class HomeItem extends StatelessWidget {
  final double widthSize = 150;
  final double heightSize = 150;
  final String title;
  final Color backgroundColor;
  final VoidCallback onPress;
  const HomeItem(
      {super.key,
      required this.title,
      required this.backgroundColor,
      required this.onPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPress,
        child: Container(
            alignment: Alignment.center,
            width: widthSize,
            height: heightSize,
            decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(10),
                color: backgroundColor),
            child: Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )));
  }
}
