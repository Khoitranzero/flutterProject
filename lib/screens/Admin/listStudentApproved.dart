import 'package:flutter/material.dart';
import 'package:flutter_doan/component/dialog.dart';
import 'package:flutter_doan/component/userItem.dart';
import 'package:flutter_doan/model/user.dart';
import 'package:flutter_doan/screens/getUserNotInClass.dart';
import 'package:flutter_doan/screens/userDetail_page.dart';
import 'package:flutter_doan/screens/userPoin_page.dart';
import 'package:flutter_doan/utils/services.dart';

class ListStudentApproved extends StatefulWidget {
  const ListStudentApproved({Key? key}) : super(key: key);

  @override
  _ListStudentApprovedState createState() => _ListStudentApprovedState();
}

class _ListStudentApprovedState extends State<ListStudentApproved> {
  Future<Map<String, dynamic>> _userListFuture = AppUtils.getListStudentApproved();

  Future<void> refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _userListFuture;
      _userListFuture = AppUtils.getListStudentApproved();
    });
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh sách sinh viên"),
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

            return RefreshIndicator(
                child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: userList.length,
                  itemBuilder: (context, index) {
                    final user = userList[index];
                    if (user.userId.contains('admin') ||
                        user.userId.contains("gv")) {
                      return const SizedBox();
                    } else {
  return Row(
    children: [
      Expanded(
        child: UserItem(
          user: user,
          onPressedButton1: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserDetail(userId: user.userId),
              ),
            );
          },
          onPressedButton2: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserPointPage(userId: user.userId),
              ),
            );
          },
          onPressedButton3: () async {
            final shouldDelete = await _confirmDeleteUser(context, user);
            if (shouldDelete) {
              refreshData();
            }
          },
        ),
      ),
      Checkbox(
        value: selectedUser.contains(user.userId),
        onChanged: (isChecked) {
          updateSelectedUsers(user, isChecked ?? false);
        },
      ),
    ],
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
   floatingActionButton: FloatingActionButton(
        onPressed: () async {
        //   try {
        //     for (String userId in selectedUser) {
        //       final user = userList.firstWhere((element) => element.userId == userId);
        //       // Send userId and password to user via phone
        //       await AppUtils.sendUserInformation(user.phone, user.userId, user.password);
        //     }
        //   } catch (e) {
        //     print('Error: $e');
        //   }
         },
        child: const Icon(Icons.add),
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
        refreshData();
        return true;
      } catch (e) {
        print('Lỗi khi xóa người dùng: $e');
      }
    }
    return false;
  }
}
