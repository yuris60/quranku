import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/halaman_model.dart';
import '../../model/surah_model.dart';
import 'package:Quranku/model/juz_model.dart';

import '../../repository/halaman_repository.dart';
import '../../repository/juz_repository.dart';
import 'package:Quranku/repository/surah_repository.dart';

part 'baca_state.dart';

class BacaCubit extends Cubit<BacaState> {
  final surahRepo = SurahRepository();
  final juzRepo = JuzRepository();
  final halamanRepo = HalamanRepository();

  final Database database;
  BacaCubit({required this.database}) : super(BacaInitial());

  List<BacaSurahModel> surahbaca = [];
  List<BacaJuzModel> juzbaca = [];
  List<BacaHalamanModel> halamanbaca = [];

  Future<void> getBacaSurah(String id) async {
    try {
      emit(BacaSurahLoading());
      surahbaca = await surahRepo.getBacaSurah(database: database, id: id);
      emit(BacaSurahSuccess(surahbaca));
    } catch (e) {
      print(e);
    }
  }

  Future<void> getBacaJuz(String id) async {
    try {
      emit(BacaJuzLoading());
      juzbaca = await juzRepo.getBacaJuz(database: database, id: id);
      emit(BacaJuzSuccess(juzbaca));
    } catch (e) {
      print(e);
    }
  }

  Future<void> getBacaHalaman(String id) async {
    try {
      emit(BacaHalamanLoading());
      halamanbaca = await halamanRepo.getBacaHalaman(database: database, id: id);
      emit(BacaHalamanSuccess(halamanbaca));
    } catch (e) {
      print(e);
    }
  }
}
