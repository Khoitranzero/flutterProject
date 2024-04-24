import 'package:flutter/material.dart';
import 'package:flutter_doan/component/button.dart';
import 'package:flutter_doan/component/homeItem.dart';
import 'package:flutter_doan/screens/Subject/subjectList_page.dart';
import 'package:flutter_doan/screens/action_page.dart';
import 'package:flutter_doan/screens/classList_page.dart';
import 'package:flutter_doan/screens/listUser_page.dart';
import 'package:flutter_doan/screens/userDetail_page.dart';
import 'package:flutter_doan/screens/userPoin_page.dart';
import 'package:flutter_doan/screens/user_page.dart';
import 'package:flutter_doan/utils/services.dart';
import 'package:flutter_doan/utils/tokenService.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  String? _role;
  late String phone;
  late String userId;
  @override
  void initState() {
    super.initState();
    _getRole();
  }

  Future<void> _getRole() async {
    final tokenAndRole = await TokenService.getTokenAndRole();
    setState(() {
      _role = tokenAndRole['role']!;
      userId = _role!;
    });
  }

  void handleLogout() {
    try {
      final response = AppUtils.handleLogout();
      if (response.toString().isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ActionPage()),
        );
        TokenService.deleteToken();
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const SizedBox(height: 100),
          Text(
            "Xin chào ${_role}",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[300],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                child: Wrap(
                  direction: Axis.horizontal,
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: <Widget>[
                    HomeItem(
                      title: "Thông tin SV",
                      backgroundColor: Colors.orange,
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            // builder: (context) => UserDetail(phone: phone),
                            builder: (context) => UserDetail(phone:userId),
                          ),
                        );
                      },
                    ),
                    HomeItem(
                      title: "Bảng Điểm",
                      backgroundColor: Colors.redAccent,
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserPointPage(userId:userId),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          CustomButton(buttonText: "Đăng xuất", onPressed: () => handleLogout())
        ],
      ),
    );
  }
}
