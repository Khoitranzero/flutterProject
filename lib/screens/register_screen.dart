// import 'package:flutter/material.dart';
// import 'package:flutter_doan/component/button.dart';
// import 'package:flutter_doan/component/dialog.dart';
// import 'package:flutter_doan/component/textfield.dart';
// import 'package:flutter_doan/screens/action_page.dart';
// import 'package:flutter_doan/utils/services.dart';

// class RegisterScreen extends StatelessWidget {
//   const RegisterScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Đăng ký"),
//       ),
//       body: const Center(
//         child: RegisterForm(),
//       ),
//     );
//   }
// }

// class RegisterForm extends StatefulWidget {
//   const RegisterForm({super.key});

//   @override
//   State<RegisterForm> createState() => _RegisterFormState();
// }

// class _RegisterFormState extends State<RegisterForm> {
//   final TextEditingController _userNameController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _userPhoneNumberController =TextEditingController();
//   final TextEditingController _sexController =TextEditingController();
//   String _selectedRole = 'Giảng viên';
//   void clearTextField() {
//     _userNameController.text = "";
//     _addressController.text = "";
//     _userPhoneNumberController.text = "";
//         _sexController.text = "";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: SingleChildScrollView(
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(60),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     CustomTextField(
//                         isReadOnly: false,
//                         isPassword: false,
//                         hintText: "Họ và tên",
//                         controller: _userNameController),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     CustomTextField(
//                         isReadOnly: false,
//                         isPassword: false,
//                         hintText: "Số điện thoại",
//                         controller: _userPhoneNumberController),
//                     const SizedBox(height: 10),
//                     CustomTextField(
//                         isReadOnly: false,
//                         isPassword: true,
//                         hintText: "Địa chỉ",
//                         controller: _addressController),
//                     const SizedBox(height: 10),
//                      CustomTextField(
//                         isReadOnly: false,
//                         isPassword: false,
//                         hintText: "Giới tính",
//                         controller: _sexController),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     Container(
//                       width: 250,
//                       height: 50,
//                       padding: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(color: Colors.black),
//                       ),
//                       // child: DropdownButton<String>(
//                       //   value: _selectedRole,
//                       //   icon: Icon(Icons.arrow_drop_down),
//                       //   iconSize: 24,
//                       //   elevation: 16,
//                       //   style: const TextStyle(color: Colors.black),
//                       //   onChanged: (String? newValue) {
//                       //     setState(() {
//                       //       _selectedRole = newValue!;
//                       //     });
//                       //   },
//                       //   items: <String>['Giảng viên', 'Sinh viên']
//                       //       .map<DropdownMenuItem<String>>((String value) {
//                       //     return DropdownMenuItem<String>(
//                       //       value: value,
//                       //       child: Text(value),
//                       //     );
//                       //   }).toList(),
//                       // ),
//                     ),
//                     const SizedBox(height: 10),
//                     CustomButton(
//                         buttonText: "Đăng ký",
//                         onPressed: () async {
//                           String userName = _userNameController.text.trim();
//                           String address = _addressController.text.trim();
//                           String userPhoneNumber = _userPhoneNumberController.text.trim();
//                           String sex = _sexController.text.trim();
//                           if (_userNameController.text.isEmpty ||
//                               _userPhoneNumberController.text.isEmpty ||
//                                _sexController.text.isEmpty ||
//                               _addressController.text.isEmpty) {
//                             showDialog(
//                                 context: context,
//                                 builder: (BuildContext context) {
//                                   return CustomDialogAlert(
//                                       title: "Thông báo",
//                                       message: "Vui lòng nhập đầy đủ thông tin",
//                                       closeButtonText: "Đóng",
//                                       onPressed: () =>
//                                           Navigator.of(context).pop());
//                                 });
//                           } else {
//                             try {
//                               final response = await AppUtils.registerUser(
//                                   userName,
//                                   userPhoneNumber,
//                                   address,
//                                   sex);
//                               clearTextField();
//                               if (mounted) {
//                                 print(response['EM']);
//                                 showDialog(
//                                     context: context,
//                                     builder: (BuildContext context) {
//                                       return CustomDialogAlert(
//                                           title: "Thông báo",
//                                           message: response['EM'],
//                                           closeButtonText: "Đóng",
//                                           onPressed: () => Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                   builder: (context) =>
//                                                       const ActionPage())));
//                                     });
//                               }
//                             } catch (e) {
//                               print("Lỗi: $e");
//                             }
//                           }
//                         })
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ));
//   }
// }
