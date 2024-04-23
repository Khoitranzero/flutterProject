import 'package:flutter_doan/model/user.dart';

class ClassInfo {
  int id;
  String subjectName;
  String className;
  User teacherInfo;
  List<User> users;
  int count;
  ClassInfo({
    required this.id,
    required this.subjectName,
    required this.className,
    required this.teacherInfo,
    required this.users,
    required this.count,
  });
  factory ClassInfo.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('Users') && json['Users'] is List) {
      final List<User> users = (json['Users'] as List)
          .map((userData) => User.fromJson(userData))
          .toList();
      return ClassInfo(
        id: json['id'] ?? 'Chưa cập nhật',
        subjectName: json['subjectInfo']['subjectName'] ?? "Chưa cập nhật",
        className: json['className'] ?? 'Chưa cập nhật',
        teacherInfo: User.fromJson(json['teacherInfo'] ?? {}),
        users: users,
        count: json['count'] ?? 0,
      );
    }

    return ClassInfo(
      id: 0,
      subjectName: 'Chưa cập nhật',
      className: 'Chưa cập nhật',
      teacherInfo: User.fromJson({}),
      users: [],
      count: 0,
    );
  }
}
