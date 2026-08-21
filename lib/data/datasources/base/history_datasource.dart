import '../../models/history_item.dart';

abstract interface class HistoryDataSource {
  Future<List<HistoryItem>> getHistory();
  Future<void> addHistoryItem(HistoryItem item);
  Future<HistoryItem?> getHistoryItem(String id);
}
