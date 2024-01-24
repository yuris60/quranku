import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/surah_model.dart';

class AyahSurahService{
  static final AyahSurahService instance = AyahSurahService._init();
  static Database? _database;
  AyahSurahService._init();

  String? tablename = 'ayah_surah';

  Future<Database> get database async {
    if(_database != null){
      return _database!;
    }
    _database = await _initDB();
    return database!;
  }

  Future<Database> _initDB() async {
    var dbDir = await getDatabasesPath();
    var dbPath = join(dbDir, "quranku.db");
    ByteData data = await rootBundle.load("assets/database/quranku.db");
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(dbPath).writeAsBytes(bytes);

    return await openDatabase(dbPath, version: 1, onCreate: _createTable);
  }

  Future _createTable(Database db, int version) async {
    await db.execute("""CREATE TABLE IF NOT EXISTS $tablename (
      id INTEGER PRIMARY KEY NOT NULL,
      id_surah INTEGER NOT NULL,
      no_ayat INTEGER NOT NULL,
      ayat_text TEXT NOT NULL,
      indo_text TEXT NOT NULL,
      baca_text TEXT NOT NULL
    )""");
  }

  Future<List<BacaSurahModel>> bacaSurah(String id) async {
    final db = await instance.database;
    final result = await db.query(
      'ayah_surah',
      where: 'id_surah = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return result.map((json) => BacaSurahModel.fromMap(json)).toList();
    } else {
      throw Exception('ID $id not found');
    }
  }
}