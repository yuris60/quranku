import 'package:Quranku/model/doa_model.dart';
import 'package:sqflite/sqlite_api.dart';

class DoaRepository {
  Future getListDoa({required Database database}) async {
    try{
      final result = await database.rawQuery('SELECT * FROM doa');
      // print(result);
      return result.map((json) => ListDoaModel.fromMap(json)).toList();
    } catch (e){
      return <ListDoaModel>[];
    }
  }

  Future getBacaDoa({required Database database, required String id}) async {
    try{
      final result = await database.rawQuery('SELECT * FROM doa WHERE id=' + id);
      // print(result);
      return result.map((json) => BacaDoaModel.fromMap(json)).toList();
    } catch (e){
      return <BacaDoaModel>[];
    }
  }

  Future setAddBookmarkDoa({required String id, required Database database}) async {
    try {
      final result = await database.transaction((txn) async {
        await txn.rawUpdate("UPDATE doa SET is_bookmark='1' WHERE id=$id");
      });
      return result;
    } catch (e) {
      return print(e);
    }
  }

  Future setRemoveBookmarkDoa({required String id, required Database database}) async {
    try {
      final result = await database.transaction((txn) async {
        await txn.rawUpdate("UPDATE doa SET is_bookmark='0' WHERE id=$id");
      });
      return result;
    } catch (e) {
      return print(e);
    }
  }

  Future getBookmarkDoa({required Database database}) async {
    try{
      final result = await database.rawQuery('SELECT * FROM doa WHERE is_bookmark=1');
      return result.map((json) => ListDoaModel.fromMap(json)).toList();
    } catch (e){
      return <ListDoaModel>[];
    }
  }
}