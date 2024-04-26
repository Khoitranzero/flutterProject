import 'package:flutter/material.dart';
import 'package:flutter_doan/component/button.dart';
import 'package:flutter_doan/component/dialog.dart';
import 'package:flutter_doan/component/textfield.dart';
import 'package:flutter_doan/model/user.dart';
import 'package:flutter_doan/utils/services.dart';
import 'package:flutter_doan/utils/tokenService.dart';

class UserDetail extends StatefulWidget {
  final String phone;

  const UserDetail({Key? key, required this.phone}) : super(key: key);

  @override
  _UserDetailState createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  bool? isGv;
  bool? admin;
  bool? isLecturerUser;
  User user = User(
    userId: "",
    username: "",
    address: "",
    sex: "",
    phone: "",
    className: "",
    password: "",
  );

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  final TextEditingController _classController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _selectedRole = 'Sinh viên';
  String _selectedSex = 'Nam';

  List<dynamic> _classList = [];
  bool _showBottomNavBar = false;

  @override
  void initState() {
    super.initState();
    _getRole();
    _getClassList().then((data) {
      setState(() {
        _classList = data['DT'];
      });
    }).catchError((e) {
      print("Error setting data: $e");
    });
    _getUserById();
  }

  Future<void> _getRole() async {
    final tokenAndRole = await TokenService.getTokenAndRole();
    String? _role = tokenAndRole['role'] ?? '';
    if (_role == 'admin') {
      setState(() {
        _showBottomNavBar = true;
      });
    }
    setState(() {
      print("_role");
      print(_role);
      isGv = _role.contains("gv");
    });
  }

  Future<Map<String, dynamic>> _getClassList() async {
    return await AppUtils.getClassInfo();
  }

  Future<void> _getUserById() async {
    final response = await AppUtils.getUserByPhone(widget.phone);
    setState(() {
      user = User.fromJson(response['DT']);
      isLecturerUser = user.userId.contains("gv");
      _usernameController.text = user.username;
      _userIdController.text = user.userId;
      _phoneController.text = user.phone;
      _addressController.text = user.address ?? "";
      _sexController.text = user.sex ?? "";
      _classController.text = user.className ?? "";
      if (admin != true) {
        _showBottomNavBar = false;
      }
    });
  }

  String? _selectedClassName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLecturerUser == true ? "Thông tin của giáo viên" : "Thông tin của sinh viên"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(isLecturerUser == true ? "MSGV" : "MSSV",
              style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
          CustomTextField(
            isReadOnly: true,
            isPassword: false,
            hintText: "MSSV",
            controller: _userIdController,
          ),
          const SizedBox(height: 10),
          Text("Họ và tên",
              style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
          CustomTextField(
            isReadOnly: false,
            isPassword: false,
            hintText: "Họ và tên",
            controller: _usernameController,
          ),
          const SizedBox(height: 10),
          Text("SĐT",
              style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
          CustomTextField(
            isReadOnly: true,
            isPassword: false,
            hintText: "SĐT",
            controller: _phoneController,
          ),
          const SizedBox(height: 10),
          Text("Địa chỉ",
              style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
          CustomTextField(
            isReadOnly: false,
            isPassword: false,
            hintText: "Địa chỉ",
            controller: _addressController,
          ),
          const SizedBox(height: 10),
          Text("Giới tính",
              style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
          Container(
            width: 400,
            height: 50,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: DropdownButton<String>(
              value: _selectedSex,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(color: Colors.black),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedSex = newValue!;
                });
              },
              items: <String>['Nam', 'Nữ'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),
          if (!(user.userId.contains("gv")))
            _selectedRole == 'Giảng viên'
                ? const SizedBox(height: 10)
                : Text(
                    "Lớp học",
                    style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                  ),

          if (!(user.userId.contains("gv")))
            _selectedRole == 'Giảng viên'
                ? const SizedBox(height: 10)
                : Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.black)),
                    height: 50,
                    margin: const EdgeInsets.only(bottom: 15),
                    child: DropdownButton<String>(
                      value: _selectedClassName,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      hint: const Text("Chọn lớp học"),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedClassName = newValue;
                          _classController.text = _selectedClassName!;
                        });
                      },
                      items: _classList.map<DropdownMenuItem<String>>((dynamic item) {
                        String className = item['className'];
                        return DropdownMenuItem<String>(
                          value: className,
                          child: Text(className),
                        );
                      }).toList(),
                    ),
                  ),
          if (!(user.userId.contains("gv")) || _selectedRole == 'Giảng viên')
            _selectedRole == 'Giảng viên'
                ? const SizedBox(height: 10)
                : CustomTextField(
                    isReadOnly: true,
                    isPassword: false,
                    hintText: "Lớp",
                    controller: _classController,
                  ),
          const SizedBox(height: 10),
          if (!(user.userId.contains("gv") || user.userId.contains("dh")) || _selectedRole == 'Giảng viên')
             Text("Phân quyền",
              style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
          if (!(user.userId.contains("gv") || user.userId.contains("dh")) || _selectedRole == 'Giảng viên')
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
                items: <String>['Sinh viên', 'Giảng viên'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
      bottomNavigationBar: _showBottomNavBar
          ? BottomAppBar(
              surfaceTintColor: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomButton(
                    buttonText: "Cập nhật lại thông tin",
                    onPressed: () async {
                      String userId = _userIdController.text.trim();
                      String username = _usernameController.text.trim();
                      String address = _addressController.text.trim();
                      String gender = _sexController.text.trim();
                      String className = _classController.text.trim();
                      String phoneNum = _phoneController.text.trim();
                      if (username.isEmpty || address.isEmpty || gender.isEmpty || className.isEmpty) {
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
                          final response = await AppUtils.HandleUpdate(
                              userId, username, phoneNum, address, _selectedSex, className, _selectedRole);
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
                          print("Error: $e");
                        }
                      }
                    },
                  )
                ],
              ),
            )
          : null,
    );
  }
}


