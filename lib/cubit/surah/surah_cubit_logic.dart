import 'package:Quranku/cubit/surah/surah_cubit.dart';
import 'package:Quranku/ui/baca_surah_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ui/home_page.dart';
import '../database/database_cubit.dart';

class SurahCubitLogic extends StatefulWidget {
  const SurahCubitLogic({super.key});

  @override
  State<SurahCubitLogic> createState() => _SurahCubitLogicState();
}

class _SurahCubitLogicState extends State<SurahCubitLogic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SurahCubit, SurahState>(
          builder: (context, state) {
            if (state is BacaSurahSuccess) {
              return BacaSurahPage();
            }
            if (state is ListSurahSuccess) {
              return HomePage();
            } else {
              return Container();
            }
          }
      ),
    );
  }
}
