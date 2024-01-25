import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/surah_model.dart';

part 'surah_state.dart';

class ListSurahCubit extends Cubit<SurahState> {
  ListSurahCubit() : super(ListSurahInitial());

  static Database? _database;
  Future<Database> get database async {
    if(_database != null){
      return _database!;
    }
    _database = await _initDB();
    return database!;
  }

  String tablename = "surah";

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

  Future getListSurah() async {
    emit(ListSurahLoading());
    final db = await database;
    final result = await db.rawQuery('SELECT * FROM surah');
    // return result.map((json) => ListJuzModel.fromMap(json)).toList();
    emit(ListSurahSuccess(surahlist: result.map((json) => ListSurahModel.fromMap(json)).toList()));
  }
}

class BacaSurahCubit extends Cubit<SurahState> {
  BacaSurahCubit() : super(BacaSurahInitial());

  static Database? _database;
  Future<Database> get database async {
    if(_database != null){
      return _database!;
    }
    _database = await _initDB();
    return database!;
  }

  String tablename = "ayah_surah";

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
      id_surah INTEGER NOT NULL,
      no_ayat INTEGER NOT NULL,
      juz INTEGER NOT NULL,
      halaman INTEGER NOT NULL,
      ayat_text TEXT NOT NULL
      indo_text TEXT NOT NULL
      baca_text TEXT NOT NULL
    )""");
  }

  Future getBacaSurah(String id) async {
    emit(BacaSurahLoading());
    final db = await database;
    final result = await db.rawQuery('SELECT * FROM ayah_surah WHERE id_surah = ' + id);
    // return result.map((json) => ListJuzModel.fromMap(json)).toList();
    emit(BacaSurahSuccess(surahlist: result.map((json) => BacaSurahModel.fromMap(json)).toList()));
  }
}

class GetSurahCubit extends Cubit<SurahState> {
  GetSurahCubit() : super(BacaSurahInitial());

  static Database? _database;
  Future<Database> get database async {
    if(_database != null){
      return _database!;
    }
    _database = await _initDB();
    return database!;
  }

  String tablename = "surah";

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
      nama_surah TEXT NOT NULL,
      arabic TEXT NOT NULL,
      jml_ayat INTEGER NOT NULL,
      arti TEXT NOT NULL,
      kategori TEXT NOT NULL
    )""");
  }

  Future getSurah(String id) async {
    emit(GetSurahLoading());
    final db = await database;
    final result = await db.rawQuery('SELECT * FROM surah WHERE id = ' + id);
    emit(GetSurahSuccess(surahlist: result.map((json) => ListSurahModel.fromMap(json)).toList()));
  }
}