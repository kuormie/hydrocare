import '../base/history_datasource.dart';
import '../../models/history_item.dart';
import 'local_storage.dart';

class HistoryLocalDataSource implements HistoryDataSource {
  final LocalStorage _storage;

  HistoryLocalDataSource(this._storage);

  @override
  Future<List<HistoryItem>> getHistory() => _storage.getHistory();

  @override
  Future<void> addHistoryItem(HistoryItem item) =>
      _storage.addHistoryItem(item);

  @override
  Future<HistoryItem?> getHistoryItem(String id) =>
      _storage.getHistoryItem(id);
}
