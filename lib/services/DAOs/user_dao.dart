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

  Future<void> updateUserStatus({
    bool? isEmailVerified,
    bool? isProfileCompleted,
    String? name,
    String? mobile,
    String? country,
  }) async {
    final db = await _dbHelper.database;
    final updates = <String, dynamic>{};

    if (isEmailVerified != null) {
      updates['is_email_verified'] = isEmailVerified ? 1 : 0;
    }
    if (isProfileCompleted != null) {
      updates['is_profile_completed'] = isProfileCompleted ? 1 : 0;
    }
    if (name != null) {
      updates['name'] = name;
    }
    if (mobile != null) {
      updates['mobile'] = mobile;
    }
    if (country != null) {
      updates['country'] = country;
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
