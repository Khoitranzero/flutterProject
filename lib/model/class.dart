import 'package:flutter_doan/model/user.dart';

class ClassInfo {
  int id;
  String className;
  List<User> users;
  int count;
  ClassInfo({
    required this.id,
    required this.className,
    required this.users,
    required this.count,
  });
  factory ClassInfo.fromJson(Map<String, dynamic> json) {
    List<User> users = [];
    if (json['classItem']['Users'] is List) {
      users = (json['classItem']['Users'] as List)
          .map((userData) => User.fromJson(userData))
          .toList();
    }
    return ClassInfo(
      id: json['classItem']['id'],
      className: json['classItem']['className'] ?? 'Chưa cập nhật',
      users: users,
      count: json['count'] ?? 0,
    );
  }
}
