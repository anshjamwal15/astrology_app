import 'package:astrology_app/models/index.dart';
import 'package:astrology_app/services/DAOs/user_dao.dart';

class UserManager {
  User? _user;
  final UserDao _userDao = UserDao();

  UserManager._privateConstructor();

  static final UserManager _instance = UserManager._privateConstructor();

  static UserManager get instance => _instance;

  Future<void> loadUser() async {
    _user = await _userDao.getUser();
  }

  User? get user => _user;

  bool get isLoggedIn => _user != null;
}
