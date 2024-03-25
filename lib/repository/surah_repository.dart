import 'package:Quranku/model/surah_model.dart';
import 'package:sqflite/sqlite_api.dart';

class SurahRepository {

  Future getListSurah({required Database database}) async {
    try{
      final result = await database.rawQuery('SELECT * FROM surah');
      return result.map((json) => ListSurahModel.fromMap(json)).toList();
    } catch (e){
      return <ListSurahModel>[];
    }
  }

  Future getBacaSurah({required Database database, required String id}) async {
    try {
      final result = await database.rawQuery('SELECT ayah_surah.*, surah.nama_surah FROM ayah_surah JOIN surah ON surah.id = ayah_surah.id_surah WHERE ayah_surah.id_surah = ' + id);
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

  Future getRandomAyat({required Database database}) async {
    try {
      final result = await database.rawQuery('SELECT ayah_surah.id, ayah_surah.id_surah, surah.nama_surah, ayah_surah.no_ayat, ayah_surah.ayat_text, ayah_surah.indo_text, ayah_surah.is_random_ayat FROM ayah_surah JOIN surah ON surah.id = ayah_surah.id_surah WHERE ayah_surah.is_random_ayat=1 ORDER BY RANDOM() LIMIT 1');
      // print(result);
      return result.map((json) => RandomAyatModel.fromMap(json)).toList();
    } catch (e) {
      return <RandomAyatModel>[];
    }
  }

  Future setAddBookmarkSurah({required String id, required Database database}) async {
    try {
      final result = await database.transaction((txn) async {
        await txn.rawUpdate("UPDATE surah SET is_bookmark='1' WHERE id=$id");
      });
      return result;
    } catch (e) {
      return print(e);
    }
  }

  Future setRemoveBookmarkSurah({required String id, required Database database}) async {
    try {
      final result = await database.transaction((txn) async {
        await txn.rawUpdate("UPDATE surah SET is_bookmark='0' WHERE id=$id");
      });
      return result;
    } catch (e) {
      return print(e);
    }
  }

  Future getKhatamQuran({required Database database}) async {
    try {
      final result = await database.rawQuery('SELECT ayah_surah.id, ayah_surah.id_surah, surah.nama_surah, ayah_surah.no_ayat, ayah_surah.ayat_text, ayah_surah.indo_text FROM ayah_surah JOIN surah ON surah.id = ayah_surah.id_surah WHERE ayah_surah.is_khatam=1 LIMIT 1');
      return result.map((json) => KhatamQuranModel.fromMap(json)).toList();
    } catch (e) {
      return <KhatamQuranModel>[];
    }
  }

  Future setKhatamQuran({required Database database, required String id}) async {
    try {
      final result = await database.transaction((txn) async {
        await txn.rawUpdate("UPDATE ayah_surah SET is_khatam='0'");
        await txn.rawUpdate("UPDATE ayah_surah SET is_khatam='1' WHERE id=$id");
      });
      return result;
    } catch (e) {
      return <KhatamQuranModel>[];
    }
  }

  Future getBookmarkSurah({required Database database}) async {
    try{
      final result = await database.rawQuery('SELECT * FROM surah WHERE is_bookmark=1');
      return result.map((json) => ListSurahModel.fromMap(json)).toList();
    } catch (e){
      return <ListSurahModel>[];
    }
  }

  Future getSearchSurah({required Database database, required String keyword}) async {
    try{
      final result = await database.rawQuery("SELECT * FROM surah WHERE nama_surah LIKE '%$keyword%'");
      return result.map((json) => ListSurahModel.fromMap(json)).toList();
    } catch (e){
      return <ListSurahModel>[];
    }
  }
}