import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_doan/component/dialog.dart';
import 'package:flutter_doan/component/moveUserFromClassItem.dart';
import 'package:flutter_doan/component/userItem.dart';
import 'package:flutter_doan/model/user.dart';
import 'package:flutter_doan/screens/Lecturer/addSubjectIntoClass.dart';
import 'package:flutter_doan/screens/Lecturer/listLecturerNotInClass.dart';
import 'package:flutter_doan/screens/getUserNotInClass.dart';
import 'package:flutter_doan/screens/userDetail_page.dart';
import 'package:flutter_doan/screens/userPoin_page.dart';
import 'package:flutter_doan/utils/services.dart';
import 'package:flutter_doan/utils/tokenService.dart';

class ListUserInClassForTeacher extends StatefulWidget {
  final bool haveTeacher;
  final List<User> listUser;
  final int classId;
  final String teacherID;
  final bool isGv;
  const ListUserInClassForTeacher(
      {super.key,
      required this.haveTeacher,
      required this.listUser,
      required this.classId,
      required this.teacherID,
      required this.isGv});

  @override
  State<ListUserInClassForTeacher> createState() =>
      _ListUserInClassForTeacherState();
}

class _ListUserInClassForTeacherState extends State<ListUserInClassForTeacher> {
  List<String> selectedUser = [];
  late List<bool> isCheckedList;
  String? _role;
  String? isTeacher;
  String? isAdmin;
  @override
  void initState() {
    super.initState();
    _getRole();
  }

  Future<void> _getRole() async {
    final tokenAndRole = await TokenService.getTokenAndRole();
    _role = tokenAndRole['role'] ?? '';
    setState(() {
      isTeacher = _role!.contains("gv") ? 'gv' : null;
    });
  }

  void updateSelectedUsers(User user, bool isChecked) {
    setState(() {
      if (isChecked) {
        selectedUser.add(user.userId);
      } else {
        selectedUser.remove(user.userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Danh sách lớp ${widget.classId}'),
        ),
        body: widget.listUser.isEmpty
            ? const Center(
                child: Text(
                  'Lớp trống',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: widget.listUser.length,
                itemBuilder: (context, index) {
                  final user = widget.listUser[index];
                  isCheckedList = List.filled(widget.listUser.length, false);
                  if (user.userId.contains("gv")) {
                    return Container();
                  }
                  print(isTeacher);
                  return Row(
                    children: [
                      Expanded(
                        child: UserItem(
                          user: user,
                          onPressedButton1: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  // UserDetail(phone: user.phone),
                                  UserDetail(phone: user.phone),
                            ),
                          ),
                          onPressedButton2: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UserPointPage(userId: user.userId),
                            ),
                          ),
                          onPressedButton3: () async {
                            await _confirmDeleteUser(context, user);
                          },
                        ),
                      ),
                      isTeacher == null
                          ? MoveUserClassItem(
                              user: user,
                              isChecked: isCheckedList[index],
                              onChanged: (isChecked) {
                                updateSelectedUsers(user, isChecked);
                              },
                            )
                          : const SizedBox()
                    ],
                  );
                }),
        floatingActionButton: widget.isGv
            ? null
            : Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  widget.listUser.isEmpty || selectedUser.isEmpty
                      ? const SizedBox()
                      : Container(
                          width: 180,
                          height: 60,
                          child: FloatingActionButton.small(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            onPressed: () async {
                              final response =
                                  await AppUtils.moveMultipleUserFromClass(
                                      selectedUser);
                              if (response.isNotEmpty) {
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
                                            });
                                  },
                                );
                              }
                            },
                            child: const Text("Xóa sinh viên ra khỏi lớp"),
                          ),
                        ),
                ],
              ));
  }

  Future<bool> _confirmDeleteUser(BuildContext context, User user) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: const Text('Bạn có muốn xóa người dùng này không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Không'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Có'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != null && shouldDelete) {
      try {
        final response = await AppUtils.deleteUser(user.userId);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialogAlert(
                title: "Thông báo",
                message: response['EM'],
                closeButtonText: "Đóng",
                onPressed: () =>
                    {Navigator.of(context).pop(), Navigator.of(context).pop()});
          },
        );
        return true;
      } catch (e) {
        print('Lỗi khi xóa người dùng: $e');
      }
    }
    return false;
  }
}
