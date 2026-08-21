class ApiConfig {
  ApiConfig._();

  static const String baseUrl = "http://192.168.1.10/hydrocare-backend";

  // Auth
  static const String login = "/auth/login.php";
  static const String register = "/auth/register.php";

  // Profile
  static const String saveProfile = "/profile/save_profile.php";
  static const String getProfile = "/profile/get_profile.php";

  // Detection
  static const String uploadImage = "/detection/upload_image.php";
  static const String saveResult = "/detection/save_result.php";

  // History
  static const String history = "/history/get_history.php";
}