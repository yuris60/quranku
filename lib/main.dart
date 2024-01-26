import 'package:Quranku/cubit/database/database_cubit_logic.dart';
import 'package:Quranku/cubit/database/database_cubit.dart';
import 'package:flutter/material.dart';
import 'package:Quranku/ui/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/halaman/halaman_cubit.dart';
import 'cubit/juz/juz_cubit.dart';
import 'cubit/surah/surah_cubit.dart';

void main() {
  runApp(const QurankuApp());
}

class QurankuApp extends StatefulWidget {
  const QurankuApp({super.key});

  @override
  State<QurankuApp> createState() => _QurankuAppState();
}

class _QurankuAppState extends State<QurankuApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: 'Inter'
        ),
        home: MultiBlocProvider(
          providers: [
            BlocProvider<DatabaseCubit>(
              create: (context) => DatabaseCubit()..initDB(),
            ),
            BlocProvider<SurahCubit>(
              create: (context) => SurahCubit(database: context.read<DatabaseCubit>().database!)..getListSurah(),
            ),
            BlocProvider<JuzCubit>(
              create: (context) => JuzCubit(database: context.read<DatabaseCubit>().database!)..getListJuz(),
            ),
            BlocProvider<HalamanCubit>(
              create: (context) => HalamanCubit(database: context.read<DatabaseCubit>().database!)..getListHalaman(),
            ),
          ],
          child: DatabaseCubicLogic(),
        )
    );
  }
}

