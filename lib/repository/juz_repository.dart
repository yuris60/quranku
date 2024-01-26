import 'package:Quranku/model/juz_model.dart';
import 'package:sqflite/sqlite_api.dart';

class JuzRepository {
  Future getListJuz({required Database database}) async {
    try{
      final result = await database.rawQuery('SELECT juz.*, surah.nama_surah FROM juz JOIN surah ON surah.id = juz.id_surah_mulai');
      return result.map((json) => ListJuzModel.fromMap(json)).toList();
    } catch (e){
      return <ListJuzModel>[];
    }
  }

  Future getBacaJuz(Database database, String id) async {
    try {
      final result = await database.rawQuery('SELECT ayah_surah.id, ayah_surah.id_surah, surah.nama_surah, surah.arti, surah.kategori, surah.jml_ayat, ayah_surah.no_ayat, ayah_surah.ayat_text, ayah_surah.indo_text, ayah_surah.baca_text FROM ayah_surah JOIN surah ON surah.id = ayah_surah.id_surah WHERE ayah_surah.juz =' + id);
      return result.map((json) => BacaJuzModel.fromMap(json)).toList();
    } catch (e) {
      return <BacaJuzModel>[];
    }
  }
}