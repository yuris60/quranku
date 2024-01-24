import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/juz_model.dart';


class JuzService{
  static final JuzService instance = JuzService._init();
  static Database? _database;
  JuzService._init();

  String? tablename = 'juz';

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
      id_surah_mulai INTEGER NOT NULL,
      no_ayat_mulai INTEGER NOT NULL,
      id_surah_akhir INTEGER NOT NULL,
      no_ayat_akhir INTEGER NOT NULL,
    )""");
  }

  Future<List<ListJuzModel>> listJuz() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT juz.*, surah.nama_surah FROM juz JOIN surah ON surah.id = juz.id_surah_mulai');
    return result.map((json) => ListJuzModel.fromMap(json)).toList();
  }

  Future<List<BacaJuzModel>> bacaJuz(String id) async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT ayah_surah.id, ayah_surah.id_surah, surah.nama_surah, surah.arti, surah.kategori, surah.jml_ayat, ayah_surah.no_ayat, ayah_surah.ayat_text, ayah_surah.indo_text, ayah_surah.baca_text FROM ayah_surah JOIN surah ON surah.id = ayah_surah.id_surah WHERE ayah_surah.juz =' + id);
    return result.map((json) => BacaJuzModel.fromMap(json)).toList();
  }
}