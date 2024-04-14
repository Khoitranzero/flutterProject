import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_doan/component/dialog.dart';
import 'package:flutter_doan/component/userItem.dart';
import 'package:flutter_doan/component/userNotInClassItem.dart';
import 'package:flutter_doan/model/user.dart';
import 'package:flutter_doan/screens/userDetail_page.dart';
import 'package:flutter_doan/screens/userPoin_page.dart';
import 'package:flutter_doan/utils/services.dart';

class ListUserNoClass extends StatefulWidget {
  final int classId;
  const ListUserNoClass({Key? key, required this.classId}) : super(key: key);

  @override
  _ListUserNoClassState createState() => _ListUserNoClassState();
}

class _ListUserNoClassState extends State<ListUserNoClass> {
  Future<Map<String, dynamic>> _userListFuture = AppUtils.getUserNotInClass();

  Future<void> refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _userListFuture;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    refreshData();
  }

  List<String> selectedUser = [];
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
        title: Text("Danh sách sinh viên chưa có lớp"),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userListFuture,
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Đã xảy ra lỗi: ${snapshot.error}'));
          } else {
            final userDataList = snapshot.data!['DT'] as List<dynamic>;
            final userList =
                userDataList.map((item) => User.fromJson(item)).toList();
            List<bool> isCheckedList = List.filled(userList.length, false);
            return RefreshIndicator(
                child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: userList.length,
                  itemBuilder: (context, index) {
                    final user = userList[index];
                    if (user.userId.contains('admin')) {
                      return const SizedBox();
                    } else {
                      return Container(
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.yellow[400]),
                        child: UserNotInClassItem(
                            user: user,
                            isChecked: isCheckedList[index],
                            onChanged: (isChecked) {
                              updateSelectedUsers(user, isChecked);
                            }),
                      );
                    }
                  },
                ),
                onRefresh: () async {
                  await refreshData();
                });
          }
        },
      ),
      floatingActionButton: Container(
        width: 60,
        height: 60,
        child: FloatingActionButton.small(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          onPressed: () async {
            try {
              final response = await AppUtils.addMultipleUserToClass(
                  selectedUser, widget.classId);
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
                              Navigator.of(context).pop(),
                              Navigator.of(context).pop(),
                            });
                  },
                );
              }
            } catch (e) {
              print(e);
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
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
              onPressed: () => Navigator.of(context).pop(),
            );
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
