import 'package:flutter/material.dart';
import 'package:flutter_doan/component/dialog.dart';
import 'package:flutter_doan/component/userNotInClassItem.dart';
import 'package:flutter_doan/model/user.dart';
import 'package:flutter_doan/utils/services.dart';

class getTeacherNotInClass extends StatefulWidget {
  final String subjectId;
  const getTeacherNotInClass({super.key, required this.subjectId});

  @override
  State<getTeacherNotInClass> createState() => _getTeacherNotInClassState();
}

class _getTeacherNotInClassState extends State<getTeacherNotInClass> {
  Future<Map<String, dynamic>> _userListFuture =
      AppUtils.getTeacherNotInClass();

  Future<void> refreshData() async {
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() {
      _userListFuture = AppUtils.getTeacherNotInClass();
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
        if (selectedUser.length < 1) {
          selectedUser.add(user.userId);
        } else {
          // Hiển thị thông báo cảnh báo nếu đã chọn nhiều hơn một giáo viên
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Cảnh báo"),
                content: Text("Bạn chỉ được chọn một giáo viên."),
                actions: <Widget>[
                  ElevatedButton(
                    child: Text("Đóng"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } else {
        selectedUser.remove(user.userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh sách giáo viên"),
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
              final response = await AppUtils.addTeacherInClass(
                  widget.subjectId, selectedUser.first);
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
}
