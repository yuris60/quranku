import 'package:Quranku/cubit/database_cubit.dart';
import 'package:flutter/material.dart';
import 'package:Quranku/ui/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/surah_cubit.dart';

void main() {
  runApp(BlocProvider(
    create: (context) =>
    DatabaseCubit()
      ..initDB(),
    child: const QurankuApp(),
  ));
}

class QurankuApp extends StatefulWidget {
  const QurankuApp({super.key});

  @override
  State<QurankuApp> createState() => _QurankuAppState();
}

class _QurankuAppState extends State<QurankuApp> {

  SurahCubit? _surah;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => _surah!..getListSurah(),),
        BlocProvider(create: (context) => _surah!..getBacaSurah("1"),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: 'Inter'
        ),
        home: HomePage(),
      ),
    );
  }
}

