import '../datasources/base/stats_datasource.dart';
import '../models/hydration_stats.dart';

class StatsRepository {
  final StatsDataSource _datasource;

  StatsRepository(this._datasource);

  Future<HydrationStats> getStats() => _datasource.getStats();
}
