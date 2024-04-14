import 'package:flutter/material.dart';

class LecturerHome extends StatefulWidget {
  const LecturerHome({super.key});

  @override
  State<LecturerHome> createState() => _LecturerHomeState();
}

class _LecturerHomeState extends State<LecturerHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("hello"),
      ),
      body: Center(
        child: Text("Xin chào giảng viên"),
      ),
    );
  }
}
