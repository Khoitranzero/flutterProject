import 'package:flutter/material.dart';
import 'package:flutter_doan/component/dialog.dart';
import 'package:flutter_doan/utils/services.dart';

class ChangePassword extends StatelessWidget {
  final String userId;

  const ChangePassword({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change password"),
      ),
      body: LoginForm(userId: userId), // Pass userId to LoginForm
    );
  }
}

class LoginForm extends StatefulWidget {
  final String userId; // Accept userId property

  const LoginForm({Key? key, required this.userId}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newpasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                      passwordController: _passwordController,
                      newpasswordController: _newpasswordController,
                      isPasswordVisible: _isPasswordVisible,
                      formKey: _formKey,
                      userId: widget.userId, // Pass userId to _FormContent
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: _Logo()),
                    Expanded(
                      child: _FormContent(
                        passwordController: _passwordController,
                        newpasswordController: _newpasswordController,
                        isPasswordVisible: _isPasswordVisible,
                        formKey: _formKey,
                        userId: widget.userId, // Pass userId to _FormContent
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
            "Đổi mật khẩu",
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
  final TextEditingController passwordController;
  final TextEditingController newpasswordController;
  bool isPasswordVisible;
  final GlobalKey<FormState> formKey;
  final String userId;

  // Remove 'const' from the constructor
  _FormContent({
    Key? key,
    required this.passwordController,
    required this.newpasswordController,
    required this.isPasswordVisible,
    required this.formKey,
    required this.userId,
  }) : super(key: key);

  @override
  State<_FormContent> createState() => __FormContentState();
}


class __FormContentState extends State<_FormContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 400),
      child: Form(
        key: widget.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: widget.passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nhập vào ô thông tin!!!';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Old Password',
                hintText: 'Old Password',
                prefixIcon: const Icon(Icons.person),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: widget.newpasswordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nhập vào ô thông tin!!!';
                }
                if (value.length < 5) {
                  return 'Mật khẩu phải từ 5 ký tự';
                }
                return null;
              },
              obscureText: !widget.isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'New Password',
                hintText: 'Nhập mật khẩu mới của bạn',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    widget.isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      widget.isPasswordVisible = !widget.isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (widget.formKey.currentState?.validate() ?? false) {
                    // Form is validated, proceed with changing password
                    _changePassword();
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Change Password',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _changePassword() async {
    String password = widget.passwordController.text.trim();
    String newpassword = widget.newpasswordController.text.trim();
    try {
      print('widget.userId');
      print(widget.userId);
      print('password');
      print(password);
      print('newpassword');
      print(newpassword);
      final response = await AppUtils.changePassword(
        widget.userId,
        password,
        newpassword,
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogAlert(
            title: "Thông báo",
            message: response['EM'],
            closeButtonText: "Đóng",
            onPressed: () => Navigator.of(context).pop(),
          );
        },
      );
    } catch (e) {
      print("Lỗi: $e");
    }
  }
}
