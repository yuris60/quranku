import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/halaman_model.dart';


class HalamanService{
  static final HalamanService instance = HalamanService._init();
  static Database? _database;
  HalamanService._init();

  String? tablename = 'halaman';

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

  Future<List<ListHalamanModel>> listHalaman() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT halaman.*, surah.nama_surah FROM halaman JOIN surah ON surah.id = halaman.id_surah_mulai');
    return result.map((json) => ListHalamanModel.fromMap(json)).toList();
  }

  Future<List<BacaHalamanModel>> bacaHalaman(String id) async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT ayah_surah.id, ayah_surah.id_surah, surah.nama_surah, surah.arti, surah.kategori, surah.jml_ayat, ayah_surah.no_ayat, ayah_surah.ayat_text, ayah_surah.indo_text, ayah_surah.baca_text FROM ayah_surah JOIN surah ON surah.id = ayah_surah.id_surah WHERE ayah_surah.halaman =' + id);
    return result.map((json) => BacaHalamanModel.fromMap(json)).toList();
  }
}