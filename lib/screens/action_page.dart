import 'package:flutter/material.dart';
import 'package:flutter_doan/component/button.dart';
import 'package:flutter_doan/screens/login_screen.dart';
import 'package:flutter_doan/screens/register_screen.dart';

class ActionPage extends StatelessWidget {
  const ActionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      backgroundColor: Colors.lime[100],
      appBar: AppBar(
        backgroundColor: Colors.cyan[200],
        title: const Center(
          child: Text(
            "Quản Lý Sinh Viên",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
                buttonText: "Đăng nhập",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                }),
            const SizedBox(height: 20),
            CustomButton(
                buttonText: "Đăng ký",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterScreen()));
                }),
          ],
        ),
      ),
    ));
  }
}
