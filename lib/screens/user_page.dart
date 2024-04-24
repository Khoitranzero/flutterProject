import 'package:flutter/material.dart';
import 'package:flutter_doan/component/dialog.dart';
import 'package:flutter_doan/component/textfield.dart';
import 'package:flutter_doan/screens/action_page.dart';
import 'package:flutter_doan/utils/services.dart';
import 'package:flutter_doan/utils/tokenService.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Future<Map<String, dynamic>>? _userData;
  String? _role;
  String? isGV;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  final TextEditingController _classController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    final tokenAndRole = await TokenService.getTokenAndRole();
    _role = (tokenAndRole['role'] ?? '');
    isGV = _role?.substring(0, 2);
    setState(() {
      _userData = AppUtils.fetchUser();
      // print(_userData);
    });
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
      appBar: AppBar(
        title: Text("Thông tin của sinh viên 123r"),
      ),
      body: _userData == null
          ? Center(child: CircularProgressIndicator())
          : FutureBuilder<Map<String, dynamic>>(
              future: _userData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Lỗi: ${snapshot.error}'));
                } else {
                  final userData = snapshot.data;
                  if (userData == null) {
                    return Center(child: Text('Không có dữ liệu'));
                  }

                  final List<dynamic>? userList = userData['DT'];
                  if (userList == null || userList.isEmpty) {
                    return Center(child: Text('Không có người dùng'));
                  }

                  final List<dynamic> filteredUsers = userList
                      .where((user) => user['userId'] == _role)
                      .toList();

                  if (filteredUsers.isEmpty) {
                    return Center(
                        child: Text(
                            'Không tìm thấy người dùng có username giống với role'));
                  }

                  final user = filteredUsers.first;
                  _usernameController.text = user['username'];
                  _userIdController.text = user['userId'];
                  _phoneController.text = user['phone'];
                  _addressController.text = user['address'] ?? '';
                  _sexController.text = user['sex'] ?? '';
                  _passwordController.text = user['password'] ?? '';
                  _classController.text = user['Class'] != null &&
                          user['Class']['className'] != null
                      ? user['Class']['className']
                      : '';

                  return ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      Text("Mã số hoạt động",
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold)),
                      CustomTextField(
                          isReadOnly: true,
                          isPassword: false,
                          hintText: "Mã số hoạt động",
                          controller: _userIdController),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("Họ và tên",
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold)),
                      CustomTextField(
                          isReadOnly: false,
                          isPassword: false,
                          hintText: "Họ và tên",
                          controller: _usernameController),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("SĐT",
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold)),
                      CustomTextField(
                          isReadOnly: true,
                          isPassword: false,
                          hintText: "SĐT",
                          controller: _phoneController),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("Địa chỉ",
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold)),
                      CustomTextField(
                          isReadOnly: false,
                          isPassword: false,
                          hintText: "Địa chỉ",
                          controller: _addressController),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("Giới tính",
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold)),
                      CustomTextField(
                          isReadOnly: false,
                          isPassword: false,
                          hintText: "Giới tính",
                          controller: _sexController),
                      const SizedBox(
                        height: 10,
                      ),
                      isGV!.isNotEmpty
                          ? const SizedBox()
                          : Text("Lớp hoạt động",
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold)),
                      isGV!.isNotEmpty
                          ? const SizedBox()
                          : CustomTextField(
                              isReadOnly: _role == 'admin' ? false : true,
                              isPassword: false,
                              hintText: "Lớp hoạt động",
                              controller: _classController),
                      const SizedBox(
                        height: 10,
                      ),
                      BottomAppBar(
                        surfaceTintColor: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: 150,
                              height: 50,
                              child: (isGV == 'gv' || isGV == 'dh')
                                  ? null
                                  : ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                      onPressed: () async {
                                        String userId =
                                            _userIdController.text.trim();
                                        String username =
                                            _usernameController.text.trim();
                                        String address =
                                            _addressController.text.trim();
                                        String gender =
                                            _sexController.text.trim();
                                        String className =
                                            _classController.text.trim();
                                        if (username.isEmpty ||
                                            address.isEmpty ||
                                            gender.isEmpty ||
                                            className.isEmpty) {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return CustomDialogAlert(
                                                title: "Thông báo",
                                                message:
                                                    "Vui lòng nhập đầy đủ thông tin",
                                                closeButtonText: "Đóng",
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                              );
                                            },
                                          );
                                        } else {
                                          try {
                                            print(className);
                                            final response =
                                                await AppUtils.HandleUpdate(
                                                    userId,
                                                    username,
                                                    address,
                                                    gender,
                                                    className,
                                                    className,
                                                    className,
                                                    );
                                            // print(response);
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return CustomDialogAlert(
                                                  title: "Thông báo",
                                                  message: response['EM'],
                                                  closeButtonText: "Đóng",
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                );
                                              },
                                            );
                                          } catch (e) {
                                            print("Lỗi: $e");
                                          }
                                        }
                                      },
                                      child: Text('Cập nhật'),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              }),
    );
  }
}
