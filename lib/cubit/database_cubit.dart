import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

part 'database_state.dart';

class DatabaseCubit extends Cubit<DatabaseState> {
  DatabaseCubit() : super(DatabaseInitial());

  static final DatabaseCubit dbProvider = DatabaseCubit();

  static Database? _database;
  Future<Database> get database async {
    if(_database != null){
      return _database!;
    }
    _database = await initDB();
    return database!;
  }

  String tablename = "surah";

  Future<Database> initDB() async {
    var dbDir = await getDatabasesPath();
    var dbPath = join(dbDir, "quranku.db");
    ByteData data = await rootBundle.load("assets/database/quranku.db");
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(dbPath).writeAsBytes(bytes);

    return await openDatabase(dbPath, version: 1, onCreate: _createTable, onUpgrade: onUpgrade);
  }

  void _createTable(Database db, int version) async {
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

  void onUpgrade(
      Database database,
      int oldVersion,
      int newVersion,
      ){
    if (newVersion > oldVersion){}
  }
}
