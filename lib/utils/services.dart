//lib/service.dart
import "dart:convert";
import "package:flutter_doan/screens/changePassword.dart";
import "package:http/http.dart" as http;

class AppUtils {
  static const String baseApi = "http://localhost:8080/api/v1";

  static Future<Map<String, dynamic>> registerUser(String username,
      String phoneNumber, String address, String sex) async {
    final response = await http
        .post(Uri.parse("$baseApi/register"), headers: <String, String>{
      'ContentType': 'application/json'
    }, body: <String, String>{
      'username': username,
      'phone': phoneNumber,
      'address': address,
      'sex': sex,

    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Đăng ký thất bại!');
    }
  }

  static Future<Map<String, dynamic>> fetchUser() async {
    final response = await http.get(
      Uri.parse("$baseApi/user/read"),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Thất bại khi gọi API!');
    }
  }

  static Future<Map<String, dynamic>> getUserByID(String? userId) async {
    final response = await http
        .post(Uri.parse("$baseApi/user/getById"), headers: <String, String>{
      'ContentType': 'application/json',
    }, body: <String, String>{
      'userId': userId!,
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Tìm người thất bại');
    }
  }
  static Future<Map<String, dynamic>> getUserByPhone(String? phone) async {
    final response = await http
        .post(Uri.parse("$baseApi/user/getByPhone"), headers: <String, String>{
      'ContentType': 'application/json',
    }, body: <String, String>{
      'phone': phone!,
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Tìm người thất bại');
    }
  }
  static Future<Map<String, dynamic>> hanldeLogin(
      String valueLogin, String password) async {
    final response =
        await http.post(Uri.parse("$baseApi/login"), headers: <String, String>{
      'ContentType': 'application/json',
    }, body: <String, String>{
      'valueLogin': valueLogin,
      'password': password
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Đăng nhập thất bại');
    }
  }
  static Future<Map<String, dynamic>> changePassword(
      String userId, String password, String newpassword) async {
    final response =
        await http.put(Uri.parse("$baseApi/changePassword"), headers: <String, String>{
      'ContentType': 'application/json',
    }, body: <String, String>{
      'userId': userId,
      'password': password,
       'newpassword': newpassword
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Đổi mật khẩu thất bại');
    }
  }
  static Future<Map<String, dynamic>> handleLogout() async {
    final response = await http.post(Uri.parse("$baseApi/logout"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Lỗi đăng xuất!!!');
    }
  }

  static Future<Map<String, dynamic>> getListAllUser() async {
    final response = await http.get(Uri.parse("$baseApi/user/read"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Lấy dữ liệu thất bại!!");
    }
  }

  static Future<Map<String, dynamic>> HandleUpdate(String userId,
      String username, String phone,String address, String sex,String className, String role) async {
    final response = await http.put(
      Uri.parse("$baseApi/user/update"),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'userId': userId,
        'username': username,
          'phone': phone,
        'address': address,
        'sex': sex,
        'className': className,
        'role': role
      },
    );
    // print(response.body);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Cập nhật thất bại');
    }
  }

  static Future<Map<String, dynamic>> removeTeacher(
      int id, String userId) async {
    final response = await http.put(
      Uri.parse("$baseApi/user/removeTeacherOutOfClass"),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'id': id.toString(),
        'userId': userId,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Cập nhật thất bại');
    }
  }

  static Future<Map<String, dynamic>> getTablePoint(String userId) async {
    try {
      final responsePoint = await http.get(
        Uri.parse("$baseApi/point/read"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      final responseSubject = await http.get(
        Uri.parse("$baseApi/subject/read"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      if (responsePoint.statusCode == 200 &&
          responseSubject.statusCode == 200) {
        final List<dynamic> pointData = jsonDecode(responsePoint.body)['DT'];
        final List<dynamic> subjectData =
            jsonDecode(responseSubject.body)['DT'];

        final List<Map<String, dynamic>> userPoints = [];
        final Map<String, Map<String, dynamic>?> subjectMap =
            {}; // Use nullable maps

        // Populate subjectMap with subjectId as key and subject details as value
        subjectData.forEach((subject) {
          subjectMap[subject['subjectId']] = {
            'subjectName': subject['subjectName'],
            'credits': subject['credits'],
          };
        });

        // Iterate through pointData and match subjectId with subjectMap to add subject details to points
        pointData.forEach((point) {
          if (point['userId'] == userId) {
            final subjectId = point['subjectId'];
            // Check if subjectMap contains the subjectId and it is not null
            if (subjectMap.containsKey(subjectId) &&
                subjectMap[subjectId] != null) {
              // Include subjectName and credits from subjectMap
              point['subjectName'] = subjectMap[subjectId]!['subjectName'] ??
                  ''; // Use null-aware operator
              point['credits'] = subjectMap[subjectId]!['credits'] ??
                  ''; // Use null-aware operator
              userPoints.add(point);
            }
          }
        });

        return {'points': userPoints};
      } else {
        throw Exception('Thất bại khi gọi API!');
      }
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }

  static Future<Map<String, dynamic>> deleteUser(String userId) async {
    final response = await http
        .delete(Uri.parse("$baseApi/user/delete"), headers: <String, String>{
      'ContentType': 'application/json',
    }, body: <String, String>{
      'userId': userId,
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Tìm người thất bại');
    }
  }

  static Future<Map<String, dynamic>> updateTablePoint(
      String subjectName,
      String subjectId,
      String point_qt,
      String point_gk,
      String point_ck) async {
    final Map<String, dynamic> data = {
      'subjectId': subjectId,
      'subjectName': subjectName,
    };
    try {
      final responseSubject = await http
          .put(Uri.parse("$baseApi/subject/update"), headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded'
      }, body: {
        'subjectId': subjectId,
        'subjectName': subjectName,
      });
      final responsePoint = await http.put(
        Uri.parse("$baseApi/point/update"),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: {
          'subjectId': subjectId,
          'point_qt': point_qt,
          'point_gk': point_gk,
          'point_ck': point_ck
        },
      );

      if (responsePoint.statusCode == 200 &&
          responseSubject.statusCode == 200) {
        return {'EM': 'Cập nhật thành công dữ liệu', 'EC': 0};
      } else {
        throw Exception('Cập nhật thất bại');
      }
    } catch (error) {
      throw Exception('Lỗi khi gọi API: $error');
    }
  }

  static Future<Map<String, dynamic>> addTablePoint(
      String userId,
      String subjectId,
      String point_qt,
      String point_gk,
      String point_ck,
      String hocky) async {
    // final responseSubject = await http.post(
    //   Uri.parse("$baseApi/subject/create"),
    //   headers: <String, String>{
    //     'Content-Type': 'application/x-www-form-urlencoded',
    //   },
    //   body: {
    //     'subjectId': subjectId,
    //     'subjectName': subjectName,
    //     'userId': userId,
    //     'hocky': hocky,
    //   },
    // );
    final responsePoint = await http.post(
      Uri.parse("$baseApi/point/create"),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'userId': userId,
        'subjectId': subjectId,
        'point_qt': point_qt,
        'point_gk': point_gk,
        'point_ck': point_ck,
        'hocky': hocky,
      },
    );
    if (responsePoint.statusCode == 200) {
      return jsonDecode(responsePoint.body);
    } else {
      throw Exception('Thêm thất bại');
    }
  }

  static Future<Map<String, dynamic>> getClassList() async {
    final response = await http.get(Uri.parse("$baseApi/class/get"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gọi dữ liệu thất bại');
    }
  }

  static Future<Map<String, dynamic>> getClassInfo() async {
    final response = await http.get(Uri.parse("$baseApi/class/read"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gọi dữ liệu thất bại');
    }
  }

  static Future<Map<String, dynamic>> getClassByTeacherID(
      String teacherID) async {
    final response = await http.post(
      Uri.parse("$baseApi/class/getClassByTeacherID"),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'teacherID': teacherID},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gọi dữ liệu thất bại');
    }
  }

  static Future<Map<String, dynamic>> getSubjectList() async {
    final response = await http.get(
      Uri.parse("$baseApi/subject/read"),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gọi dữ liệu thất bại');
    }
  }

  static Future<Map<String, dynamic>> addSubject(
      String subjectId, String subjectName, String credits) async {
    final responsePoint = await http.post(
      Uri.parse("$baseApi/subject/create"),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'subjectId': subjectId,
        'subjectName': subjectName,
        'credits': credits
      },
    );
    if (responsePoint.statusCode == 200) {
      return jsonDecode(responsePoint.body);
    } else {
      throw Exception('Thêm thất bại');
    }
  }

  static Future<Map<String, dynamic>> addTeacherInClass(
      int classId, String userId) async {
    final responsePoint = await http.put(
      Uri.parse("$baseApi/class/addTeacher"),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'id': classId.toString(), 'teacherID': userId},
    );

    if (responsePoint.statusCode == 200) {
      return jsonDecode(responsePoint.body);
    } else {
      throw Exception('Thêm thất bại');
    }
  }

  static Future<Map<String, dynamic>> deleteSubject(String subjectId) async {
    final responseSubject = await http
        .delete(Uri.parse("$baseApi/subject/delete"), headers: <String, String>{
      'ContentType': 'application/json',
    }, body: <String, String>{
      'subjectId': subjectId,
    });
    final responsePoint = await http
        .delete(Uri.parse("$baseApi/point/delete"), headers: <String, String>{
      'ContentType': 'application/json',
    }, body: <String, String>{
      'subjectId': subjectId,
    });
    if (responseSubject.statusCode == 200 && responsePoint.statusCode == 200) {
      return jsonDecode(responseSubject.body);
    } else {
      throw Exception('Xóa môn học thất bại');
    }
  }

  static Future<Map<String, dynamic>> deleteTablePoint(
      String userId, String subjectId, String hocky) async {
    final response = await http
        .delete(Uri.parse("$baseApi/point/delete"), headers: <String, String>{
      'ContentType': 'application/json',
    }, body: <String, String>{
      'userId': userId,
      'subjectId': subjectId,
      'hocky': hocky,
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Xóa thất bại');
    }
  }

  static Future<Map<String, dynamic>> deleteClass(int id) async {
    final response = await http
        .delete(Uri.parse("$baseApi/class/delete"), headers: <String, String>{
      'ContentType': 'application/json',
    }, body: <String, String>{
      'id': id.toString(),
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Xóa thất bại');
    }
  }

  static Future<Map<String, dynamic>> updateSubject(
      String subjectId, String subjectName, String credits) async {
    final responseSubject = await http
        .put(Uri.parse("$baseApi/subject/update"), headers: <String, String>{
      'ContentType': 'application/json',
    }, body: <String, String>{
      'subjectId': subjectId,
      'subjectName': subjectName,
      'credits': credits
    });

    if (responseSubject.statusCode == 200) {
      return jsonDecode(responseSubject.body);
    } else {
      throw Exception('Cập nhật môn học thất bại');
    }
  }

  static Future<Map<String, dynamic>> updateClass(
      int classId, String subjectId) async {
    final responseSubject = await http
        .put(Uri.parse("$baseApi/class/update"), headers: <String, String>{
      'ContentType': 'application/json',
    }, body: <String, dynamic>{
      'id': classId,
      'subjectID': subjectId,
    });

    if (responseSubject.statusCode == 200) {
      return jsonDecode(responseSubject.body);
    } else {
      throw Exception('Cập nhật môn học cho lớp thất bại');
    }
  }

  static Future<Map<String, dynamic>> addClass(String className) async {
    final responsePoint = await http.post(
      Uri.parse("$baseApi/class/create"),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'className': className},
    );
    if (responsePoint.statusCode == 200) {
      return jsonDecode(responsePoint.body);
    } else {
      throw Exception('Thêm thất bại');
    }
  }

  static Future<Map<String, dynamic>> getUserNotInClass() async {
    final response = await http.get(
      Uri.parse("$baseApi/user/getUserNotInClass"),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Thất bại khi gọi API!');
    }
  }

  static Future<Map<String, dynamic>> getTeacherNotInClass() async {
    final response = await http.get(
      Uri.parse("$baseApi/user/getTeacherNotInClass"),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Thất bại khi gọi API!');
    }
  }

  static Future<Map<String, dynamic>> getLecturerList() async {
    final response = await http.get(
      Uri.parse("$baseApi/user/getLecturer"),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Thất bại khi gọi API!');
    }
  }

  static Future<Map<String, dynamic>> addMultipleUserToClass(
      List<String> userIds, int classId) async {
    final String jsonBody =
        jsonEncode({'listUserId': userIds, 'classId': classId});
    final response = await http.put(Uri.parse("$baseApi/user/updateMultiClass"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonBody);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Thất bại khi gọi API!');
    }
  }

  static Future<Map<String, dynamic>> moveMultipleUserFromClass(
      List<String> userIds) async {
    final String jsonBody = jsonEncode({'listUserId': userIds});
    final response =
        await http.put(Uri.parse("$baseApi/user/moveUserFromClass"),
            headers: <String, String>{
              'Content-Type': 'application/json',
            },
            body: jsonBody);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Thất bại khi gọi API!');
    }
  }

  static Future<Map<String, dynamic>> getListStudentApproved() async {
    final response =
        await http.get(Uri.parse("$baseApi/user/getStudentApprovedList"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Lấy dữ liệu thất bại!!");
    }
  }


  static Future<void> sendUserInformation(String phoneNumber, String userId, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseApi/user/sendUserInformation'),
        body: {
          'phone': phoneNumber,
          'userId': userId,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        print('Đã gửi thông tin thành công cho $phoneNumber');
      } else {
        throw Exception('Gửi thông tin thất bại: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Lỗi khi gửi thông tin: $e');
      throw Exception('Lỗi khi gửi thông tin: $e');
    }
  }

}
