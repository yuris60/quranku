import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/juz_model.dart';
import '../../repository/juz_repository.dart';

part 'juz_state.dart';

class JuzCubit extends Cubit<JuzState> {
  final juzRepo = JuzRepository();
  final Database database;
  JuzCubit({required this.database}) : super(JuzInitial());

  List<ListJuzModel> juzlist = [];

  Future<void> getListJuz() async {
    try {
      emit(ListJuzLoading());
      juzlist = await juzRepo.getListJuz(database: database);
      emit(ListJuzSuccess(juzlist));
    } catch(e) {
      print(e);
    }
  }
}
