import 'package:flutter/material.dart';
import 'package:flutter_doan/component/button.dart';
import 'package:flutter_doan/component/homeItem.dart';
import 'package:flutter_doan/screens/Lecturer/classListForLecturer_screen.dart';
import 'package:flutter_doan/screens/Subject/subjectList_page.dart';
import 'package:flutter_doan/screens/action_page.dart';
import 'package:flutter_doan/screens/changePassword.dart';
import 'package:flutter_doan/screens/classList_page.dart';
import 'package:flutter_doan/screens/listUser_page.dart';
import 'package:flutter_doan/screens/projectInfo_page.dart';
import 'package:flutter_doan/screens/userDetail_page.dart';
import 'package:flutter_doan/screens/user_page.dart';
import 'package:flutter_doan/utils/services.dart';
import 'package:flutter_doan/utils/tokenService.dart';

class LecturerHomePage extends StatefulWidget {
  const LecturerHomePage({super.key});

  @override
  State<LecturerHomePage> createState() => _LecturerHomePageState();
}

class _LecturerHomePageState extends State<LecturerHomePage> {
  late String teacherID;

  @override
  void initState() {
    super.initState();
    _getRole();
  }

  Future<void> _getRole() async {
    final tokenAndRole = await TokenService.getTokenAndRole();
    String? _role = tokenAndRole['role'] ?? '';
    if (_role.contains("gv")) {
      setState(() {
        teacherID = _role;
      });
    } else {
      setState(() {
        teacherID = '';
      });
    }
  }

  void handleLogout() {
    try {
      final response = AppUtils.handleLogout();
      if (response.toString().isNotEmpty) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const ActionPage()));
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
          const SizedBox(height: 50),
          Text(
            "Quản Lý Sinh Viên",
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
                    // HomeItem(
                    //     title: "DDSV",
                    //     backgroundColor: Colors.orange,
                    //     onPress: () => {
                    //           Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                   builder: (context) => const ListUser()))
                    //         }),
                    HomeItem(
                        title: "Thông tin \n    đồ án",
                        backgroundColor: Colors.redAccent,
                        onPress: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ProjectInfo()))
                            }),
                    HomeItem(
                        title: "DSMH",
                        backgroundColor: Colors.blue,
                        onPress: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SubjectList()))),
                    HomeItem(
                        title: "DS Lớp",
                        backgroundColor: Colors.green,
                        onPress: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ClassListForLecturer(
                                              teacherId: teacherID)))
                            }),
                    HomeItem(
                        title: "Thông tin GV",
                        backgroundColor: Colors.blueGrey,
                        onPress: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          UserDetail(phone: teacherID)))
                              //  UserDetail(userId: teacherID)))
                            })
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          CustomButton(
              buttonText: "Đăng xuất", onPressed: () => handleLogout()),
          const SizedBox(height: 10),
          CustomButton(
              buttonText: "Đổi mật khẩu",
              onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      // builder: (context) => UserDetail(phone: phone),
                      builder: (context) => ChangePassword(userId: teacherID),
                    ),
                  ))
        ],
      ),
    );
  }
}
