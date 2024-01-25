import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

part 'database_state.dart';

class DatabaseCubit extends Cubit<DatabaseState> {
  DatabaseCubit() : super(DatabaseInitial());

  Database? database;

  // Future<Database> get database async {
  //   if(_database != null){
  //     return _database!;
  //   }
  //   _database = await initDB();
  //   return database!;
  // }

  String surahtable = "surah";
  String ayahsurahtable = "ayah_surah";

  Future<void> initDB() async {
    var dbDir = await getDatabasesPath();
    var dbPath = join(dbDir, "quranku.db");
    ByteData data = await rootBundle.load("assets/database/quranku.db");
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    if (await File(dbPath).exists()) {
      database = await openDatabase(
        dbPath,
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute("""CREATE TABLE IF NOT EXISTS $surahtable (
            id INTEGER PRIMARY KEY NOT NULL,
            nama_surah TEXT NOT NULL,
            arabic TEXT NOT NULL,
            jml_ayat INTEGER NOT NULL,
            arti TEXT NOT NULL,
            kategori TEXT NOT NULL
          )""");

          await db.execute("""CREATE TABLE IF NOT EXISTS $ayahsurahtable (
            id INTEGER NOT NULL,
            id_surah INTEGER NOT NULL,
            no_ayat INTEGER NOT NULL,
            juz INTEGER NOT NULL,
            halaman INTEGER NOT NULL,
            ayat_text TEXT NOT NULL,
            indo_text TEXT NOT NULL,
            baca_text TEXT NOT NULL
          )""");
        },
      );
      emit(LoadDatabaseState());
    } else {
      try {
        await File(dbPath).create(recursive: true);
      } catch (e) {
        // log(e.toString());
      }
    }

    void createTable(Database db, int version) async {
      await db.execute("""CREATE TABLE IF NOT EXISTS $surahtable (
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

    void onUpgrade(Database database,
        int oldVersion,
        int newVersion,) {
      if (newVersion > oldVersion) {}
    }
  }
}
