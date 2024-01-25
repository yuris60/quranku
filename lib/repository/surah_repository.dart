import 'package:Quranku/model/surah_model.dart';
import 'package:sqflite/sqlite_api.dart';

class SurahRepository {
  Future getListSurah({required Database database}) async {
    final result = await database.rawQuery('SELECT * FROM surah');
    return result.map((json) => ListSurahModel.fromMap(json)).toList();
  }

  Future<List<BacaSurahModel>> getBacaSurah(Database database, String id) async {
    try {
      final result = await database.rawQuery('SELECT * FROM ayah_surah WHERE id_surah = ' + id);
      return result.map((json) => BacaSurahModel.fromMap(json)).toList();
    } catch (e) {
      throw e;
    }
  }

  Future getSurah({required Database database, required String id}) async {
    final result = await database.rawQuery('SELECT * FROM surah WHERE id_surah = ' + id);
    return result.map((json) => ListSurahModel.fromMap(json)).toList();
  }
}