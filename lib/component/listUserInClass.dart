import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_doan/component/dialog.dart';
import 'package:flutter_doan/component/moveUserFromClassItem.dart';
import 'package:flutter_doan/component/userItem.dart';
import 'package:flutter_doan/model/user.dart';
import 'package:flutter_doan/screens/Lecturer/listLecturerNotInClass.dart';
import 'package:flutter_doan/screens/getUserNotInClass.dart';
import 'package:flutter_doan/screens/userDetail_page.dart';
import 'package:flutter_doan/screens/userPoin_page.dart';
import 'package:flutter_doan/utils/services.dart';

class ListUserInClass extends StatefulWidget {
  final bool haveTeacher;
  final List<User> listUser;
  final int classId;
  final String teacherID;
  final bool isGv;
  const ListUserInClass(
      {super.key,
      required this.haveTeacher,
      required this.listUser,
      required this.classId,
      required this.teacherID,
      required this.isGv});

  @override
  State<ListUserInClass> createState() => _ListUserInClassState();
}

class _ListUserInClassState extends State<ListUserInClass> {
  List<String> selectedUser = [];
  late List<bool> isCheckedList;
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
          actions: [
            PopupMenuButton<String>(
              itemBuilder: (BuildContext context) {
                List<PopupMenuEntry<String>> menuItems = [];
                if (!widget.haveTeacher) {
                  // Nếu không có giáo viên
                  menuItems.add(
                    PopupMenuItem<String>(
                      value: 'addTeacher',
                      child: Text('Thêm giáo viên phụ trách'),
                    ),
                  );
                } else {
                  menuItems.add(
                    PopupMenuItem<String>(
                      value: 'removeTeacher',
                      child: Text('Xóa giáo viên phụ trách'),
                    ),
                  );
                }
                menuItems.add(
                  PopupMenuItem<String>(
                    value: 'addStudents',
                    child: Text('Thêm sinh viên vào lớp'),
                  ),
                );
                return menuItems;
              },
              onSelected: (String value) async {
                switch (value) {
                  case 'addTeacher':
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                getTeacherNotInClass(classId: widget.classId)));
                    break;
                  case 'removeTeacher':
                    await _confirmRemoveTeacher(
                        context, widget.classId, widget.teacherID);
                    break;
                  case 'addStudents':
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ListUserNoClass(classId: widget.classId)));
                    break;
                }
              },
            ),
          ],
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
                  return Row(
                    children: [
                      Expanded(
                        child: UserItem(
                          user: user,
                          onPressedButton1: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UserDetail(userId: user.userId),
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
                      MoveUserClassItem(
                        user: user,
                        isChecked: isCheckedList[index],
                        onChanged: (isChecked) {
                          updateSelectedUsers(user, isChecked);
                        },
                      ),
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

  Future<bool> _confirmRemoveTeacher(
      BuildContext context, int id, String userId) async {
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
        final response = await AppUtils.removeTeacher(id, userId);
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
