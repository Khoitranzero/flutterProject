import 'package:flutter/material.dart';
import 'package:flutter_doan/component/button.dart';
import 'package:flutter_doan/component/dialog.dart';
import 'package:flutter_doan/component/textfield.dart';
import 'package:flutter_doan/utils/services.dart';

class addSubjectIntoClass extends StatefulWidget {
  final int classId;
  const addSubjectIntoClass({super.key, required this.classId});

  @override
  State<addSubjectIntoClass> createState() => _addSubjectIntoClassState();
}

class _addSubjectIntoClassState extends State<addSubjectIntoClass> {
  Future<Map<String, dynamic>> _getListSubject = AppUtils.getSubjectList();

  List<dynamic> _subjectList = [];

  String _selectedSubjectName = '';
  String? _selectedSubjectId;

  final TextEditingController _subjectId = TextEditingController();
  final TextEditingController _subjectName = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getListSubject;
    _getListSubject
        .then((data) => setState(() {
              _subjectList = data['DT'];
            }))
        .catchError((e) {
      print("Lỗi gì đó ???");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thêm môn học cho lớp"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text("ID",
              style: TextStyle(
                  fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black)),
            height: 50,
            child: DropdownButton<String>(
              value: _selectedSubjectId,
              icon: const Icon(Icons.keyboard_arrow_down),
              hint: Text('Chọn môn học'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedSubjectId = newValue;
                  _subjectId.text = _selectedSubjectId!;
                  _selectedSubjectName = _subjectList.firstWhere(
                      (item) => item['subjectId'] == newValue)['subjectName'];
                  _subjectName.text = _selectedSubjectName;
                });
              },
              items: _subjectList.map<DropdownMenuItem<String>>((dynamic item) {
                String subjectId = item['subjectId'];
                String subjectName = item['subjectName'];
                return DropdownMenuItem<String>(
                  value: subjectId,
                  child: Text(subjectId),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),
          Text("Tên môn học",
              style: TextStyle(
                  fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
          CustomTextField(
            isReadOnly: true,
            isPassword: false,
            hintText: "Tên môn học",
            controller: _subjectName,
          ),
          BottomAppBar(
            surfaceTintColor: Colors.white,
            child: CustomButton(
              buttonText: "Thêm thông tin",
              onPressed: () async {
                String subjectId = _subjectId.text.trim();
                String subjectName = _subjectName.text.trim();
                try {
                  final response =
                      await AppUtils.updateClass(widget.classId, subjectId);
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
                } catch (e) {
                  print("Lỗi: $e");
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
