import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE kategori (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertKategori(String nama) async {
    final database = await db;
    return await database.insert('kategori', {'nama': nama});
  }

  Future<int> editCategory(int id, String nama) async {
    final database = await db;
    return database.update(
      'kategori',
      {'nama': nama},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getAllKategori() async {
    final database = await db;
    return await database.query('kategori', orderBy: 'nama ASC');
  }

  Future<void> deleteKategori(int id) async {
    final database = await db;
    await database.delete('kategori', where: 'id = ?', whereArgs: [id]);
  }
}
