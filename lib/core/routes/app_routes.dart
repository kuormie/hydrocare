import 'package:flutter/material.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/auth/login/login_screen.dart';
import '../../features/auth/register/register_screen.dart';
import '../../features/auth/verification/verification_screen.dart';
import '../../features/auth/forgot/forgot_screen.dart';
import '../../features/auth/congrats/congrats_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/scan/scan_screen.dart';
import '../../features/result/result_screen.dart';
import '../../features/history/history_screen.dart';
import '../../features/statistics/statistics_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/profile/edit_profile_screen.dart';
import '../../data/models/history_item.dart';

class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const verify = '/verify';
  static const forgot = '/forgot';
  static const congrats = '/congrats';
  static const dashboard = '/dashboard';
  static const scan = '/scan';
  static const result = '/result';
  static const history = '/history';
  static const statistics = '/statistics';
  static const profile = '/profile';
  static const editProfile = '/edit-profile';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _fade(const SplashScreen());
      case onboarding:
        return _fade(const OnboardingScreen());
      case login:
        return _slide(const LoginScreen());
      case register:
        return _slide(const RegisterScreen());
      case verify:
        return _slide(const VerificationScreen());
      case forgot:
        return _slide(const ForgotScreen());
      case congrats:
        return _fade(const CongratsScreen());
      case dashboard:
        return _fade(const DashboardScreen());
      case scan:
        return _slide(const ScanScreen());
      case result:
        final item = settings.arguments as HistoryItem?;
        return _slide(ResultScreen(item: item));
      case history:
        return _slide(const HistoryScreen());
      case statistics:
        return _slide(const StatisticsScreen());
      case profile:
        return _slide(const ProfileScreen());
      case editProfile:
        return _slide(const EditProfileScreen());
      default:
        return _fade(const SplashScreen());
    }
  }

  static PageRoute _fade(Widget page) => PageRouteBuilder(
        pageBuilder: (_, _, _) => page,
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 300),
      );

  static PageRoute _slide(Widget page) => PageRouteBuilder(
        pageBuilder: (_, _, _) => page,
        transitionsBuilder: (_, animation, _, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 300),
      );
}
