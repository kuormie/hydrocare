import '../datasources/base/history_datasource.dart';
import '../models/history_item.dart';

class HistoryRepository {
  final HistoryDataSource _datasource;

  HistoryRepository(this._datasource);

  Future<List<HistoryItem>> getHistory() => _datasource.getHistory();

  Future<void> addHistoryItem(HistoryItem item) =>
      _datasource.addHistoryItem(item);

  Future<HistoryItem?> getHistoryItem(String id) =>
      _datasource.getHistoryItem(id);
}
