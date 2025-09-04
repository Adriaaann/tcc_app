import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tcc_app/models/financial_form_data_model.dart';

class DbHelper {
  static final DbHelper instance = DbHelper._internal();
  static Database? _database;

  DbHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'finance.db');

    return openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('DROP TABLE IF EXISTS expenses');
          await db.execute('DROP TABLE IF EXISTS subscriptions');
          await _onCreate(db, newVersion);
        }
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        value REAL NOT NULL,
        category TEXT NOT NULL,
        title TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE subscriptions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        value REAL NOT NULL,
        category TEXT NOT NULL,
        title TEXT
      )
    ''');
  }

  Future<int> insert(String table, FinancialFormData data) async {
    final db = await database;

    return db.insert(table, {
      'date': data.date.toIso8601String(),
      'value': data.value,
      'category': data.category,
      'title': data.title,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> update(String table, FinancialFormData data, int id) async {
    final db = await database;

    return db.update(
      table,
      {
        'date': data.date.toIso8601String(),
        'value': data.value,
        'category': data.category,
        'title': data.title,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(String table, int id) async {
    final db = await database;
    return db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
