import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_strings.dart';
import '../../models/history_item.dart';
import '../../models/user_model.dart';
import '../../models/hydration_stats.dart';

class LocalStorage {
  final SharedPreferences _prefs;

  LocalStorage(this._prefs);

  // Seed data JSON aset ke shared_preferences pada first-run
  Future<void> seedIfNeeded() async {
    if (_prefs.getBool(AppStrings.keySeeded) == true) return;

    final historyJson = await rootBundle.loadString('assets/data/history.json');
    await _prefs.setString(AppStrings.keyHistory, historyJson);

    final userJson = await rootBundle.loadString('assets/data/user_profile.json');
    await _prefs.setString(AppStrings.keyUser, userJson);

    await _prefs.setBool(AppStrings.keySeeded, true);
  }

  // History
  Future<List<HistoryItem>> getHistory() async {
    final raw = _prefs.getString(AppStrings.keyHistory) ?? '[]';
    final list = jsonDecode(raw) as List;
    return list
        .map((e) => HistoryItem.fromJson(e as Map<String, dynamic>))
        .toList()
        .reversed
        .toList(); // Terbaru di atas
  }

  Future<void> addHistoryItem(HistoryItem item) async {
    final current = await getHistory();
    // Insert di depan (paling baru)
    final updated = [item, ...current.reversed];
    await _prefs.setString(
        AppStrings.keyHistory, jsonEncode(updated.map((e) => e.toJson()).toList()));
  }

  Future<HistoryItem?> getHistoryItem(String id) async {
    final all = await getHistory();
    try {
      return all.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  // User
  Future<UserModel> getUser() async {
    final raw = _prefs.getString(AppStrings.keyUser);
    if (raw == null) {
      final json = await rootBundle.loadString('assets/data/user_profile.json');
      return UserModel.fromJson(jsonDecode(json) as Map<String, dynamic>);
    }
    return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  // Stats — computed dari history + seed file
  Future<HydrationStats> getStats() async {
    final statsJson = await rootBundle.loadString('assets/data/stats.json');
    return HydrationStats.fromJson(
        jsonDecode(statsJson) as Map<String, dynamic>);
  }
}
