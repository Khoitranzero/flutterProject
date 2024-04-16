import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_doan/component/classItem.dart';
import 'package:flutter_doan/component/dialog.dart';
import 'package:flutter_doan/component/listUserInClass.dart';
import 'package:flutter_doan/component/userItem.dart';
import 'package:flutter_doan/model/class.dart';
import 'package:flutter_doan/screens/Class/classAdd.dart';
import 'package:flutter_doan/utils/services.dart';
import 'package:flutter_doan/utils/tokenService.dart';
import 'package:http/http.dart';

class ClassList extends StatefulWidget {
  const ClassList({super.key});

  @override
  State<ClassList> createState() => _ClassListState();
}

class _ClassListState extends State<ClassList> {
  bool isGv = false;
  Future<Map<String, dynamic>> _classListFuture = AppUtils.getClassList();
  Future<void> refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _getRole();
      _classListFuture = AppUtils.getClassList();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    refreshData();
  }

  Future<void> _getRole() async {
    final tokenAndRole = await TokenService.getTokenAndRole();
    String? _role = tokenAndRole['role'] ?? '';
    if (_role.contains("gv")) {
      setState(() {
        isGv = true;
      });
    } else {
      setState(() {
        isGv = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Danh sách lớp học"),
        ),
        body: FutureBuilder<Map<String, dynamic>>(
          future: _classListFuture,
          builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text("Something went wrong ${snapshot.error}"));
            } else {
              final classListData = snapshot.data!['DT'] as List<dynamic>;
              final classList = classListData
                  .map((item) => ClassInfo.fromJson(item))
                  .toList();
              return RefreshIndicator(
                  child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: classList.length,
                      itemBuilder: (context, index) {
                        final classInfoItem = classList[index];
                        return ClassItem(
                          classInfoItem: classInfoItem,
                          onPressed: () {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ListUserInClass(
                                            listUser: classInfoItem.users,
                                            classId: classInfoItem.id,
                                            isGv: isGv)))
                                .then((value) => refreshData());
                          },
                          onLongPressed: () async {
                            final deleteAction = await _confirmDeleteClass(
                                context, classInfoItem.id);
                            if (deleteAction) {
                              refreshData();
                            }
                          },
                        );
                      }),
                  onRefresh: () async {
                    refreshData();
                  });
            }
          },
        ),
        floatingActionButton: isGv
            ? null
            : Container(
                width: 60,
                height: 60,
                child: FloatingActionButton.small(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const classAdd()))
                      .then((value) => refreshData()),
                  child: const Icon(Icons.add),
                ),
              ));
  }

  Future<bool> _confirmDeleteClass(BuildContext context, int classId) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: const Text('Bạn có muốn xóa lớp học này không?'),
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
        final response = await AppUtils.deleteClass(classId);
        if (response.isNotEmpty) {
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
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialogAlert(
                title: "Thông báo",
                message: "Xóa môn học thất bại",
                closeButtonText: "Đóng",
                onPressed: () => Navigator.of(context).pop(),
              );
            },
          );
        }
        return true;
      } catch (e) {
        print('Lỗi khi xóa môn học: $e');
      }
    }
    return false;
  }
}
