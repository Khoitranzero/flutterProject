import 'package:flutter/material.dart';
import 'package:flutter_doan/component/button.dart';
import 'package:flutter_doan/component/dialog.dart';
import 'package:flutter_doan/component/textfield.dart';
import 'package:flutter_doan/utils/services.dart';
import 'package:http/http.dart';

class subjectAdd extends StatefulWidget {
  const subjectAdd({super.key});

  @override
  State<subjectAdd> createState() => _subjectAddState();
}

class _subjectAddState extends State<subjectAdd> {
  TextEditingController _subjectId = TextEditingController();
  TextEditingController _subjectName = TextEditingController();
    TextEditingController _credits = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm môn học'),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            CustomTextField(
                isPassword: false,
                hintText: "Mã môn học",
                controller: _subjectId,
                isReadOnly: false),
            const SizedBox(height: 10),
            CustomTextField(
                isPassword: false,
                hintText: "Tên môn học",
                controller: _subjectName,
                isReadOnly: false),
            const SizedBox(height: 10),
             CustomTextField(
                isPassword: false,
                hintText: "Số tín chỉ",
                controller: _credits,
                isReadOnly: false),
            const SizedBox(height: 10),
            CustomButton(
                buttonText: "Thêm môn",
                onPressed: () async {
                  String subjectId = _subjectId.text.trim();
                  String subjectName = _subjectName.text.trim();
                   String credits = _credits.text.trim();
                  if (subjectName.isEmpty || subjectId.isEmpty || credits.isEmpty) {
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
                        await AppUtils.addSubject(subjectId, subjectName, credits);
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
