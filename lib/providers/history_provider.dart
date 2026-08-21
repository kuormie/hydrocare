import 'package:flutter/material.dart';
import '../data/models/history_item.dart';
import '../data/repositories/history_repository.dart';

class HistoryProvider extends ChangeNotifier {
  final HistoryRepository _repository;

  HistoryProvider(this._repository);

  List<HistoryItem> _items = [];
  bool _loading = false;

  List<HistoryItem> get items => _items;
  bool get loading => _loading;
  List<HistoryItem> get recentItems => _items.take(3).toList();

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    _items = await _repository.getHistory();
    _loading = false;
    notifyListeners();
  }

  Future<void> addItem(HistoryItem item) async {
    await _repository.addHistoryItem(item);
    await load();
  }
}
