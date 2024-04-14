import 'package:flutter/material.dart';
import 'package:flutter_doan/component/button.dart';
import 'package:flutter_doan/component/dialog.dart';
import 'package:flutter_doan/component/textfield.dart';
import 'package:flutter_doan/utils/services.dart';

class UdapteSubjectInfo extends StatefulWidget {
  final String subjectId;
  final String subjectName;
  const UdapteSubjectInfo(
      {super.key, required this.subjectId, required this.subjectName});

  @override
  State<UdapteSubjectInfo> createState() => _UdapteSubjectState();
}

class _UdapteSubjectState extends State<UdapteSubjectInfo> {
  TextEditingController _subjectId = TextEditingController();
  TextEditingController _subjectName = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _subjectId.text = widget.subjectId;
    _subjectName.text = widget.subjectName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cập nhật thông tin môn học')),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
          child: Column(
            children: <Widget>[
              CustomTextField(
                  isPassword: false,
                  hintText: "Mã môn học",
                  controller: _subjectId,
                  isReadOnly: false),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                  isPassword: false,
                  hintText: "Tên môn học",
                  controller: _subjectName,
                  isReadOnly: false),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                  buttonText: "Cập nhật thông tin",
                  onPressed: () async {
                    String subjectId = _subjectId.text.trim();
                    String subjectName = _subjectName.text.trim();
                    final response =
                        await AppUtils.updateSubject(subjectId, subjectName);
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
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
