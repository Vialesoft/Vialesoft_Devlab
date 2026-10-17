import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqlite_async/sqlite_async.dart';

class AppDatabase {
  AppDatabase._(this.connection);

  static const _fileName = 'carbmate.sqlite';
  static final _migrations = SqliteMigrations();

  final SqliteDatabase connection;

  static Future<AppDatabase> open() async {
    final directory = await getApplicationSupportDirectory();
    final path = '${directory.path}${Platform.pathSeparator}$_fileName';
    final connection = SqliteDatabase(path: path);

    await connection.initialize();
    await _migrations.migrate(connection);

    return AppDatabase._(connection);
  }

  Future<void> close() => connection.close();
}
