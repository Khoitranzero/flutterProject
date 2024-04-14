//lib/maint.dart
import 'package:flutter/material.dart';
import 'package:flutter_doan/screens/action_page.dart';
import 'package:flutter_doan/screens/adminHome_page.dart';
import 'package:flutter_doan/screens/userHome_page.dart';
import 'package:flutter_doan/screens/userHome_screen.dart';
import 'package:flutter_doan/screens/user_page.dart';
import 'package:flutter_doan/utils/tokenService.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ĐỒ ÁN FLUTTER',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const AuthenticationPage(),
    );
  }
}

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: TokenService.getTokenAndRole(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            String? role = snapshot.data!['role']; 
            if (role != null) {
             
              if (role == 'admin') {
                return const AdminHomePage();
              } else {
                return const UserHomeScreen();
              }
            } else {
              print('Chưa đăng nhập');
              return const ActionPage();
            }
          } else {
            print('Không có dữ liệu từ snapshot');
            return const ActionPage();
          }
        });
  }
}
