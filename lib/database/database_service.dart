import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/quran_model.dart';

// https://www.youtube.com/watch?v=9kbt4SBKhm0

class DatabaseQuranku{
  static final DatabaseQuranku instance = DatabaseQuranku._init();
  static Database? _database;
  DatabaseQuranku._init();

  String? tablename = 'ayah_surah';

  Future<Database> get database async {
    if(_database != null){
      return _database!;
    }
    _database = await _initDB();
    return database!;
  }

  // Future<Database> _initDB(String filePath) async {
  Future<Database> _initDB() async {
    var dbDir = await getDatabasesPath();
    var dbPath = join(dbDir, "quranku.db");
    ByteData data = await rootBundle.load("assets/database/quranku.db");
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(dbPath).writeAsBytes(bytes);

    // final dbPath = await getDatabasesPath();
    // final path = dbPath + filePath;
    return await openDatabase(dbPath, version: 1, onCreate: _createDB);
  }

   //AKTIFKAN FITUR INI UNTUK SIMPAN DATA
  Future _createDB(Database db, int version) async {
    await db.execute("""CREATE TABLE IF NOT EXISTS $tablename (
      id INTEGER PRIMARY KEY NOT NULL,
      id_surah INTEGER NOT NULL,
      no_ayat INTEGER NOT NULL,
      ayat_text TEXT NOT NULL,
      indo_text TEXT NOT NULL,
      baca_text TEXT NOT NULL
    )""");
  }

  Future<int> create(BacaSurahModel ayah_surah) async {
    final db = await instance.database;
    final id = await db.insert('ayah_surah', ayah_surah.toMap());
    return id;
  }

  Future<ListSurahModel> getSurah(String id) async {
    final db = await instance.database;
    final result = await db.query(
      'surah',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return ListSurahModel.fromMap(result.first);
    } else {
      throw Exception('ID $id not found');
    }
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

  Future<List<ListSurahModel>> listSurah() async {
    final db = await instance.database;
    // const orderBy = 'verseID ASC';
    // final result = await db.query('surah', orderBy: orderBy);
    final result = await db.query('surah');
    return result.map((json) => ListSurahModel.fromMap(json)).toList();
  }
}