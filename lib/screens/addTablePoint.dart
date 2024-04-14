import 'package:flutter/material.dart';
import 'package:flutter_doan/component/button.dart';
import 'package:flutter_doan/component/dialog.dart';
import 'package:flutter_doan/component/textfield.dart';
import 'package:flutter_doan/model/user.dart';
import 'package:flutter_doan/utils/services.dart';

class AddTablePointPage extends StatefulWidget {
  final String userId;
  final String hocky;

  const AddTablePointPage({Key? key, required this.userId, required this.hocky})
      : super(key: key);

  @override
  _AddTablePointPageState createState() => _AddTablePointPageState();
}

class _AddTablePointPageState extends State<AddTablePointPage> {
  Future<Map<String, dynamic>> _getListSubject = AppUtils.getSubjectList();
  List<dynamic> _subjectList = [];
  final TextEditingController _subjectId = TextEditingController();
  final TextEditingController _subjectName = TextEditingController();
  final TextEditingController _point = TextEditingController();
  void clearTextField() {
    _point.text = "";
  }

  String _selectedSubjectName = '';
  String? _selectedSubjectId;
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
        title: Text("Thêm điểm"),
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
          const SizedBox(height: 10),
          Text("Điểm",
              style: TextStyle(
                  fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
          CustomTextField(
            isReadOnly: false,
            isPassword: false,
            hintText: "Điểm",
            controller: _point,
          ),
          const SizedBox(height: 10),
          BottomAppBar(
            surfaceTintColor: Colors.white,
            child: CustomButton(
              buttonText: "Thêm điểm",
              onPressed: () async {
                String subjectId = _subjectId.text.trim();
                String subjectName = _subjectName.text.trim();
                String point = _point.text.trim();
                if (point.isEmpty) {
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
                } else if (int.parse(point) < 0 || int.parse(point) > 10) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomDialogAlert(
                          title: "Thông báo",
                          message: "Điểm phải từ 0 - 10",
                          closeButtonText: "Đóng",
                          onPressed: () =>
                              {Navigator.of(context).pop(), clearTextField()});
                    },
                  );
                } else {
                  try {
                    final hk = widget.hocky == 'Học kỳ 1' ? '1' : '2';
                    final response = await AppUtils.addTablePoint(
                        widget.userId, subjectId, point, hk);
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
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
