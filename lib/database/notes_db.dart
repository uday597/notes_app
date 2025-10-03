import 'package:notes/database/database.dart';

class NotesDB {
  static const tablename = 'notes';
  static const idcolumn = 'id';
  static const descolumn = 'description';

  Future<int> adddata(String data) async {
    final db = await DBhelper.instanse.database;
    return await db!.insert(tablename, {descolumn: data});
  }

  Future<int> updateData(int id, String data) async {
    final db = await DBhelper.instanse.database;
    return await db!.update(
      tablename,
      {descolumn: data},
      where: '$idcolumn=?',
      whereArgs: [id],
    );
  }

  Future<int> deleteData(int id) async {
    final db = await DBhelper.instanse.database;
    return await db!.delete(tablename, where: '$idcolumn = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getdata() async {
    final db = await DBhelper.instanse.database;
    return await db!.query(tablename);
  }
}
