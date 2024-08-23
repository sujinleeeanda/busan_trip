import 'dart:convert';
import '../vo/user.dart';
import 'package:http/http.dart' as http;

class UserHttp {
  static const String apiUrl = 'http://13.125.57.206:8080/my_busan_log/api/user';


  // 회원가입
  static Future<User> registerUser(User user) async {
    print('1234');
    print({
      'u_email': user.u_email.toString(),
      'u_pw': user.u_pw.toString(),
      'u_name': user.u_name.toString(),
      'u_img_url': user.u_img_url.toString(),
      'u_nick': user.u_nick.toString(),
      'u_birth': user.u_birth.toString(),
      'u_p_number': user.u_p_number.toString(),
      'u_address': user.u_address.toString(),
      'trip_preference': user.trip_preference.toString(),
      'business_license': ''.toString(),
    });

    var uri = Uri.parse('$apiUrl/save').replace(queryParameters: {
      'login_provider': user.login_provider.toString(),
      'u_email': user.u_email.toString(),
      'u_pw': user.u_pw.toString(),
      'u_name': user.u_name.toString(),
      'u_img_url': user.u_img_url.toString(),
      'u_nick': user.u_nick.toString(),
      'u_birth': user.u_birth.toString(),
      'u_p_number': user.u_p_number.toString(),
      'u_address': user.u_address.toString(),
      'trip_preference': user.trip_preference.toString(),
      'business_license': ''.toString(),
    });
    var response = await http.post(uri);

    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      return User();
    }

  }

  // 로그인
  static Future<User> loginUser(User user) async {
    print('1234');

    var uri = Uri.parse('$apiUrl/login').replace(queryParameters: {
      'u_email': user.u_email.toString(),
      'u_pw': user.u_pw.toString(),
    });
    var response = await http.post(uri);

    print('9876=====================================================');

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      return User.fromJson(jsonDecode(response.body)); // JSON을 User 객체로 변환
    } else {
      return User();
    }
  }

  // kakao 회원가입
  static Future<User> kakaoRegisterUser({required User user}) async {
    print('1234');
    print({
      'u_email': user.u_email.toString(),
      'u_pw': '1234'.toString(),
      'u_name': user.u_name.toString(),
      'u_img_url': user.u_img_url.toString(),
      'u_nick': user.u_nick.toString(),
      'u_birth': user.u_birth.toString(),
      'u_p_number': user.u_p_number.toString(),
      'u_address': ''.toString(),
      'trip_preference': '3'.toString(),
      'business_license': ''.toString(),
      'login_provider': 'kakao'.toString(),
    });

    var uri = Uri.parse('$apiUrl/save').replace(queryParameters: {
      'u_email': user.u_email.toString(),
      'u_pw': '1234'.toString(),
      'u_name': user.u_name.toString(),
      'u_img_url': user.u_img_url.toString(),
      'u_nick': user.u_nick.toString(),
      'u_birth': user.u_birth.toString(),
      'u_p_number': user.u_p_number.toString(),
      'u_address': ''.toString(),
      'trip_preference': '3'.toString(),
      'business_license': ''.toString(),
      'login_provider': 'kakao'.toString(),
    });
    var response = await http.post(uri);

    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      return User();
    }

  }

  // kakao 로그인
  static Future<User> kakaoLoginUser(User user) async {
    print('1234');

    print({
      "sns_id": user.u_email.toString(),
      "login_provider": user.login_provider.toString(),
    });
    var uri = Uri.parse('$apiUrl/loginWithSNS').replace(queryParameters: {
      "sns_id": user.u_email.toString(),
      "login_provider": user.login_provider.toString(),
    });
    var response = await http.post(uri);

    print('9876=====================================================');

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      return User();
    }
  }
}