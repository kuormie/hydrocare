// STUB — diaktifkan saat AppConfig.useRemote = true
// ignore_for_file: unused_import
import '../base/history_datasource.dart';
import '../../models/history_item.dart';

class HistoryRemoteDataSource implements HistoryDataSource {
  // final ApiClient _client;
  // HistoryRemoteDataSource(this._client);

  @override
  Future<List<HistoryItem>> getHistory() async {
    // TODO: GET /history
    throw UnimplementedError('Backend not yet integrated');
  }

  @override
  Future<void> addHistoryItem(HistoryItem item) async {
    // TODO: POST /scan/save
    throw UnimplementedError('Backend not yet integrated');
  }

  @override
  Future<HistoryItem?> getHistoryItem(String id) async {
    // TODO: GET /history/{id}
    throw UnimplementedError('Backend not yet integrated');
  }
}
