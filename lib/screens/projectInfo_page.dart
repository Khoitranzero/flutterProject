import 'package:flutter/material.dart';
import 'package:flutter_doan/component/chip.dart';

class ProjectInfo extends StatelessWidget {
  const ProjectInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Về Đồ án"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Column(
                  children: <Widget>[
                    Text(
                      "Sinh viên thực hiện",
                      style: TextStyle(fontSize: 30),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1),
                          color: Colors.greenAccent),
                      child: Text(
                        "Họ và tên: Bùi Ngọc Na \nMSSV: DH52001092\nLớp: D20_TH03",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1)),
                      child: Text(
                        "Họ và tên: Trần Đình Khôi \nMSSV: DH52003844\nLớp: D20_TH03",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Text(
                      "Các chức năng",
                      style: TextStyle(fontSize: 30),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Công nghệ đã sử dụng",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              Wrap(
                direction: Axis.horizontal,
                spacing: 8,
                children: <Widget>[
                  CustomChip(title: ("Flutter")),
                  CustomChip(title: ("Atomic Design")),
                  CustomChip(title: ("Wampp Server")),
                  CustomChip(title: ("JWT-Javascript Web Token")),
                  CustomChip(title: ("Sequelize")),
                  CustomChip(title: ("NodeJS")),
                  CustomChip(title: ("MySQL")),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Các chức năng đối với sinh viên",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              Wrap(
                direction: Axis.horizontal,
                spacing: 8,
                children: <Widget>[
                  CustomChip(title: ("Thêm sinh viên bằng cách đăng ký")),
                  CustomChip(title: ("Xóa thông tin sinh viên")),
                  CustomChip(title: ("Cập nhật thông tin sinh viên")),
                  CustomChip(title: ("Đổi lớp cho sinh viên")),
                  CustomChip(title: ("Thêm điểm cho sinh viên")),
                  CustomChip(title: ("Thêm môn học cho sinh viên theo học kỳ")),
                  CustomChip(title: ("Quản lý tài khoản cá nhân")),
                  CustomChip(title: ("Xem điểm theo học kỳ")),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Các chức năng đối với môn học",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              Wrap(
                direction: Axis.horizontal,
                spacing: 8,
                children: <Widget>[
                  CustomChip(title: ("Hiển thị thông tin môn học")),
                  CustomChip(title: ("Thêm thông tin môn học")),
                  CustomChip(title: ("Cập nhật thông tin môn học")),
                  CustomChip(title: ("Xóa thông tin môn học")),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Các chức năng đối với lớp học",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              Wrap(
                direction: Axis.horizontal,
                spacing: 8,
                children: <Widget>[
                  CustomChip(
                      title:
                          "Hiển thị thông tin lớp học và số lượng sinh viên"),
                  CustomChip(title: ("Xem danh sách sinh viên trong lớp học")),
                  CustomChip(
                      title:
                          "Xem danh sách sinh viên không có thông tin lớp học"),
                  CustomChip(title: ("Thêm thông tin lớp học")),
                  CustomChip(title: ("Cập nhật thông tin lớp học")),
                  CustomChip(title: ("Xóa thông tin lớp học")),
                  CustomChip(title: ("Thêm nhiều sinh viên vào lớp học")),
                  CustomChip(title: ("Xóa nhiều sinh viên ra lớp học")),
                ],
              )
            ],
          ),
        ));
  }
}
