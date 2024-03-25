import 'dart:typed_data';

import 'package:Quranku/model/waktu_shalat_model.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'dart:io';

class WaktuShalatRepository{
  Future getWaktuShalat({required Database database}) async {
    try{
      String tglhariini = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
      final result = await database.rawQuery("SELECT id, tanggal, subuh, subuh_cek, fajar, dzuhur, dzuhur_cek, ashar, ashar_cek, magrib, magrib_cek, isya, isya_cek, setting.kota FROM waktu_shalat JOIN setting ON setting.kota=waktu_shalat.kota WHERE tanggal='"+tglhariini+"'");
      if(result.isNotEmpty) {
        return result.map((json) => WaktuShalatModel.fromMap(json)).toList();
      } else {
        var dbDir = await getDatabasesPath();
        var dbPath = join(dbDir, "quranku.db");
        ByteData data = await rootBundle.load("assets/database/quranku.db");
        List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(dbPath).writeAsBytes(bytes);
      }
    } catch (e){
      return <WaktuShalatModel>[];
    }
  }

  Future<void> setSudahShalat({required Database database, required String field, required String id}) async {
    try{
      final result = await database.transaction((txn) async {
        await txn.rawUpdate("UPDATE waktu_shalat SET $field='1' WHERE id=$id");
      });
      return result;
    } catch (e){
      return print(e);
    }
  }

  Future<void> setBelumShalat({required Database database, required String field, required String id}) async {
    try{
      final result = await database.transaction((txn) async {
        await txn.rawUpdate("UPDATE waktu_shalat SET $field='0' WHERE id=$id");
      });
      return result;
    } catch (e){
      return print("Gagal Update");
    }
  }

  Future getTanggalSebelumnya({required Database database, required String id}) async {
    try {
      final result = await database.rawQuery('SELECT * FROM waktu_shalat WHERE id=$id-1');
      return result.map((json) => WaktuShalatModel.fromMap(json)).toList();
    } catch (e) {
      return <WaktuShalatModel>[];
    }
  }

  Future getTanggalSetelahnya({required Database database, required String id}) async {
    try {
      final result = await database.rawQuery('SELECT * FROM waktu_shalat WHERE id=$id+1');
      return result.map((json) => WaktuShalatModel.fromMap(json)).toList();
    } catch (e) {
      return <WaktuShalatModel>[];
    }
  }
}