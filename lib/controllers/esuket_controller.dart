// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pecut/controllers/sso_controller.dart';
import 'package:pecut/models/esuket_user_model.dart';
import 'package:pecut/models/theme_color_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final dio = Dio();

class EsuketController extends ChangeNotifier {
  String get appName => 'e-SUKET';

  String _token = '';
  String get token => _token;

  bool get isAuth => token.isNotEmpty;

  bool _isLoadingLogin = false;
  bool get isLoadingLogin => _isLoadingLogin;

  bool _isLoadingUser = false;
  bool get isLoadingUser => _isLoadingUser;

  bool _isLoadingLogout = false;
  bool get isLoadingLogout => _isLoadingLogout;

  EsuketUserModel? _user;
  EsuketUserModel? get user => _user;

  EsuketController() {
    init();
  }

  void init() async {
    String? esuketToken = await getToken();
    if (esuketToken != null) {
      profile();

      _token = esuketToken;
      notifyListeners();
    }
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(dotenv.env['ESUKET_API_KEY']!);

    return token;
  }

  Future removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(dotenv.env['ESUKET_API_KEY']!);
  }

  Future<Map<String, dynamic>> loginWithSso() async {
    _isLoadingLogin = true;
    try {
      String? ssoToken = await SsoController().getToken();
      String url = '${dotenv.env['ESUKET_BASE_URL']}/api/auth/login_sso';
      Response response = await dio.get(
        url,
        queryParameters: {
          'sso_token': ssoToken,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      String esuketToken = response.data['token'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(dotenv.env['ESUKET_API_KEY']!, esuketToken);

      _token = esuketToken;
      _isLoadingLogin = false;
      notifyListeners();
      profile();

      return {
        'statusCode': response.statusCode,
        'message': 'Login successfully.',
        'token': esuketToken,
      };
    } on DioException catch (e) {
      _isLoadingLogin = false;
      notifyListeners();
      return {
        'statusCode': e.response == null ? 500 : e.response?.statusCode,
        'message': e.response == null ? e.message : e.response?.data,
      };
    }
  }

  Future profile() async {
    _isLoadingUser = true;
    try {
      String? esuketToken = await getToken();
      String url = '${dotenv.env['ESUKET_BASE_URL']}/api/auth/profile';
      Response response = await dio.get(
        url,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $esuketToken',
          },
        ),
      );
      // print('esuketUser: ${response.data.toString()}');
      _user = EsuketUserModel.fromJson(response.data);
      _isLoadingUser = false;
      notifyListeners();
    } on DioException catch (e) {
      _token = '';
      _isLoadingUser = false;
      notifyListeners();
      print(
        'esuketUserError: ${e.response != null ? e.response?.data.toString() : e.message}',
      );
    }
  }

  Future logout() async {
    _isLoadingLogout = true;
    try {
      String? esuketToken = await getToken();
      String url = '${dotenv.env['ESUKET_BASE_URL']}/api/auth/logout';
      await dio.post(url,
          data: {},
          options: Options(
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $esuketToken',
            },
          ));

      removeToken();
      _token = '';
      _isLoadingLogout = false;
      notifyListeners();
    } on DioException catch (e) {
      removeToken();
      _token = '';
      _isLoadingLogout = false;
      notifyListeners();
      print(
        'logoutFromEsuketError: ${e.response != null ? e.response?.data?.toString() : e.message}',
      );
    }
  }

  ThemeColorModel getThemeColor(String themeName) {
    if (themeName == 'black') {
      return ThemeColorModel(
        textColor: Colors.black,
        bgColor: Colors.black12,
      );
    } else if (themeName == 'green') {
      return ThemeColorModel(
        textColor: Colors.green[900]!,
        bgColor: Colors.green[50]!,
      );
    } else if (themeName == 'blue') {
      return ThemeColorModel(
        textColor: Colors.blue[900]!,
        bgColor: Colors.blue[50]!,
      );
    } else if (themeName == 'orange') {
      return ThemeColorModel(
        textColor: Colors.orange[900]!,
        bgColor: Colors.orange[50]!,
      );
    }

    return ThemeColorModel(
      textColor: Colors.black,
      bgColor: Colors.black12,
    );
  }
}
