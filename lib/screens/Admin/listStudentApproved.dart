import 'package:flutter/material.dart';
import 'package:flutter_doan/component/dialog.dart';
import 'package:flutter_doan/component/userItem.dart';
import 'package:flutter_doan/component/userNotInClassItem.dart';
import 'package:flutter_doan/model/user.dart';
import 'package:flutter_doan/screens/userDetail_page.dart';
import 'package:flutter_doan/screens/userPoin_page.dart';
import 'package:flutter_doan/utils/services.dart';

class ListStudentApproved extends StatefulWidget {
  const ListStudentApproved({Key? key}) : super(key: key);

  @override
  _ListStudentApprovedState createState() => _ListStudentApprovedState();
}

class _ListStudentApprovedState extends State<ListStudentApproved> {
  List<User> userList = [];
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
        title: Text("Danh sách duyệt"),
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
            userList = userDataList.map((item) => User.fromJson(item)).toList();

            return RefreshIndicator(
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: userList.length,
                itemBuilder: (context, index) {
                  final user = userList[index];
                  if (user.userId.contains('admin')) {
                    return const SizedBox();
                  } else {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserDetail(phone: user.phone),
                          ),
                        );
                      },
                      onLongPress: () async {
                        final shouldDelete = await _confirmDeleteUser(context, user);
                        if (shouldDelete) {
                          refreshData();
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.yellow[400]
                        ),
                        child: UserNotInClassItem(
                          user: user,
                          isChecked: selectedUser.contains(user.userId),
                          onChanged: (isChecked) {
                            updateSelectedUsers(user, isChecked);
                          },
                        ),
                      ),
                    );
                  }
                },
              ),
              onRefresh: () async {
                await refreshData();
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: selectedUser.isNotEmpty
          ? () async {
              final shouldApprove = await _confirmApproveUsers(context);
              if (shouldApprove) {
                try {
                  for (String userId in selectedUser) {
                    final user = userList.firstWhere((element) => element.userId == userId);
                    // Send userId and password to user via phone
                    await AppUtils.sendUserInformation(user.phone, user.userId, user.password);
                      refreshData();
                  }
                } catch (e) {
                  print('Error: $e');
                }
              }
            }
          : null,
        child: const Text('Duyệt'),
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

  Future<bool> _confirmApproveUsers(BuildContext context) async {
    final shouldApprove = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: const Text('Bạn có muốn duyệt những người dùng đã chọn không?'),
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
    return shouldApprove ?? false;
  }
}
