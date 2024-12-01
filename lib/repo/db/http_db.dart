import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

import 'init_db.dart';

class CloudSync {
  static Future<void> syncToCloud() async {
    // 获取数据库中的数据
    DatabaseHelper dbHelper = DatabaseHelper();
    Database db = await dbHelper.db;
    List<Map<String, dynamic>> appointments = await db.query("Appointment");

    // 发送数据到云端
    for (var appointment in appointments) {
      await http.post(
        Uri.parse('https://your-api-endpoint.com/appointments'),
        body: appointment,
      );
    }
  }
}
