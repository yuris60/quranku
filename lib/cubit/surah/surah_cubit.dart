import 'package:Quranku/repository/surah_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/surah_model.dart';

part 'surah_state.dart';

class SurahCubit extends Cubit<SurahState> {
  final surahRepo = SurahRepository();
  final Database database;
  SurahCubit({required this.database}) : super(SurahInitial());

  List<ListSurahModel> surahlist = [];
  List<ListSurahModel> surahget = [];

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
}
