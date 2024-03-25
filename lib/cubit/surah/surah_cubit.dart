import 'package:Quranku/repository/surah_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/surah_model.dart';

part 'surah_state.dart';

class SurahCubit extends Cubit<SurahState> {
  final surahRepo = SurahRepository();
  final Database database;
  int _counter = 1;
  SurahCubit({required this.database}) : super(SurahInitial());

  List<ListSurahModel> surahlist = [];
  List<ListSurahModel> surahget = [];
  List<ListSurahModel> bookmarkget = [];

  Future<void> getListSurah() async {
    try {
      emit(ListSurahLoading());
      surahlist = await surahRepo.getListSurah(database: database);
      emit(ListSurahSuccess(surahlist));
    } catch(e) {
      print(e);
    }
  }

  Future<void> getSurah(String id) async {
    try {
      emit(GetSurahLoading());
      surahget = await surahRepo.getSurah(database: database, id: id);
      emit(GetSurahSuccess(surahget));
    } catch(e) {
      print(e);
    }
  }

  Future<void> setAddBoorkmarkSurah(String id) async {
    try {
      emit(StatusBookmarkLoading());
      await surahRepo.setAddBookmarkSurah(database: database, id: id);
      emit(StatusBookmarkSuccess(_counter++));
      getListSurah();
    } catch (e) {
      print(e);
    }
  }

  Future<void> setRemoveBoorkmarkSurah(String id) async {
    try {
      emit(StatusBookmarkLoading());
      await surahRepo.setRemoveBookmarkSurah(database: database, id: id);
      emit(StatusBookmarkSuccess(_counter++));
      getListSurah();
    } catch (e) {
      print(e);
    }
  }

  Future<void> setRemoveBoorkmarkSurah2(String id) async {
    try {
      emit(StatusBookmarkLoading());
      await surahRepo.setRemoveBookmarkSurah(database: database, id: id);
      emit(StatusBookmarkSuccess(_counter++));
      getBookmarkSurah();
    } catch (e) {
      print(e);
    }
  }

  Future<void> getBookmarkSurah() async {
    try {
      emit(ListSurahLoading());
      surahlist = await surahRepo.getBookmarkSurah(database: database);
      if(surahlist.isNotEmpty) {
        emit(ListSurahSuccess(surahlist));
      } else {
        emit(ListSurahLoading());
      }
    } catch(e) {
      print(e);
    }
  }

  Future<void> getSearchSurah(String keyword) async {
    try {
      emit(ListSurahLoading());
      surahlist = await surahRepo.getSearchSurah(database: database, keyword: keyword);
      if(surahlist.isNotEmpty) {
        emit(ListSurahSuccess(surahlist));
      } else {
        emit(ListSurahLoading());
      }
    } catch(e) {
      emit(ListSurahKosong());
      print(e);
    }
  }
}
