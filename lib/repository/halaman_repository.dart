import 'package:Quranku/model/halaman_model.dart';
import 'package:sqflite/sqlite_api.dart';

class HalamanRepository {
  Future getListHalaman({required Database database}) async {
    try{
      final result = await database.rawQuery('SELECT halaman.*, surah.nama_surah FROM halaman JOIN surah ON surah.id = halaman.id_surah_mulai');
      return result.map((json) => ListHalamanModel.fromMap(json)).toList();
    } catch (e){
      return <ListHalamanModel>[];
    }
  }

  Future getBacaHalaman(Database database, String id) async {
    try {
      final result = await database.rawQuery('SELECT ayah_surah.id, ayah_surah.id_surah, surah.nama_surah, surah.arti, surah.kategori, surah.jml_ayat, ayah_surah.no_ayat, ayah_surah.ayat_text, ayah_surah.indo_text, ayah_surah.baca_text FROM ayah_surah JOIN surah ON surah.id = ayah_surah.id_surah WHERE ayah_surah.halaman =' + id);
      return result.map((json) => BacaHalamanModel.fromMap(json)).toList();
    } catch (e) {
      return <BacaHalamanModel>[];
    }
  }
}