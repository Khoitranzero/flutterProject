import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_doan/model/class.dart';

class ClassItem extends StatelessWidget {
  final ClassInfo classInfoItem;
  final VoidCallback onPressed;
  final VoidCallback onLongPressed;

  const ClassItem(
      {Key? key,
      required this.classInfoItem,
      required this.onPressed,
      required this.onLongPressed})
      : super(key: key);
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
              border: Border.all(width: 1)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tên lớp: ${classInfoItem.className}',
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text(
                'Giáo viên phụ trách: \n${classInfoItem.teacherInfo}',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Tổng số lượng sinh viên: ${classInfoItem.count}',
                style: TextStyle(
                  fontSize: 14.0,
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
