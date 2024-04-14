import 'package:flutter/material.dart';
import 'package:flutter_doan/component/button.dart';
import 'package:flutter_doan/component/dialog.dart';
import 'package:flutter_doan/component/textfield.dart';
import 'package:flutter_doan/utils/services.dart';
import 'package:http/http.dart';

class UpdateSubjectAndPoint extends StatefulWidget {
  final String subjectId;
  final String subject;
  final String point;
  final String hocky;
  const UpdateSubjectAndPoint(
      {super.key,
      required this.subjectId,
      required this.subject,
      required this.point,
      required this.hocky});

  @override
  State<UpdateSubjectAndPoint> createState() => _UpdateSubjectAndPointState();
}

final TextEditingController _subjectIdController = TextEditingController();
final TextEditingController _subjectNameController = TextEditingController();
final TextEditingController _subjectPointController = TextEditingController();
final TextEditingController _subjectHocKyController = TextEditingController();
void clearTextField() {
  _subjectPointController.text = "";
}

class _UpdateSubjectAndPointState extends State<UpdateSubjectAndPoint> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _subjectIdController.text = widget.subjectId;
    _subjectHocKyController.text = widget.hocky;
    _subjectNameController.text = widget.subject;
    _subjectPointController.text = widget.point;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Cập nhật điểm cho môn học'),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Column(
                children: <Widget>[
                  CustomTextField(
                      isPassword: false,
                      hintText: "Mã môn học",
                      controller: _subjectIdController,
                      isReadOnly: true),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                      isPassword: false,
                      hintText: "Học kỳ",
                      controller: _subjectHocKyController,
                      isReadOnly: true),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                      isPassword: false,
                      hintText: "Tên môn học",
                      controller: _subjectNameController,
                      isReadOnly: true),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                      isPassword: false,
                      hintText: "Điểm",
                      controller: _subjectPointController,
                      isReadOnly: false),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                      buttonText: "Cập nhật thông tin",
                      onPressed: () async {
                        String subjectId = _subjectIdController.text.trim();
                        String subjectName = _subjectNameController.text.trim();
                        String subjectPoint =
                            _subjectPointController.text.trim();
                        if (subjectName.isEmpty ||
                            subjectPoint.isEmpty ||
                            _subjectIdController.text.isEmpty ||
                            _subjectHocKyController.text.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialogAlert(
                                title: "Thông báo",
                                message: "Vui lòng nhập đầy đủ thông tin",
                                closeButtonText: "Đóng",
                                onPressed: () => Navigator.of(context).pop(),
                              );
                            },
                          );
                        } else if (int.parse(subjectPoint) < 0 ||
                            int.parse(subjectPoint) > 10) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialogAlert(
                                  title: "Thông báo",
                                  message: "Điểm phải từ 0 - 10",
                                  closeButtonText: "Đóng",
                                  onPressed: () => {
                                        Navigator.of(context).pop(),
                                        clearTextField()
                                      });
                            },
                          );
                        } else {
                          try {
                            final response = await AppUtils.updateTablePoint(
                                subjectName, subjectId, subjectPoint);
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
                      })
                ],
              ),
            ),
          ),
        ));
  }
}
