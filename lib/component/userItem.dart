import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_doan/model/user.dart';

class UserItem extends StatelessWidget {
  final User user;
  final VoidCallback onPressedButton1;
  final VoidCallback onPressedButton2;
  final VoidCallback onPressedButton3;
  UserItem({
    required this.user,
    required this.onPressedButton1,
    required this.onPressedButton2,
    required this.onPressedButton3,
  });
  Color getRandomColor() {
    Random random = Random();
    int minBrightness = 150;
    int red = minBrightness + random.nextInt(106);
    int green = minBrightness + random.nextInt(106);
    int blue = minBrightness + random.nextInt(106);
    return Color.fromARGB(255, red, green, blue);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
                border: Border.symmetric(
                    horizontal: BorderSide(width: 1, color: Colors.black),
                    vertical: BorderSide(width: 1, color: Colors.black)),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(color: getRandomColor()),
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    user.toString(),
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onPressedButton1,
                        child: Icon(Icons.info),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onPressedButton2,
                        child: Icon(Icons.scoreboard),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onPressedButton3,
                        child: Icon(Icons.delete),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
