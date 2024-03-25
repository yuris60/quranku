import 'package:Quranku/model/doa_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sqflite/sqflite.dart';

import '../../repository/doa_repository.dart';

part 'doa_state.dart';

class DoaCubit extends Cubit<DoaState> {
  final doaRepo = DoaRepository();

  final Database database;
  int _counter = 1;
  DoaCubit({required this.database}) : super(DoaInitial());

  List<ListDoaModel> listdoa = [];

  Future<void> getListDoa() async {
    try {
      emit(ListDoaLoading());
      listdoa = await doaRepo.getListDoa(database: database);
      emit(ListDoaSuccess(listdoa));
    } catch (e) {
      print(e);
    }
  }

  Future<void> setAddBoorkmarkDoa(String id) async {
    try {
      emit(StatusBookmarkLoading());
      await doaRepo.setAddBookmarkDoa(database: database, id: id);
      emit(StatusBookmarkSuccess(_counter++));
      getListDoa();
    } catch (e) {
      print(e);
    }
  }

  Future<void> setRemoveBoorkmarkDoa(String id) async {
    try {
      emit(StatusBookmarkLoading());
      await doaRepo.setRemoveBookmarkDoa(database: database, id: id);
      emit(StatusBookmarkSuccess(_counter++));
      getListDoa();
    } catch (e) {
      print(e);
    }
  }

  Future<void> setRemoveBoorkmarkDoa2(String id) async {
    try {
      emit(StatusBookmarkLoading());
      await doaRepo.setRemoveBookmarkDoa(database: database, id: id);
      emit(StatusBookmarkSuccess(_counter++));
      getBookmarkDoa();
    } catch (e) {
      print(e);
    }
  }

  Future<void> getBookmarkDoa() async {
    try {
      emit(ListDoaLoading());
      listdoa = await doaRepo.getBookmarkDoa(database: database);
      if(listdoa.isNotEmpty) {
        emit(ListDoaSuccess(listdoa));
      } else {
        emit(ListDoaLoading());
      }
    } catch(e) {
      print(e);
    }
  }
}
