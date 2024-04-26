import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_doan/model/class.dart';
import 'package:flutter_doan/model/classSubject.dart';

class ClassSubjectItem extends StatelessWidget {
  final classSubject classSubjectInfo;
  final VoidCallback onPressed;
  final VoidCallback onLongPressed;

  const ClassSubjectItem({
    Key? key,
    required this.classSubjectInfo,
    required this.onPressed,
    required this.onLongPressed,
  }) : super(key: key);

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
      child: InkWell(
        onLongPress: onLongPressed,
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: getRandomColor(),
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mã môn học: ${classSubjectInfo.subjectId}',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Tên môn học: ${classSubjectInfo.subjectName}',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Số tín chỉ: ${classSubjectInfo.credits}',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Số lớp học: ${classSubjectInfo.count}',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
