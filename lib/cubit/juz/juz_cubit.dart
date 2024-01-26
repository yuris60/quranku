import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/juz_model.dart';
import '../../repository/juz_repository.dart';

part 'juz_cubit_state.dart';

class JuzCubit extends Cubit<JuzState> {
  final juzRepo = JuzRepository();
  final Database database;
  JuzCubit({required this.database}) : super(JuzInitial());

  List<ListJuzModel> juzlist = [];
  List<BacaJuzModel> juzbaca = [];

  Future<void> getListJuz() async {
    try {
      emit(ListJuzLoading());
      juzlist = await juzRepo.getListJuz(database: database);
      emit(ListJuzSuccess(juzlist: juzlist));
    } catch(e) {
      print(e);
      // emit(ListJuzLoading());
    }
  }

  Future<void> getBacaJuz(String id) async {
    try {
      // emit(BacaJuzLoading());
      juzbaca = await juzRepo.getBacaJuz(database, id);
      emit(BacaJuzSuccess(juzbaca: juzbaca));
    } catch (e) {
      print(e); // Catches all types of `Exception` and `Error`.
    }
  }
}
