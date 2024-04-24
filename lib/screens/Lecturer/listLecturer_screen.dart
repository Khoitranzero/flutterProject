import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_doan/component/dialog.dart';
import 'package:flutter_doan/component/userItem.dart';
import 'package:flutter_doan/model/user.dart';
import 'package:flutter_doan/screens/userDetail_page.dart';
import 'package:flutter_doan/screens/userPoin_page.dart';
import 'package:flutter_doan/utils/services.dart';

class ListLecturerPage extends StatefulWidget {
  const ListLecturerPage({super.key});

  @override
  State<ListLecturerPage> createState() => _ListLecturerPageState();
}

class _ListLecturerPageState extends State<ListLecturerPage> {
  late Future<Map<String, dynamic>> _lecturerListFuture =
      AppUtils.getLecturerList();
  Future<void> refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _lecturerListFuture;
      _lecturerListFuture = AppUtils.getLecturerList();
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
        title: Text("Danh sách giảng viên"),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _lecturerListFuture,
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
                    if (user.userId.contains('admin')) {
                      return const SizedBox();
                    } else {
                      return UserItem(
                        user: user,
                        onPressedButton1: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  // UserDetail(userId: user.userId),
                                   UserDetail(phone: user.phone),
                            ),
                          );
                        },
                        onPressedButton2: () {},
                        onPressedButton3: () async {
                          final shouldDelete =
                              await _confirmDeleteUser(context, user);
                          if (shouldDelete) {
                            refreshData();
                          }
                        },
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
