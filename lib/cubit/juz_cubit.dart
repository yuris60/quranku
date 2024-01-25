import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/juz_model.dart';

part 'juz_state.dart';

class ListJuzCubit extends Cubit<JuzState> {
  ListJuzCubit() : super(ListJuzInitial());

  static Database? _database;
  Future<Database> get database async {
    if(_database != null){
      return _database!;
    }
    _database = await _initDB();
    return database!;
  }

  String tablename = "juz";

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
      id INTEGER NOT NULL,
      id_surah_mulai INTEGER NOT NULL,
      no_ayat_mulai INTEGER NOT NULL,
      id_surah_akhir INTEGER NOT NULL,
      no_ayat_akhir INTEGER NOT NULL,
    )""");
  }

  Future getListJuz() async {
    emit(ListJuzLoading());
    final db = await database;
    final result = await db.rawQuery('SELECT juz.*, surah.nama_surah FROM juz JOIN surah ON surah.id = juz.id_surah_mulai');
    emit(ListJuzSuccess(listjuz: result.map((json) => ListJuzModel.fromMap(json)).toList()));
  }
}

class BacaJuzCubit extends Cubit<JuzState> {
  BacaJuzCubit() : super(BacaJuzInitial());

  static Database? _database;
  String tablename = "juz";

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
      id INTEGER NOT NULL,
      id_surah_mulai INTEGER NOT NULL,
      no_ayat_mulai INTEGER NOT NULL,
      id_surah_akhir INTEGER NOT NULL,
      no_ayat_akhir INTEGER NOT NULL,
    )""");
  }

  Future getBacaJuz(String id) async {
    emit(BacaJuzLoading());
    final db = await database;
    final result = await db.rawQuery('SELECT ayah_surah.id, ayah_surah.id_surah, surah.nama_surah, surah.arti, surah.kategori, surah.jml_ayat, ayah_surah.no_ayat, ayah_surah.ayat_text, ayah_surah.indo_text, ayah_surah.baca_text FROM ayah_surah JOIN surah ON surah.id = ayah_surah.id_surah WHERE ayah_surah.juz =' + id);
    // return result.map((json) => ListJuzModel.fromMap(json)).toList();
    emit(BacaJuzSuccess(bacajuz: result.map((json) => BacaJuzModel.fromMap(json)).toList()));
  }
}
