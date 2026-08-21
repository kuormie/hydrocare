import '../base/user_datasource.dart';
import '../../models/user_model.dart';
import 'local_storage.dart';

class UserLocalDataSource implements UserDataSource {
  final LocalStorage _storage;

  UserLocalDataSource(this._storage);

  @override
  Future<UserModel> getUser() => _storage.getUser();
}
