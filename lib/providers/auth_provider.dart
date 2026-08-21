import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/config/api_config.dart';
import '../core/network/api_client.dart';

class AuthProvider extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<bool> login(String email, String password) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConfig.login,
        data: {
          "email": email,
          "password": password,
        },
      );

      print(response.data);

      if (response.data["success"] == true) {
        final prefs = await SharedPreferences.getInstance();

        await prefs.setInt(
          "id_user",
          response.data["data"]["id_user"],
        );

        await prefs.setBool(
          "profile_complete",
          response.data["data"]["profile_complete"],
        );

        _isLoggedIn = true;
        notifyListeners();

        return true;
      }

      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> register(
    String name,
    String email,
    String password,
) async {

  try {

    final response = await _apiClient.dio.post(
      ApiConfig.register,
      data: {
        "email": email,
        "password": password,
      },
    );

    return response.data["success"];

  } catch (e) {

    print(e);

    return false;

  }

}

// TAMBAHKAN KODE INI
Future<bool> verify(String code) async {

  await Future.delayed(const Duration(milliseconds: 500));

  _isLoggedIn = true;

  notifyListeners();

  return true;

}

void logout() {
  _isLoggedIn = false;
  notifyListeners();
}
}