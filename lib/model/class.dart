import 'package:flutter_doan/model/user.dart';

class ClassInfo {
  int id;
  String className;
  User teacherInfo;
  String roomName;
  List<User> users;
  int count;

  ClassInfo({
    required this.id,
    required this.className,
    required this.teacherInfo,
    required this.roomName,
    required this.users,
    required this.count,
  });

  factory ClassInfo.fromJson(Map<String, dynamic> json) {
    int id = json['id'] ?? 0;
    String className = json['className'] ?? 'Chưa cập nhật';
    User teacherInfo = User.fromJson(json['teacherName'] ?? {});
    String roomName = json['roomName'] ?? 'Chưa cập nhật';
    List<User> students = [];
    if (json['students'] is List) {
      students = (json['students'] as List)
          .map((userData) => User.fromJson(userData))
          .toList();
    }
    int count = json['count'] ?? 0;
    print(teacherInfo);
    return ClassInfo(
      id: id,
      className: className,
      teacherInfo: teacherInfo,
      roomName: roomName,
      users: students,
      count: count,
    );
  }
}
