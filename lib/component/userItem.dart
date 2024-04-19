import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_doan/model/user.dart';
import 'package:flutter_doan/utils/tokenService.dart';

class UserItem extends StatefulWidget {
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

  @override
  _UserItemState createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  String? isGv;
  String? _role;

  @override
  void initState() {
    super.initState();
    _getRole();
  }

  Future<void> _getRole() async {
    final tokenAndRole = await TokenService.getTokenAndRole();
    _role = tokenAndRole['role'] ?? '';
    setState(() {
      isGv = _role!.contains("gv") ? 'gv' : null;
    });
  }

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
              vertical: BorderSide(width: 1, color: Colors.black),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(color: getRandomColor()),
                padding: const EdgeInsets.all(8),
                child: Text(
                  widget.user.toString(),
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
                      onPressed: widget.onPressedButton1,
                      child: Icon(Icons.info),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  if (widget.user.userId.contains("dh"))
                    Expanded(
                      child: ElevatedButton(
                        onPressed: widget.onPressedButton2,
                        child: Icon(Icons.scoreboard),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(width: 20),
                  // Hide Button 3 if isGv is true
                  if (isGv == null)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: widget.onPressedButton3,
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
      ),
    );
  }
}
