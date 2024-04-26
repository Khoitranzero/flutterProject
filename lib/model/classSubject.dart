import 'package:flutter_doan/model/user.dart'; // Import model User
import 'package:flutter_doan/model/class.dart'; // Import model ClassInfo

class classSubject {
  String subjectId;
  String subjectName;
  int credits;
  List<dynamic> classes;
  int count;

  classSubject({
    required this.subjectId,
    required this.subjectName,
    required this.credits,
    required this.classes,
    required this.count,
  });

  factory classSubject.fromJson(Map<String, dynamic> json) {
    List<dynamic> classListData = json['classes'];
    List<dynamic> classListInfo = [];
    for (var classData in classListData) {
      var classInfoData = classData['Class'];
      classListInfo.add({
        'id': classInfoData['id'],
        'className': classInfoData['className'],
        'teacherID': classInfoData['teacherID'],
      });
    }
    return classSubject(
      subjectId: json['subjectId'],
      subjectName: json['subjectName'],
      credits: json['credits'],
      classes: classListInfo,
      count: json['count'],
    );
  }
}
