import 'package:flutter/material.dart';
import 'package:flutter_doan/component/classItem.dart';
import 'package:flutter_doan/component/dialog.dart';
import 'package:flutter_doan/component/listUserInClass.dart';
import 'package:flutter_doan/model/class.dart';
import 'package:flutter_doan/utils/services.dart';
import 'package:flutter_doan/utils/tokenService.dart';

class ClassListForLecturer extends StatefulWidget {
  final String teacherID;
  const ClassListForLecturer({required this.teacherID, super.key});

  @override
  State<ClassListForLecturer> createState() => _ClassListForLecturerState();
}

class _ClassListForLecturerState extends State<ClassListForLecturer> {
  late String teacherID;
  bool isGv = false;
  late Future<Map<String, dynamic>> _classListFuture;
  @override
  void initState() {
    super.initState();
    teacherID = widget.teacherID;
    _classListFuture = AppUtils.getClassByTeacherID(widget.teacherID);
  }

  Future<void> refreshData() async {
    await Future.delayed(const Duration(microseconds: 100));
    setState(() {
      _getRole();
      _classListFuture = AppUtils.getClassByTeacherID(widget.teacherID);
    });
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
                                            haveTeacher: classInfoItem
                                                        .teacherInfo.userId ==
                                                    "Chưa cập nhật"
                                                ? false
                                                : true,
                                            teacherID: classInfoItem
                                                .teacherInfo.userId,
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
