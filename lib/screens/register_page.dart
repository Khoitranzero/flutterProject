import 'package:flutter/material.dart';
import 'package:flutter_doan/component/button.dart';
import 'package:flutter_doan/component/dialog.dart';
import 'package:flutter_doan/component/textfield.dart';
import 'package:flutter_doan/screens/Lecturer/LecturerHome_screen.dart';
import 'package:flutter_doan/screens/action_page.dart';
import 'package:flutter_doan/screens/adminHome_page.dart';
import 'package:flutter_doan/screens/userHome_screen.dart';
import 'package:flutter_doan/utils/services.dart';
import 'package:flutter_doan/utils/tokenService.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đăng Ký"),
      ),
      body: const LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userPhoneNumberController =
      TextEditingController();
  final String _selectedRole = 'Sinh viên';

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: isSmallScreen
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _Logo(),
                    const SizedBox(height: 20),
                    _FormContent(
                      userNameController: _userNameController,
                      passwordController: _passwordController,
                      userPhoneNumberController: _userPhoneNumberController,
                      selectedRole: _selectedRole,
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: _Logo()),
                    Expanded(
                      child: _FormContent(
                        userNameController: _userNameController,
                        passwordController: _passwordController,
                        userPhoneNumberController: _userPhoneNumberController,
                        selectedRole: _selectedRole,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FlutterLogo(size: isSmallScreen ? 100 : 200),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Đăng ký vào hệ thống",
            textAlign: TextAlign.center,
            style: isSmallScreen
                ? Theme.of(context).textTheme.headline5
                : Theme.of(context)
                    .textTheme
                    .headline4
                    ?.copyWith(color: Colors.black),
          ),
        ),
      ],
    );
  }
}

class _FormContent extends StatefulWidget {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userPhoneNumberController = TextEditingController();
  String selectedRole = 'Giảng viên';

  _FormContent(
      {Key? key,
      required this.userNameController,
      required this.passwordController,
      required this.userPhoneNumberController,
      required this.selectedRole})
      : super(key: key);

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  bool _isPasswordVisible = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _selectedRole = 'Giảng viên';
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth * 0.9;
    return Container(
      constraints: BoxConstraints(maxWidth: containerWidth),
      // padding: EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: widget.userNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nhập vào ô thông tin!!!';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Họ Tên',
                hintText: 'Nhập họ và tên',
                prefixIcon: const Icon(Icons.person),
                border: const OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              controller: widget.userPhoneNumberController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nhập vào ô thông tin!!!';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Số điện thoại',
                hintText: 'Nhập số điện thoại',
                prefixIcon: const Icon(Icons.person),
                border: const OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              controller: widget.passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nhập vào ô thông tin!!!';
                }
                if (value.length < 5) {
                  return 'Mật khẩu phải từ 6 ký tự';
                }
                return null;
              },
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Mật khẩu',
                hintText: 'Nhập mật khẩu của bạn',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            _gap(),
            Container(
              width: 400,
              height: 50,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: DropdownButton<String>(
                value: _selectedRole,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.black),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRole = newValue!;
                  });
                },
                items: <String>['Giảng viên', 'Sinh viên']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            _gap(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    String username = widget.userNameController.text.trim();
                    String phoneNum =
                        widget.userPhoneNumberController.text.trim();
                    String password = widget.passwordController.text.trim();
                    if (username.isEmpty ||
                        phoneNum.isEmpty ||
                        password.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomDialogAlert(
                            title: "Thông báo",
                            message: "Vui lòng nhập đầy đủ thông tin",
                            closeButtonText: "Đóng",
                            onPressed: () => Navigator.of(context).pop(),
                          );
                        },
                      );
                    } else {
                      try {
                        final response = await AppUtils.registerUser(
                            username, phoneNum, password, _selectedRole);
                        if (response['EM'].toString().isNotEmpty &&
                            response['DT'].toString().isNotEmpty) {
                          String? token =
                              response['DT']['access_token'] as String;
                          String? role = response['DT']['userId'] as String;
                          await TokenService.saveToken(token, role);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialogAlert(
                                title: "Thông báo",
                                message: response['EM'],
                                closeButtonText: "Đóng",
                                onPressed: () => {
                                  Navigator.of(context).pop(),
                                  Navigator.of(context).pop()
                                },
                              );
                            },
                          );
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomDialogAlert(
                                    title: "Thông báo",
                                    message: response['EM'],
                                    closeButtonText: "Đóng",
                                    onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ActionPage())));
                              });
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialogAlert(
                                title: "Thông báo",
                                message: response['EM'],
                                closeButtonText: "Đóng",
                                onPressed: () => {
                                  Navigator.of(context).pop(),
                                  Navigator.of(context).pop()
                                },
                              );
                            },
                          );
                        }
                      } catch (e) {
                        print("Lỗi: $e");
                      }
                    }
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Đăng ký',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}