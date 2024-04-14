import 'package:flutter/material.dart';
import 'package:flutter_doan/component/button.dart';
import 'package:flutter_doan/component/dialog.dart';
import 'package:flutter_doan/component/textfield.dart';
import 'package:flutter_doan/screens/Lecturer/LecturerHome_screen.dart';
import 'package:flutter_doan/screens/adminHome_page.dart';
import 'package:flutter_doan/screens/userHome_screen.dart';
import 'package:flutter_doan/screens/user_page.dart';
import 'package:flutter_doan/utils/services.dart';
import 'package:flutter_doan/utils/tokenService.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Đăng nhập"),
        ),
        body: const LoginForm());
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _valueLoginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  void clearTextField() {
    _valueLoginController.text = "";
    _passwordController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CustomTextField(
                        isPassword: false,
                        isReadOnly: false,
                        hintText: "Số điện thoại hoặc MSSV",
                        controller: _valueLoginController),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                        isPassword: true,
                        hintText: "Mật Khẩu",
                        isReadOnly: false,
                        controller: _passwordController),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                        buttonText: "Đăng nhập",
                        onPressed: () async {
                          String valueLogin = _valueLoginController.text.trim();
                          String password = _passwordController.text.trim();
                          if (valueLogin.isEmpty || password.isEmpty) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomDialogAlert(
                                      title: "Thông báo",
                                      message: "Vui lòng nhập đầy đủ thông tin",
                                      closeButtonText: "Đóng",
                                      onPressed: () =>
                                          Navigator.of(context).pop());
                                });
                          } else {
                            try {
                              final response = await AppUtils.hanldeLogin(
                                  valueLogin, password);
                              if (response['EM'].toString().isNotEmpty &&
                                  response['DT'].toString().isNotEmpty) {
                                String? token =
                                    response['DT']['access_token'] as String;
                                String? role =
                                    response['DT']['userId'] as String;
                                await TokenService.saveToken(token, role);

                                String checkUser = role.substring(0, 2);
                  
                                if (role == 'admin') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AdminHomePage()));
                                } else if (checkUser == 'gv') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LecturerHomePage()));
                                } else if (checkUser == 'dh') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const UserHomeScreen()));
                                }

                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CustomDialogAlert(
                                          title: "Thông báo",
                                          message: response['EM'],
                                          closeButtonText: "Đóng",
                                          onPressed: () =>
                                              Navigator.of(context).pop());
                                    });
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CustomDialogAlert(
                                          title: "Thông báo",
                                          message: response['EM'],
                                          closeButtonText: "Đóng",
                                          onPressed: () =>
                                              Navigator.of(context).pop());
                                    });
                              }
                            } catch (e) {
                              print("Lỗi: $e");
                            }
                          }
                        }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
