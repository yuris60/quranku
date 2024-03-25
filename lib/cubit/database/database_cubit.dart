import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

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

  String surahtable = "surah";
  String juztable = "juz";
  String ayahsurahtable = "ayah_surah";
  String doatable = "doa";
  String waktushalattable = "waktu_shalat";

  Future initDB() async {
    var dbDir = await getDatabasesPath();
    var dbPath = join(dbDir, "quranku.db");

    if (await Directory(dirname(dbPath)).exists()) {
      database = await openDatabase(
        dbPath,
        version: 1,
        onCreate: onCreate
      );

      String tglhariini = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
      final result = await database!.rawQuery("SELECT * FROM waktu_shalat WHERE tanggal='"+tglhariini+"'");
      if(result.isEmpty){
        ByteData data = await rootBundle.load("assets/database/quranku.db");
        List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(dbPath).writeAsBytes(bytes);
      }
      emit(LoadDatabaseState());
    } else {
      try {
        // print("database belum ada");
        ByteData data = await rootBundle.load("assets/database/quranku.db");
        List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(dbPath).writeAsBytes(bytes);

        await Directory(dirname(dbPath)).create(recursive: true);
        database = await openDatabase(
            dbPath,
            version: 1,
            onCreate: onCreate
        );
        emit(LoadDatabaseState());
      } catch (e) {
        log(e.toString());
      }
    }
  }

  Future onCreate(Database db, int version) async {
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

    await db.execute("""CREATE TABLE IF NOT EXISTS $juztable (
            id INTEGER PRIMARY KEY NOT NULL,
            id_surah_mulai INTEGER NOT NULL,
            no_ayat_mulai INTEGER NOT NULL,
            id_surah_akhir INTEGER NOT NULL,
            no_ayat_akhir INTEGER NOT NULL
          )""");

    await db.execute("""CREATE TABLE IF NOT EXISTS $waktushalattable (
            id	INTEGER NOT NULL,
            tanggal	TEXT NOT NULL,
            subuh	TEXT NOT NULL,
            subuh_cek	INTEGER NOT NULL,
            fajar	TEXT NOT NULL,
            dzuhur	TEXT NOT NULL,
            dzuhur_cek	INTEGER NOT NULL,
            ashar	TEXT NOT NULL,
            ashar_cek	INTEGER NOT NULL,
            magrib	TEXT NOT NULL,
            magrib_cek	INTEGER NOT NULL,
            isya	TEXT NOT NULL,
            isya_cek INTEGER NOT NULL
          )""");

    await db.execute("""CREATE TABLE IF NOT EXISTS $doatable (
            id INTEGER NOT NULL,
            nama_doa TEXT NOT NULL,
            ayat_doa TEXT NOT NULL,
            latin_doa TEXT NOT NULL,
            arti_doa TEXT NOT NULL
          )""");
  }
}
