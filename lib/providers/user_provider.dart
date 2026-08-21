import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/user_model.dart';
import '../data/repositories/user_repository.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository _repository;

  UserProvider(this._repository);

  UserModel? _user;

  UserModel? get user => _user;

  Future<void> load() async {
    _user = await _repository.getUser();
    if (_user == null) return;
    final prefs = await SharedPreferences.getInstance();
    _user = _user!.copyWith(
      name: prefs.getString('pref_user_name'),
      email: prefs.getString('pref_user_email'),
      profileImagePath: prefs.getString('pref_profile_photo'),
      tanggalLahir: prefs.getString('pref_tgl_lahir'),
      jenisKelamin: prefs.getString('pref_jenis_kelamin'),
    );
    notifyListeners();
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? tanggalLahir,
    String? jenisKelamin,
  }) async {
    if (_user == null) return;
    final prefs = await SharedPreferences.getInstance();
    if (name != null) await prefs.setString('pref_user_name', name);
    if (email != null) await prefs.setString('pref_user_email', email);
    if (tanggalLahir != null) await prefs.setString('pref_tgl_lahir', tanggalLahir);
    if (jenisKelamin != null) await prefs.setString('pref_jenis_kelamin', jenisKelamin);
    _user = _user!.copyWith(
      name: name,
      email: email,
      tanggalLahir: tanggalLahir,
      jenisKelamin: jenisKelamin,
    );
    notifyListeners();
  }

  Future<void> updatePhoto(String path) async {
    if (_user == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pref_profile_photo', path);
    _user = _user!.copyWith(profileImagePath: path);
    notifyListeners();
  }

  Future<void> removePhoto() async {
    if (_user == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('pref_profile_photo');
    _user = _user!.copyWith(clearProfileImage: true);
    notifyListeners();
  }
}
