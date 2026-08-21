import '../base/stats_datasource.dart';
import '../../models/hydration_stats.dart';
import 'local_storage.dart';

class StatsLocalDataSource implements StatsDataSource {
  final LocalStorage _storage;

  StatsLocalDataSource(this._storage);

  @override
  Future<HydrationStats> getStats() => _storage.getStats();
}
