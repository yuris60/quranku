import 'package:Quranku/screens/quran_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../cubit/baca/baca_cubit.dart';
import '../cubit/database/database_cubit.dart';
import '../cubit/database/database_logic.dart';
import '../cubit/halaman/halaman_cubit.dart';
import '../cubit/juz/juz_cubit.dart';
import '../cubit/surah/surah_cubit.dart';
import '../cubit/waktu_shalat/waktu_shalat_cubit.dart';

import '../constants.dart';

class CoreLeading extends StatefulWidget {
  final int? page;
  final Color? color;
  const CoreLeading({this.page, this.color});

  @override
  State<CoreLeading> createState() => _CoreLeadingState();
}

class _CoreLeadingState extends State<CoreLeading> {

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    if(widget.page!.toString()=="1") {
      return IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return MultiBlocProvider(
                  providers: [
                    BlocProvider<DatabaseCubit>(
                      create: (context) => DatabaseCubit()..initDB(),
                    ),
                    BlocProvider<SurahCubit>(
                      create: (context) => SurahCubit(database: context.read<DatabaseCubit>().database!)..getListSurah(),
                    ),
                    BlocProvider<BacaCubit>(
                      create: (context) => BacaCubit(database: context.read<DatabaseCubit>().database!)..getKhatamQuran(),
                    ),
                    BlocProvider<JuzCubit>(
                      create: (context) => JuzCubit(database: context.read<DatabaseCubit>().database!)..getListJuz(),
                    ),
                    BlocProvider<HalamanCubit>(
                      create: (context) => HalamanCubit(database: context.read<DatabaseCubit>().database!)..getListHalaman(),
                    ),
                  ],
                  child: QuranPage(),
                );
              },
            ),
          );
        },
        icon: Icon(Icons.arrow_back_ios, color: widget.color),
      ); // QURAN PAGE
    } else if(widget.page!.toString()=="0") {
      return IconButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return MultiBlocProvider(
                  providers: [
                    BlocProvider<DatabaseCubit>(create: (context) => DatabaseCubit()..initDB(),
                    ),
                    BlocProvider<BacaCubit>(
                      create: (context) => BacaCubit(database: context.read<DatabaseCubit>().database!)..getRandomAyat(),
                    ),
                    BlocProvider<WaktuShalatCubit>(
                      create: (context) => WaktuShalatCubit(database: context.read<DatabaseCubit>().database!)..getWaktuShalat(),
                    ),
                  ],
                  child: DatabaseCubicLogic(),
                );
              },
            ),
          );
        },
        icon: Icon(Icons.arrow_back_ios, color: widget.color),
      ); // HOME PAGE
    } else {
      return Container();
    }
  }
}