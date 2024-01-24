import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/surah_model.dart';

class SurahService{
  static final SurahService instance = SurahService._init();
  static Database? _database;
  SurahService._init();

  String? tablename = 'surah';

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

    return await openDatabase(dbPath, version: 1, onCreate: _createTable);
  }

  Future _createTable(Database db, int version) async {
    await db.execute("""CREATE TABLE IF NOT EXISTS $tablename (
      id INTEGER PRIMARY KEY NOT NULL,
      nama_surah TEXT NOT NULL,
      arabic TEXT NOT NULL,
      jml_ayat INTEGER NOT NULL,
      arti TEXT NOT NULL,
      kategori TEXT NOT NULL
    )""");
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

  Future<List<ListSurahModel>> listSurah() async {
    final db = await instance.database;
    // const orderBy = 'verseID ASC';
    // final result = await db.query('surah', orderBy: orderBy);
    final result = await db.rawQuery('SELECT * FROM surah');
    return result.map((json) => ListSurahModel.fromMap(json)).toList();
  }
}