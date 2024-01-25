import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/halaman_model.dart';
import 'database_cubit.dart';

part 'halaman_state.dart';

class ListHalamanCubit extends Cubit<HalamanState> {
  ListHalamanCubit() : super(ListHalamanInitial());

  final dbProvider  = DatabaseCubit.dbProvider;

  Future getListHalaman() async {
    emit(ListHalamanLoading());
    final db = await dbProvider.database;
    final result = await db.rawQuery('SELECT halaman.*, surah.nama_surah FROM halaman JOIN surah ON surah.id = halaman.id_surah_mulai');
    // return result.map((json) => ListJuzModel.fromMap(json)).toList();
    emit(ListHalamanSuccess(listhalaman: result.map((json) => ListHalamanModel.fromMap(json)).toList()));
  }
}
