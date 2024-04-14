import 'dart:math';

import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  final String title;
  const CustomChip({super.key, required this.title});
  Color getRandomBrightColor() {
    Random random = Random();
    int minBrightness = 150;
    int red = minBrightness + random.nextInt(106);
    int green = minBrightness + random.nextInt(106);
    int blue = minBrightness + random.nextInt(106);
    return Color.fromARGB(255, red, green, blue);
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        title,
        style: TextStyle(fontSize: 14),
      ),
      backgroundColor: getRandomBrightColor(),
    );
  }
}
