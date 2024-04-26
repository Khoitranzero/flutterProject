import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_doan/component/classItem.dart';
import 'package:flutter_doan/component/classSubjectItem.dart';
import 'package:flutter_doan/component/dialog.dart';
import 'package:flutter_doan/component/listUserInClass.dart';
import 'package:flutter_doan/component/userItem.dart';
import 'package:flutter_doan/model/class.dart';
import 'package:flutter_doan/model/classSubject.dart';
import 'package:flutter_doan/screens/Class/classAdd.dart';
import 'package:flutter_doan/utils/services.dart';
import 'package:flutter_doan/utils/tokenService.dart';
import 'package:http/http.dart';

class ClassListItem extends StatefulWidget {
  final String subjectName;
  final String subjectId;
  final List<dynamic> classIds;
  const ClassListItem(
      {super.key,
      required this.subjectId,
      required this.classIds,
      required this.subjectName});

  @override
  State<ClassListItem> createState() => _ClassListItemState();
}

class _ClassListItemState extends State<ClassListItem> {
  bool isGv = false;

  Future<List<ClassInfo>> _fetchClasses() async {
    List<ClassInfo> classes = [];
    try {
      for (var id in widget.classIds) {
        final classId = id['id'];
        final classData = await AppUtils.getClassByID(classId);
        final classInfo = ClassInfo.fromJson(classData['DT']);
        classes.add(classInfo);
      }
    } catch (e) {
      print('Error fetching classes: $e');
    }
    return classes;
  }

  Future<void> refreshData() async {
    await Future.delayed(const Duration(microseconds: 100));
    setState(() {
      _getRole();
      _fetchClasses;
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
          title: Text("${widget.subjectName}"),
        ),
        body: FutureBuilder<List<ClassInfo>>(
          future: _fetchClasses(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text("Something went wrong ${snapshot.error}"));
            } else {
              final classes = snapshot.data!;
              return RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    _getRole();
                  });
                },
                child: ListView.builder(
                  itemCount: classes.length,
                  itemBuilder: (context, index) {
                    final classItem = classes[index];
                    return ClassItem(
                      classInfoItem: classItem,
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListUserInClass(
                              haveTeacher: classItem.teacherInfo.userId ==
                                      "Chưa cập nhật"
                                  ? false
                                  : true,
                              teacherID: classItem.teacherInfo.userId,
                              subjectId: widget.subjectId,
                              listUser: classItem.users,
                              classId: classItem.id,
                              isGv: isGv,
                            ),
                          ),
                        );
                        setState(() {
                          _getRole();
                        });
                      },
                      onLongPressed: () async {
                        final deleteAction =
                            await _confirmDeleteClass(context, classItem.id);
                        if (deleteAction) {
                          setState(() {
                            _getRole();
                          });
                        }
                      },
                    );
                  },
                ),
              );
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
                  onPressed: () => {
                        Navigator.of(context).pop(),
                        Navigator.of(context).pop()
                      });
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialogAlert(
                title: "Thông báo",
                message: "Xóa lớp học thất bại",
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
