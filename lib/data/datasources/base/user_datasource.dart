import '../../models/user_model.dart';

abstract interface class UserDataSource {
  Future<UserModel> getUser();
}
