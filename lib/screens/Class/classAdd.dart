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
  TextEditingController _className = TextEditingController();
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
            CustomButton(
                buttonText: "Thêm lớp",
                onPressed: () async {
                  String className = _className.text.trim();
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
                    print(className);
                    final response =
                        await AppUtils.addClass(className);
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
