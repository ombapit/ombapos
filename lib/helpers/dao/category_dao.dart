import 'package:ombapos/models/category_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ombapos/helpers/database_helper.dart';

class CategoryDao {
  Future<int> insert(Category category) async {
    final db = await DatabaseHelper().database;
    return await db.insert('categories', category.toMap());
  }

  Future<List<Category>> getAll() async {
    final db = await DatabaseHelper().database;
    final maps = await db.query('categories', orderBy: 'id ASC');
    return maps.map((map) => Category.fromMap(map)).toList();
  }

  Future<int> update(Category category) async {
    final db = await DatabaseHelper().database;
    return await db.update(
      'categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await DatabaseHelper().database;
    return await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }
}
