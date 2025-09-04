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

    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        value TEXT NOT NULL,
        category TEXT NOT NULL,
        title TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE subscriptions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        value TEXT NOT NULL,
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

  Future<List<FinancialFormData>> getAll(String table) async {
    final db = await database;
    final maps = await db.query(table);

    return maps
        .map(
          (map) => FinancialFormData(
            id: map['id'] as int,
            date: DateTime.parse(map['date'] as String),
            value: map['value'] as String,
            category: map['category'] as String,
            title: map['title'] as String?,
          ),
        )
        .toList();
  }
}
