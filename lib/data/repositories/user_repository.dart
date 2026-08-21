import '../datasources/base/user_datasource.dart';
import '../models/user_model.dart';

class UserRepository {
  final UserDataSource _datasource;

  UserRepository(this._datasource);

  Future<UserModel> getUser() => _datasource.getUser();
}
