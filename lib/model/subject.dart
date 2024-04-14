class subjectInfo {
  String subjectId;
  String subjectName;
  subjectInfo({required this.subjectId, required this.subjectName});
  factory subjectInfo.fromJson(Map<String, dynamic> json) {
    return subjectInfo(
        subjectId: json['subjectId'], subjectName: json['subjectName']);
  }
}
