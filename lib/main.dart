import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'data/datasources/local/local_storage.dart';
import 'data/datasources/local/history_local_datasource.dart';
import 'data/datasources/local/user_local_datasource.dart';
import 'data/datasources/local/stats_local_datasource.dart';
import 'data/datasources/local/scan_local_datasource.dart';
import 'data/repositories/history_repository.dart';
import 'data/repositories/user_repository.dart';
import 'data/repositories/stats_repository.dart';
import 'data/repositories/scan_repository.dart';
import 'providers/auth_provider.dart';
import 'providers/history_provider.dart';
import 'providers/stats_provider.dart';
import 'providers/user_provider.dart';
import 'providers/scan_provider.dart';
import 'providers/nav_provider.dart';
import 'services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final localStorage = LocalStorage(prefs);
  await localStorage.seedIfNeeded();

  final historyDs = HistoryLocalDataSource(localStorage);
  final userDs = UserLocalDataSource(localStorage);
  final statsDs = StatsLocalDataSource(localStorage);
  final apiService = ApiService();
  final scanDs = ScanLocalDataSource(apiService);

  final historyRepo = HistoryRepository(historyDs);
  final userRepo = UserRepository(userDs);
  final statsRepo = StatsRepository(statsDs);
  final scanRepo = ScanRepository(scanDs);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NavProvider()),
        ChangeNotifierProvider(
            create: (_) => HistoryProvider(historyRepo)..load()),
        ChangeNotifierProvider(
            create: (_) => StatsProvider(statsRepo)..load()),
        ChangeNotifierProvider(create: (_) => UserProvider(userRepo)..load()),
        ChangeNotifierProvider(create: (_) => ScanProvider(scanRepo)),
      ],
      child: const HydroCareApp(),
    ),
  );
}
