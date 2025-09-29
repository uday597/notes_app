import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DBhelper {
  static const dbname = 'notes.db';
  static const tablename = 'notes';
  static const dbversion = 1;
  static const idcolumn = 'id';
  static const titlecolumn = 'title';
  static const descolumn = 'description';
  static Database? _database;
  Future<Database?> get database async {
    _database ??= await initdb();
    return _database;
  }

  initdb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dbname);
    return await openDatabase(path, version: dbversion, onCreate: oncreate);
  }

  Future oncreate(Database db, int version) async {
    db.execute('''CREATE TABLE $tablename($idcolumn integer primary key autoincrement,$titlecolumn text,$descolumn text )''');
  }
}
