import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/setting_model.dart';
import '../../model/waktu_shalat_model.dart';
import '../../repository/waktu_shalat_repository.dart';

part 'waktu_shalat_state.dart';

class WaktuShalatCubit extends Cubit<WaktuShalatState> {
  final waktuShalatRepo = WaktuShalatRepository();

  final Database database;
  int _counter = 1;
  WaktuShalatCubit({required this.database}) : super(WaktuShalatInitial());

  List<WaktuShalatModel> waktushalat = [];
  List<SettingModel> settingshalat = [];

  Future<void> getWaktuShalat() async {
    try {
      emit(WaktuShalatLoading());
      waktushalat = await waktuShalatRepo.getWaktuShalat(database: database);
      emit(WaktuShalatSuccess(waktushalat));
    } catch (e) {
      print(e);
    }
  }

  Future<void> setSudahShalat(String field, String id) async {
    try {
      emit(StatusShalatLoading());
      await waktuShalatRepo.setSudahShalat(database: database, field: field, id: id);
      emit(StatusShalatSuccess(_counter++));
      getWaktuShalat();
    } catch (e) {
      print(e);
    }
  }

  Future<void> setBelumShalat(String field, String id) async {
    try {
      emit(StatusShalatLoading());
      await waktuShalatRepo.setBelumShalat(database: database, field: field, id: id);
      emit(StatusShalatSuccess(_counter++));
      getWaktuShalat();
    } catch (e) {
      print(e);
    }
  }

  Future<void> getTanggalSebelumnya(String id) async {
    try {
      emit(WaktuShalatLoading());
      waktushalat = await waktuShalatRepo.getTanggalSebelumnya(database: database, id: id);
      emit(WaktuShalatSuccess(waktushalat));
    } catch (e) {
      print(e);
    }
  }

  Future<void> getTanggalSetelahnya(String id) async {
    try {
      emit(WaktuShalatLoading());
      waktushalat = await waktuShalatRepo.getTanggalSetelahnya(database: database, id: id);
      emit(WaktuShalatSuccess(waktushalat));
    } catch (e) {
      print(e);
    }
  }
}
