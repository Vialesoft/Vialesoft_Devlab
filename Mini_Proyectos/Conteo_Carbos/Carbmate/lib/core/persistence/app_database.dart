import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite_async/sqlite_async.dart';

class AppDatabase {
  AppDatabase._(this.connection);

  static const _fileName = 'carbmate.sqlite';
  static final _migrations = SqliteMigrations()
    ..add(
      SqliteMigration(1, (transaction) async {
        final schema = await rootBundle.loadString(
          'assets/database/migrations/initial_db.sql',
        );
        final initialData = await rootBundle.loadString(
          'assets/database/migrations/datos_iniciales.sql',
        );

        await transaction.executeMultiple(schema);
        await transaction.executeMultiple(initialData);
      }),
    );

  final SqliteDatabase connection;

  static Future<AppDatabase> open() async {
    final directory = await getApplicationSupportDirectory();
    final path = '${directory.path}${Platform.pathSeparator}$_fileName';
    final connection = SqliteDatabase(path: path);

    await connection.initialize();
    await connection.withAllConnections((writer, readers) async {
      await _enableForeignKeys(writer);
      for (final reader in readers) {
        await _enableForeignKeys(reader);
      }
    });
    await _migrations.migrate(connection);

    return AppDatabase._(connection);
  }

  Future<void> close() => connection.close();
}

Future<void> _enableForeignKeys(SqliteReadContext connection) async {
  await connection.computeWithDatabase((database) async {
    database.execute('PRAGMA foreign_keys = ON');
  });
}
