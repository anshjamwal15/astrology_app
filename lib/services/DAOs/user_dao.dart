import 'package:astrology_app/services/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:astrology_app/models/user.dart';

class UserDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> insertUser(User user) async {
    final db = await _dbHelper.database;
    await db.insert(
      'user',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<User?> getUser() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('user');
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<void> deleteUser() async {
    final db = await _dbHelper.database;
    await db.delete('user');
  }
}
