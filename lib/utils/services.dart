//lib/service.dart
import "dart:convert";
import "package:http/http.dart" as http;

class AppUtils {
  static const String baseApi = "http://192.168.238.1:8080/api/v1";

  static Future<Map<String, dynamic>> registerUser(
      String username, String phoneNumber, String password, String role) async {
    final response = await http
        .post(Uri.parse("$baseApi/register"), headers: <String, String>{
      'ContentType': 'application/json'
    }, body: <String, String>{
      'userId': username,
      'username': username,
      'phone': phoneNumber,
      'password': password,
      'role': role
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
      print("response['DT']");
      print(response.body);
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
      String username, String address, String sex, String className) async {
    final response = await http.put(
      Uri.parse("$baseApi/user/update"),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'userId': userId,
        'username': username,
        'address': address,
        'sex': sex,
        'className': className,
      },
    );
    // print(response.body);
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
        final pointData = jsonDecode(responsePoint.body)['DT'];
        final subjectData = jsonDecode(responseSubject.body)['DT'];

        final userPoints =
            pointData.where((point) => point['userId'] == userId).toList();

        final subjectMap = Map.fromIterable(
          subjectData,
          key: (subject) => subject['subjectId'],
          value: (subject) => subject['subjectName'],
        );

        for (var point in userPoints) {
          final subjectId = point['subjectId'];
          point['subjectName'] = subjectMap[subjectId];
        }

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
      String subjectName, String subjectId, String point) async {
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
        body: {'subjectId': subjectId, 'point': point},
      );

      if (responsePoint.statusCode == 200 &&
          responseSubject.statusCode == 200) {
        print(responsePoint.body);
        print(responseSubject.body);

        return {'EM': 'Cập nhật thành công dữ liệu', 'EC': 0};
      } else {
        throw Exception('Cập nhật thất bại');
      }
    } catch (error) {
      throw Exception('Lỗi khi gọi API: $error');
    }
  }

  static Future<Map<String, dynamic>> addTablePoint(
      String userId, String subjectId, String point, String hocky) async {
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
        'point': point,
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

  static Future<Map<String, dynamic>> getSubjectList() async {
    final response = await http.get(Uri.parse("$baseApi/subject/read"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gọi dữ liệu thất bại');
    }
  }

  static Future<Map<String, dynamic>> addSubject(
      String subjectId, String subjectName) async {
    final responsePoint = await http.post(
      Uri.parse("$baseApi/subject/create"),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'subjectId': subjectId, 'subjectName': subjectName},
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
      String subjectId, String subjectName) async {
    final responseSubject = await http
        .put(Uri.parse("$baseApi/subject/update"), headers: <String, String>{
      'ContentType': 'application/json',
    }, body: <String, String>{
      'subjectId': subjectId,
      'subjectName': subjectName,
    });

    if (responseSubject.statusCode == 200) {
      return jsonDecode(responseSubject.body);
    } else {
      throw Exception('Cập nhật môn học thất bại');
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
}
