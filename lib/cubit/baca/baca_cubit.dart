import 'package:Quranku/repository/doa_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/doa_model.dart';
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
  final doaRepo = DoaRepository();

  final Database database;
  int _counter = 1;
  BacaCubit({required this.database}) : super(BacaInitial());

  List<BacaSurahModel> surahbaca = [];
  List<BacaJuzModel> juzbaca = [];
  List<BacaHalamanModel> halamanbaca = [];
  List<BacaDoaModel> doabaca = [];
  List<RandomAyatModel> ayatoftheday = [];
  List<KhatamQuranModel> khatamget = [];

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

  Future<void> getBacaDoa(String id) async {
    try {
      emit(BacaDoaLoading());
      doabaca = await doaRepo.getBacaDoa(database: database, id: id);
      emit(BacaDoaSuccess(doabaca));
    } catch (e) {
      print(e);
    }
  }

  Future<void> getRandomAyat() async {
    try {
      emit(RandomAyatLoading());
      ayatoftheday = await surahRepo.getRandomAyat(database: database);
      emit(RandomAyatSuccess(ayatoftheday));
    } catch (e) {
      print(e);
    }
  }

  Future<void> getKhatamQuran() async {
    try {
      emit(KhatamQuranLoading());
      khatamget = await surahRepo.getKhatamQuran(database: database);
      emit(KhatamQuranSuccess(khatamget));
    } catch(e) {
      print(e);
    }
  }

  Future<void> setKhatamQuran(String id_ayat, String id_surah) async {
    try {
      emit(StatusKhatamLoading());
      await surahRepo.setKhatamQuran(database: database, id: id_ayat);
      emit(StatusKhatamSuccess(_counter++));
      getBacaSurah(id_surah);
    } catch (e) {
      print(e);
    }
  }
}
