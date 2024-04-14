import 'package:flutter/material.dart';
import 'package:flutter_doan/component/button.dart';
import 'package:flutter_doan/component/dialog.dart';
import 'package:flutter_doan/component/textfield.dart';

class EditScreen extends StatelessWidget {
  const EditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sửa thông tin sinh viên"),
      ),
      body: const Center(
        child: RegisterForm(),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _userIDController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userPhoneNumberController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _classController = TextEditingController();

  // void clearTextField() {
  //   _userNameController.text = "";
  //   _passwordController.text = "";
  //   _userPhoneNumberController.text = "";
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                  isReadOnly: true,
                  isPassword: false,
                  hintText: "MSSV",
                  controller: _userIDController),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                  isReadOnly: false,
                  isPassword: false,
                  hintText: "Họ và tên",
                  controller: _userNameController),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                  isReadOnly: false,
                  isPassword: false,
                  hintText: "Số điện thoại",
                  controller: _userPhoneNumberController),
              const SizedBox(height: 10),
              CustomTextField(
                  isReadOnly: false,
                  isPassword: false,
                  hintText: "Địa chỉ",
                  controller: _addressController),
              CustomTextField(
                  isReadOnly: false,
                  isPassword: false,
                  hintText: "Giới tính",
                  controller: _genderController),
              CustomTextField(
                  isReadOnly: false,
                  isPassword: false,
                  hintText: "Lớp",
                  controller: _classController),
              const SizedBox(height: 10),
              CustomButton(
                  buttonText: "Cập nhật",
                  onPressed: () async {
                    String userName = _userNameController.text.trim();
                    String phone = _userPhoneNumberController.text.trim();
                    String address = _addressController.text.trim();
                    String gender = _genderController.text.trim();
                    // String class = _classController.text.trim();

                    if (_userNameController.text.isEmpty ||
                        _userPhoneNumberController.text.isEmpty ||
                        _addressController.text.isEmpty ||
                        _genderController.text.isEmpty ||
                        _classController.text.isEmpty) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomDialogAlert(
                                title: "Thông báo",
                                message: "Vui lòng nhập đầy đủ thông tin",
                                closeButtonText: "Đóng",
                                onPressed: () => Navigator.of(context).pop());
                          });
                    } else {
                      try {
                        // final response = await AppUtils.registerUser(
                        //     userName);

                        if (mounted) {
                          // print(response['EM']);
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomDialogAlert(
                                    title: "Thông báo",
                                    // message: response['EM'],
                                    message: "Thông báo",
                                    closeButtonText: "Đóng",
                                    onPressed: () => Navigator.pop(context));
                              });
                        }
                      } catch (e) {
                        print("Lỗi: $e");
                      }
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
