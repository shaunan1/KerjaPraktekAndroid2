// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pecut/controllers/esuket_controller.dart';
import 'package:pecut/models/sso_user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final dio = Dio();

class SsoController extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _isLoadingLogin = false;
  bool get isLoadingLogin => _isLoadingLogin;

  bool _isAuth = false;
  bool get isAuth => _isAuth;

  String _token = '';
  String get token => _token;

  SsoUserModel _user = SsoUserModel();
  SsoUserModel get user => _user;

  SsoController() {
    init();
  }

  void init() async {
    _isLoading = true;
    String? token = await getToken();

    if (token != null) {
      _isAuth = true;
      _token = token;
      SsoUserModel? getUser = await profile();
      _user = getUser!;
    } else {
      _isAuth = false;
      _token = '';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(dotenv.env['SSO_API_KEY']!);

    return token;
  }

  Future login(String email, String password) async {
    _isLoadingLogin = true;
    try {
      String url = '${dotenv.env['SSO_BASE_URL']!}/api/auth/login';
      Response response = await dio.post(url,
          data: {
            'email': email,
            'password': password,
          },
          options: Options(
            headers: {
              'Accept': 'application/json',
            },
          ));

      _isAuth = true;
      String token = response.data['token'].toString();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(dotenv.env['SSO_API_KEY']!, token);

      _isLoadingLogin = false;
      notifyListeners();

      init();

      return response.data;
    } on DioException catch (e) {
      _isLoadingLogin = false;
      notifyListeners();

      if (e.response != null) {
        return e.response?.data;
      } else {
        return e.message;
      }
    }
  }

  Future removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(dotenv.env['SSO_API_KEY']!);
  }

  Future logout() async {
    try {
      String url = '${dotenv.env['SSO_BASE_URL']!}/api/logmeout';
      Response response = await dio.get(url,
          options: Options(
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ));
      _isAuth = false;
      removeToken();
      _token = '';
      notifyListeners();

      await EsuketController().logout();

      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response?.data;
      } else {
        return e.message;
      }
    }
  }

  Future<SsoUserModel?> profile() async {
    try {
      String url = '${dotenv.env['SSO_BASE_URL']!}/api/auth/profile';
      Response response = await dio.get(
        url,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      _isAuth = true;
      return SsoUserModel.fromJson(response.data);
    } on DioException catch (e) {
      print('getSsoProfileError: ${e.response.toString()}');
      removeToken();
      _isAuth = false;
      notifyListeners();
      return null;
      // throw Exception('Failed to load profile!');
    }
  }
}
