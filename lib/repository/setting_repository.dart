import 'dart:typed_data';
import 'dart:io';

import 'package:Quranku/model/setting_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class SettingRepository{
  Future getSettingShalat({required Database database}) async {
    try{
      final result = await database.rawQuery("SELECT * FROM setting");
      return result.map((json) => SettingModel.fromMap(json)).toList();
    } catch (e){
      return print(e);
    }
  }
}