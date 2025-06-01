import 'package:astrology_app/services/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:astrology_app/models/user.dart';

class UserDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> insertUser(User user) async {
    final db = await _dbHelper.database;
    await db.insert(
      'user',
      user.toLocalDb(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await getUser();
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

  Future<void> updateProfileCompleted(bool isCompleted) async {
    final db = await _dbHelper.database;
    await db.rawUpdate(
      '''
    UPDATE user
    SET is_profile_completed = ?
    WHERE id = (
      SELECT id FROM user LIMIT 1
    )
    ''',
      [isCompleted ? 1 : 0],
    );
  }

  Future<void> updateEmailVerified(bool isVerified) async {
    final db = await _dbHelper.database;
    await db.rawUpdate(
      '''
    UPDATE user
    SET is_email_verified = ?
    WHERE id = (
      SELECT id FROM user LIMIT 1
    )
    ''',
      [isVerified ? 1 : 0],
    );
  }

  Future<void> updateUserStatus(
      {bool? isEmailVerified, bool? isProfileCompleted}) async {
    final db = await _dbHelper.database;
    final updates = <String, dynamic>{};

    if (isEmailVerified != null) {
      updates['is_email_verified'] = isEmailVerified ? 1 : 0;
    }
    if (isProfileCompleted != null) {
      updates['is_profile_completed'] = isProfileCompleted ? 1 : 0;
    }

    if (updates.isNotEmpty) {
      await db.update(
        'user',
        updates,
        where: 'id = (SELECT id FROM user LIMIT 1)',
      );
    }
  }
}
