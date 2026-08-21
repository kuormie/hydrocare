import '../../models/hydration_stats.dart';

abstract interface class StatsDataSource {
  Future<HydrationStats> getStats();
}
