import 'package:flutter/material.dart';
import 'package:flutter_doan/component/dialog.dart';
import 'package:flutter_doan/model/subject.dart';
import 'package:flutter_doan/screens/Subject/subjectAdd_page.dart';
import 'package:flutter_doan/screens/Subject/subjectUpdate_page.dart';
import 'package:flutter_doan/utils/services.dart';
import 'package:flutter_doan/utils/tokenService.dart';

class SubjectList extends StatefulWidget {
  const SubjectList({super.key});

  @override
  State<SubjectList> createState() => _SubjectListState();
}

class _SubjectListState extends State<SubjectList> {
   bool isGv = false;
  Future<Map<String, dynamic>> _subjectListFuture = AppUtils.getSubjectList();
  Future<void> refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _getRole();
      _subjectListFuture = AppUtils.getSubjectList();
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
  List<DataRow> convertToDataRows(List<dynamic>? subjectDataList) {
    if (subjectDataList == null) {
      return [];
    }
    return subjectDataList.map<DataRow>((subject) {
      return DataRow(
        cells: [
          DataCell(Text(subject['subjectId'] ?? '')),
          DataCell(Text(subject['subjectName'] ?? '')),
        ],
      );
    }).toList();
  }

 void myLongPressFunction(String subjectId) async {
    if (!isGv) {
      final deleteAction = await _confirmDeleteSubject(context, subjectId);
      if (deleteAction) {
        refreshData();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Danh sách môn học')),
        body: FutureBuilder<Map<String, dynamic>>(
            future: _subjectListFuture,
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Lỗi: ${snapshot.error}'));
              } else {
                final List<dynamic>? subjectDataList =
                    snapshot.data!['DT'] as List<dynamic>?;
                final subjectList = subjectDataList!
                    .map<DataRow>((item) => DataRow(cells: [
                          DataCell(
                              onTap:isGv ? null : () => {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return UdapteSubjectInfo(
                                          subjectId:
                                              item['subjectId'].toString(),
                                          subjectName:
                                              item['subjectName'].toString());
                                    })).then((value) => refreshData()),
                                  },
                              onLongPress: () {
                                myLongPressFunction(
                                    item['subjectId'].toString());
                              },
                              SizedBox.expand(
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                        right: BorderSide(color: Colors.black)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 14),
                                    child: Text(
                                        item['subjectId'].toString() ?? '',
                                        style: TextStyle(fontSize: 15)),
                                  ),
                                ),
                              )),
                          DataCell(
                            onTap:isGv ? null : () => {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return UdapteSubjectInfo(
                                    subjectId: item['subjectId'].toString(),
                                    subjectName:
                                        item['subjectName'].toString());
                              })).then((value) => refreshData()),
                            },
                            onLongPress: () {
                              myLongPressFunction(item['subjectId'].toString());
                            },
                            Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border(
                                      right: BorderSide(color: Colors.black)),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child:
                                      Text(item['subjectName'].toString() ?? '',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          )),
                                )),
                          )
                        ]))
                    .toList();

                return RefreshIndicator(
                  onRefresh: refreshData,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      child: DataTable(
                        columnSpacing: MediaQuery.of(context).size.width * 0,
                        columns: [
                          DataColumn(
                              label: Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            decoration: BoxDecoration(
                                border: Border(
                                    right: BorderSide(color: Colors.black))),
                            child: Center(child: Text("ID")),
                          )),
                          DataColumn(
                              label: Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            decoration: BoxDecoration(
                                border: Border(
                                    right: BorderSide(color: Colors.black))),
                            child: Center(
                              child: Text('Tên môn học'),
                            ),
                          )),
                        ],
                        rows: subjectList,
                      ),
                    ),
                  ),
                );
              }
            })),
        floatingActionButton:isGv ? null : Container(
          width: 60,
          height: 60,
          child: FloatingActionButton.small(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const subjectAdd()))
                .then((value) => refreshData()),
            child: const Icon(Icons.add),
          ),
        ));
  }

  Future<bool> _confirmDeleteSubject(
      BuildContext context, String subjectId) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: const Text('Bạn có muốn xóa môn học này không?'),
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
        final response = await AppUtils.deleteSubject(subjectId);
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
        print('Lỗi khi xóa môn học: $e');
      }
    }
    return false;
  }
}
