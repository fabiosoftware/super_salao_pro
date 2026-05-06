import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE clientes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nome TEXT
)
''');

    await db.execute('''
CREATE TABLE agendamentos (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  cliente TEXT,
  servico TEXT,
  valor REAL,
  hora TEXT,
  data TEXT
)
''');
  }

  Future<int> insert(String tabela, Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.insert(tabela, data);
  }

  Future<List<Map<String, dynamic>>> getAll(String tabela) async {
    final db = await instance.database;
    return await db.query(tabela);
  }

  Future<int> delete(String tabela, int id) async {
    final db = await instance.database;
    return await db.delete(tabela, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getPorData(String data) async {
    final db = await instance.database;
    return await db.query(
      'agendamentos',
      where: 'data = ?',
      whereArgs: [data],
    );
  }

  Future<double> getFaturamentoHoje(String data) async {
    final db = await instance.database;

    final resultado = await db.rawQuery('''
      SELECT SUM(valor) as total 
      FROM agendamentos 
      WHERE data = ?
    ''', [data]);

    final valor = resultado.first['total'];

    if (valor == null) return 0.0;
    if (valor is int) return valor.toDouble();
    if (valor is double) return valor;

    return 0.0;
  }
}