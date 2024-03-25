import 'package:Quranku/cubit/waktu_shalat/waktu_shalat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/baca/baca_cubit.dart';
import 'cubit/database/database_logic.dart';
import 'cubit/database/database_cubit.dart';

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
            BlocProvider<BacaCubit>(
              create: (context) => BacaCubit(database: context.read<DatabaseCubit>().database!)..getRandomAyat(),
            ),
            BlocProvider<WaktuShalatCubit>(
              create: (context) => WaktuShalatCubit(database: context.read<DatabaseCubit>().database!)..getWaktuShalat(),
            ),
          ],
          child: DatabaseCubicLogic(),
        )
    );
  }
}

