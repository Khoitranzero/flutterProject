import 'package:flutter/material.dart';
import 'package:flutter_doan/component/button.dart';
import 'package:flutter_doan/component/dialog.dart';
import 'package:flutter_doan/component/textfield.dart';
import 'package:flutter_doan/utils/services.dart';
import 'package:http/http.dart';

class classAdd extends StatefulWidget {
  const classAdd({super.key});

  @override
  State<classAdd> createState() => _classAddState();
}

class _classAddState extends State<classAdd> {
  String? _selectedSubjectId;
  String? _selectedSubjectName;
  List<dynamic> _subjectList = [];
  final TextEditingController _className = TextEditingController();
  final TextEditingController _roomName = TextEditingController();
  final TextEditingController _subjectName = TextEditingController();
  final Future<Map<String, dynamic>> _getSubjectList =
      AppUtils.getSubjectList();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getSubjectList;
    _getSubjectList.then((value) => setState(() {
          _subjectList = value['DT'];
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm lớp'),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            CustomTextField(
                isPassword: false,
                hintText: "Tên lớp",
                controller: _className,
                isReadOnly: false),
            const SizedBox(height: 10),
            CustomTextField(
                isPassword: false,
                hintText: "Phòng",
                controller: _roomName,
                isReadOnly: false),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              width: 400,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black)),
              height: 50,
              margin: const EdgeInsets.only(bottom: 15),
              child: DropdownButton<String>(
                value: _selectedSubjectId,
                hint: const Text("Chọn môn học"),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedSubjectId = newValue;
                    _selectedSubjectName = _subjectList.firstWhere((subject) =>
                        subject['subjectId'] ==
                        _selectedSubjectId)['subjectName'];
                    _subjectName.text = _selectedSubjectName!;
                  });
                },
                items: _subjectList.map((item) {
                  String subjectId = item['subjectId'];
                  String subjectName = item['subjectName'];
                  return DropdownMenuItem<String>(
                    value: subjectId,
                    child: Text(subjectName),
                  );
                }).toList(),
              ),
            ),
            CustomTextField(
                isPassword: false,
                hintText: "Môn học",
                controller: _subjectName,
                isReadOnly: true),
            const SizedBox(height: 10),
            CustomButton(
                buttonText: "Thêm lớp",
                onPressed: () async {
                  String className = _className.text.trim();
                  String roomName = _roomName.text.trim();
                  String subjectId = _selectedSubjectId.toString();
                  if (className.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomDialogAlert(
                            title: "Thông báo",
                            message: "Vui lòng nhập đầy đủ thông tin",
                            closeButtonText: "Đóng",
                            onPressed: () => {
                                  Navigator.of(context).pop(),
                                });
                      },
                    );
                  } else {
                    final response =
                        await AppUtils.addClass(className, roomName, subjectId);
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
                                });
                      },
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
