import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as https;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:school_bot/models/http_exception.dart';

class ChildData {
  String studentId;
  String studentCode;
  String name;
  String birthday;
  String gender;
  String religion;
  String cast;
  String bloodGroup;
  String address;
  String phone;
  String email;
  String password;
  String dormitoryRoomNumber;
  String authenticationKey;
  String aadharNumber;
  String admissionNumber;
  String classId;
  String sectionId;
  String imageUrl;

  ChildData({
    this.aadharNumber,
    this.address,
    this.admissionNumber,
    this.birthday,
    this.authenticationKey,
    this.bloodGroup,
    this.cast,
    this.classId,
    this.dormitoryRoomNumber,
    this.email,
    this.gender,
    this.imageUrl,
    this.name,
    this.password,
    this.phone,
    this.religion,
    this.sectionId,
    this.studentCode,
    this.studentId,
  });
}

class Auth with ChangeNotifier {
  List<ChildData> _childrenData = [];
  String _authenticationKey;
  String _loginType;
  String _loginUserId;
  String _username;
  String _loginusername;
  String _password;
  var birthday;
  String titleCase(String text) {
    if (text == null) return null;
    if (text.length <= 1) return text.toUpperCase();
    var words = text.split(' ');
    var capitalized = words.map((word) {
      var first = word.substring(0, 1).toUpperCase();
      var rest = word.substring(1);
      return '$first$rest';
    });
    return capitalized.join(' ');
  }

  List<ChildData> get childrenData {
    return [..._childrenData];
  }

  bool get isAuth {
    return authenticationKey != null;
  }

  String get authenticationKey {
    if (_authenticationKey != null) {
      return _authenticationKey;
    }
    return null;
  }

  String get userName {
    return titleCase(_username);
  }

  String get loginType {
    return titleCase(_loginType);
  }

  String get loginUserId {
    return (_loginUserId);
  }

  String get loginusername {
    return (_loginusername);
  }

  String get password {
    return (_password);
  }

  Map<String, String> attendanceStatus = {
    "0": "attendance was not taken",
    "1": "student was present",
    "2": "student was absent",
    "3": "it was a holiday",
    "4": "it was Sunday",
  };
  Future<void> login(String username, String password) async {
    final url =
        'http://139.59.30.20/bnsb/index.php/mobile/login?authenticate=false&email=$username&password=$password';
    try {
      final response = await https.get(url);
      final responseData = json.decode(response.body);

      _authenticationKey = responseData['authentication_key'];
      _loginType = responseData['login_type'];
      _loginUserId = responseData['login_user_id'];
      _username = responseData['name'];
      _loginusername = username;
      _password = password;
      List _responseChildren = responseData['children'];
      _childrenData.clear();
      _responseChildren.forEach((child) {
        var _child = ChildData(
          aadharNumber: child["aadhar_number"],
          address: child["address"],
          admissionNumber: child["admission_number"],
          authenticationKey: child["authentication_key"],
          birthday: child["birthday"],
          bloodGroup: child["blood_group"],
          cast: child["cast"],
          classId: child["class_id"],
          dormitoryRoomNumber: child["dormitory_room_number"],
          email: child["email"],
          gender: child["sex"],
          imageUrl: child["image_url"],
          name: child["name"],
          password: child["password"],
          phone: child["phone"],
          religion: child["religion"],
          sectionId: child["section_id"],
          studentCode: child["student_code"],
          studentId: child["student_id"],
        );
        _childrenData.add(_child);
      });

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'authenticationKey': _authenticationKey,
          'loginType': _loginType,
          'loginUserId': _loginUserId,
          'username': _username,
          'loginusername': _loginusername,
          'password': _password
        },
      );
      prefs.setString('userData', userData);
      notifyListeners();
    } on SocketException catch (error) {
      if (error.toString().contains("Connection failed")) {
        throw HttpException("Check Internet Connectivity");
      }
      if (error.toString().contains("Connection refused")) {
        throw HttpException("Please try again later");
      }
    } on FormatException catch (error) {
      throw HttpException("Incorrect Username or Password");
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchChildrenData() async {
    final url =
        'http://139.59.30.20/bnsb/index.php/mobile/login?authenticate=false&email=$_loginusername&password=$_password';
    try {
      final response = await https.get(url);
      final responseData = json.decode(response.body);
      List _responseChildren = responseData['children'];
      _childrenData.clear();
      _responseChildren.forEach((child) {
        var _child = ChildData(
          aadharNumber: child["aadhar_number"],
          address: child["address"],
          admissionNumber: child["admission_number"],
          authenticationKey: child["authentication_key"],
          birthday: child["birthday"],
          bloodGroup: child["blood_group"],
          cast: child["cast"],
          classId: child["class_id"],
          dormitoryRoomNumber: child["dormitory_room_number"],
          email: child["email"],
          gender: child["sex"],
          imageUrl: child["image_url"],
          name: child["name"],
          password: child["password"],
          phone: child["phone"],
          religion: child["religion"],
          sectionId: child["section_id"],
          studentCode: child["student_code"],
          studentId: child["student_id"],
        );
        _childrenData.add(_child);
      });

      notifyListeners();
    } on SocketException catch (error) {
      if (error.toString().contains("Connection failed")) {
        throw HttpException("Check Internet Connectivity");
      }
      if (error.toString().contains("Connection refused")) {
        throw HttpException("Please try again later");
      }
    } on FormatException catch (error) {
      throw HttpException("Incorrect Username or Password");
    } catch (error) {
      throw error;
    }
  }

  Future<String> checkAttendance(
      int date, int month, int year, int studentid) async {
    final url =
        "http://139.59.30.20/bnsb/index.php/mobile/get_child_attendance?authenticate=$_authenticationKey&user_type=$_loginType&student_id=$studentid&date=$date&month=$month&year=$year";
    try {
      final response = await https.get(url);
      print("response $response");
      final responseData = json.decode(response.body);
      print("responseData $responseData");
      String status = responseData['status'];
      status = attendanceStatus["$status"];
      return status;
    } on SocketException catch (error) {
      if (error.toString().contains("Connection failed")) {
        throw HttpException("Check Internet Connectivity");
      }
      if (error.toString().contains("Connection refused")) {
        throw HttpException("Please try again later");
      }
    } catch (error) {
      print("error $error");
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;

    _authenticationKey = extractedUserData['authenticationKey'];
    _loginType = extractedUserData['loginType'];
    _loginUserId = extractedUserData['loginUserId'];
    _username = extractedUserData['username'];
    _loginusername = extractedUserData['loginusername'];
    _password = extractedUserData['password'];

    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    // String deviceToken = await _firebaseMessaging.getToken();
    // await _deletedeviceToken(deviceToken);
    _authenticationKey = null;
    _loginType = null;
    _loginUserId = null;
    _username = null;
    _childrenData = null;
    _password = null;
    _loginusername = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('token');
    prefs.clear();
  }
}
