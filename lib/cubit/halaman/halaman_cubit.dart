import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/halaman_model.dart';
import '../../repository/halaman_repository.dart';

part 'halaman_state.dart';

class HalamanCubit extends Cubit<HalamanState> {
  final halamanRepo = HalamanRepository();
  final Database database;
  HalamanCubit({required this.database}) : super(HalamanInitial());

  List<ListHalamanModel> halamanlist = [];

  Future<void> getListHalaman() async {
    try {
      emit(ListHalamanLoading());
      halamanlist = await halamanRepo.getListHalaman(database: database);
      emit(ListHalamanSuccess(halamanlist));
    } catch(e) {
      print(e);
    }
  }
}
