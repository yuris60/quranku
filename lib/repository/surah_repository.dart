import 'package:Quranku/model/surah_model.dart';
import 'package:sqflite/sqlite_api.dart';

class SurahRepository {

  Future getListSurah({required Database database}) async {
    try{
      final result = await database.rawQuery('SELECT * FROM surah');
      print(result);
      return result.map((json) => ListSurahModel.fromMap(json)).toList();
    } catch (e){
      return <ListSurahModel>[];
    }
  }

  Future getBacaSurah({required Database database, required String id}) async {
    try {
      final result = await database.rawQuery('SELECT * FROM ayah_surah WHERE id_surah = ' + id);
      print(result);
      return result.map((json) => BacaSurahModel.fromMap(json)).toList();
    } catch (e) {
      return <BacaSurahModel>[];
    }
  }

  Future getSurah({required Database database, required String id}) async {
    try {
      final result = await database.rawQuery('SELECT * FROM surah WHERE id = ' + id);
      return result.map((json) => ListSurahModel.fromMap(json)).toList();
    } catch (e) {
      return <ListSurahModel>[];
    }
  }
}