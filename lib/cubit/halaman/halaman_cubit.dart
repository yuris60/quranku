import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/halaman_model.dart';
import '../../repository/halaman_repository.dart';

part 'halaman_cubit_state.dart';

class HalamanCubit extends Cubit<HalamanState> {
  final halamanRepo = HalamanRepository();
  final Database database;
  HalamanCubit({required this.database}) : super(HalamanInitial());

  List<ListHalamanModel> halamanlist = [];
  List<BacaHalamanModel> halamanbaca = [];

  Future<void> getListHalaman() async {
    try {
      emit(ListHalamanLoading());
      halamanlist = await halamanRepo.getListHalaman(database: database);
      emit(ListHalamanSuccess(halamanlist: halamanlist));
    } catch(e) {
      print(e);
      // emit(ListHalamanLoading());
    }
  }

  Future<void> getBacaHalaman(String id) async {
    try {
      // emit(BacaHalamanLoading());
      halamanbaca = await halamanRepo.getBacaHalaman(database, id);
      emit(BacaHalamanSuccess(halamanbaca: halamanbaca));
    } catch (e) {
      print(e); // Catches all types of `Exception` and `Error`.
    }
  }
}
