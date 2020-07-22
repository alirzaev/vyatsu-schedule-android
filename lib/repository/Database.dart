import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

import '../utils/dto.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null)
    return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "db.sqlite");

    return await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE FavouriteGroups ("
          "id VARCHAR(8) PRIMARY KEY,"
          "name VARCHAR(20)"
          ")");
    });
  }

  Future<int> insert(Group group) async {
    final db = await database;

    int res = await db.insert('FavouriteGroups', group.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    return res;
  }

  Future<void> delete(Group group) async {
    final db = await database;

    await db.delete('FavouriteGroups', where: 'id = ?', whereArgs: [group.id]);
  }

  Future<List<Group>> all() async {
    final db = await database;

    var rows = await db.query('FavouriteGroups');

    return rows.isNotEmpty ? rows.map((row) => Group.fromJson(row)).toList() : [];
  }

  Future<bool> exist(Group group) async {
    final db = await database;

    var rows = await db.query('FavouriteGroups', where: 'id = ?', whereArgs: [group.id]);

    return rows.isNotEmpty;
  }
}