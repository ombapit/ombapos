import 'package:ombapos/helpers/database_helper.dart';
import 'package:ombapos/models/item_model.dart';

class ItemDao {
  final _dbHelper = DatabaseHelper();

  Future<int> insertItem(Item item) async {
    final db = await _dbHelper.database;
    return await db.insert('items', item.toMap());
  }

  Future<List<Item>> getAllItems() async {
    final db = await _dbHelper.database;
    final result = await db.query('items');
    return result.map((e) => Item.fromMap(e)).toList();
  }

  Future<int> insertVariant(Variant variant) async {
    final db = await _dbHelper.database;
    return await db.insert('variants', variant.toMap());
  }

  Future<List<Variant>> getVariantsByItemId(int itemId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'variants',
      where: 'item_id = ?',
      whereArgs: [itemId],
    );
    return result.map((e) => Variant.fromMap(e)).toList();
  }

  Future<void> deleteItem(int id) async {
    final db = await _dbHelper.database;
    await db.delete('items', where: 'id = ?', whereArgs: [id]);
    await db.delete('variants', where: 'item_id = ?', whereArgs: [id]);
  }
}
