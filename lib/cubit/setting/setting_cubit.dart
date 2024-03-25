import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/setting_model.dart';
import '../../repository/setting_repository.dart';

part 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  final settingRepo = SettingRepository();

  final Database database;
  int _counter = 1;
  List<SettingModel> settingshalat = [];
  SettingCubit({required this.database}) : super(SettingInitial());

  Future<void> getSetting(String id) async {
    try {
      emit(SettingLoading());
      settingshalat = await settingRepo.getSettingShalat(database: database);
      emit(SettingSuccess(settingshalat));
    } catch (e) {
      print(e);
    }
  }
}
