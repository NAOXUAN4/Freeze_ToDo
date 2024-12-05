import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../models/appointment_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('appointments.db');
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

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE appointments (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      subject TEXT NOT NULL,
      startTime TEXT NOT NULL,
      endTime TEXT NOT NULL,
      state TEXT NOT NULL,   
      notes TEXT,
      color TEXT
    )
    ''');
  }

  // 插入数据
  Future<int> insertAppointment(AppointmentModel appointment) async {
    final db = await database;
    return await db.insert('appointments', appointment.toMap());
  }

  // 查询所有
  Future<List<AppointmentModel>> queryAllAppointments() async {
    final db = await database;
    final maps = await db.query('appointments');
    return maps.map((map) => AppointmentModel.fromMap(map)).toList();
  }

  // 更新
  Future<int> updateAppointment(AppointmentModel appointment) async {
    final db = await database;
    return await db.update(
      'appointments',
      appointment.toMap(),
      where: 'id = ?',
      whereArgs: [appointment.id],
    );
  }

  // 删除
  Future<int> deleteAppointment(int id) async {
    final db = await database;
    return await db.delete(
      'appointments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 根据日期范围查询
  Future<List<AppointmentModel>> queryAppointmentsByDateRange(DateTime start, DateTime end) async {
    final db = await database;
    final maps = await db.query(
      'appointments',
      where: 'startTime >= ? AND startTime <= ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
    );
    return maps.map((map) => AppointmentModel.fromMap(map)).toList();
  }

  // 打印所有数据表的内容
  Future<void> printAllTables() async {
    final db = await database;
    // 获取所有表名
    final tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table';");
    for (var table in tables) {
      final tableName = table['name'] as String;
      // print('Table: $tableName');
      // 查询表中的所有数据
      final rows = await db.query(tableName);
      for (var row in rows) {
        print(row);
      }
      print('---');
    }
  }
}