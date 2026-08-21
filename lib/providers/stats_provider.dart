import 'package:flutter/material.dart';
import '../data/models/hydration_stats.dart';
import '../data/repositories/stats_repository.dart';

class StatsProvider extends ChangeNotifier {
  final StatsRepository _repository;

  StatsProvider(this._repository);

  HydrationStats? _stats;
  bool _loading = false;

  HydrationStats? get stats => _stats;
  bool get loading => _loading;

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    _stats = await _repository.getStats();
    _loading = false;
    notifyListeners();
  }
}
