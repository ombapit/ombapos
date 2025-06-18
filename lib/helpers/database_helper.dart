import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'ombapos.db');

    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE customers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT,
        email TEXT,
        birthday TEXT,
        gender TEXT,
        address_street TEXT,
        address_city TEXT,
        address_province TEXT,
        address_postcode TEXT,
        created_at INTEGER
      );
    ''');
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      );
    ''');
    await db.execute('''
      CREATE TABLE items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        category_id INTEGER,
        image_path TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE variants (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        price INTEGER NOT NULL,
        sku TEXT NOT NULL,
        item_id INTEGER NOT NULL
      );
    ''');
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        c_id INTEGER,                       -- Id pelanggan (opsional)
        receipt_number TEXT UNIQUE,         -- Nomor struk/nota
        payment_method TEXT,                -- Tunai / QRIS / Transfer / dll.
        total_amount INTEGER,               -- Total bayar (dalam rupiah)
        paid_amount INTEGER,                -- Jumlah yang dibayar
        change_amount INTEGER,              -- Kembalian
        created_at INTEGER                  -- Timestamp UNIX (detik atau ms)
      );
    ''');
    await db.execute('''
      CREATE TABLE transaction_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        t_id INTEGER NOT NULL,                       
        v_id INTEGER NOT NULL,                       
        quantity INTEGER NOT NULL,                      
        price INTEGER NOT NULL,                      
        subtotal INTEGER NOT NULL,                      
        notes TEXT
      );
    ''');
    // await db.execute('''
    //   CREATE TABLE shifts (
    //     id INTEGER PRIMARY KEY AUTOINCREMENT,
    //     shift_name TEXT,         -- Nama Shift (Opsional, misal "Shift 1")
    //     opened_by TEXT,          -- Nama user/kasir buka shift
    //     opened_at INTEGER,       -- UNIX timestamp buka
    //     closed_by TEXT,          -- Nama user/kasir tutup shift
    //     closed_at INTEGER,       -- UNIX timestamp tutup
    //     starting_balance INTEGER, -- Saldo awal
    //     ending_balance INTEGER    -- Saldo akhir (optional)
    //   );
    // ''');
  }
}
