import 'package:Quranku/screens/jadwal_shalat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../screens/home_page.dart';
import '../baca/baca_cubit.dart';
import '../waktu_shalat/waktu_shalat_cubit.dart';
import 'database_cubit.dart';

class DatabaseCubicLogic extends StatefulWidget {
  const DatabaseCubicLogic({super.key});

  @override
  State<DatabaseCubicLogic> createState() => _DatabaseCubicLogicState();
}

class _DatabaseCubicLogicState extends State<DatabaseCubicLogic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DatabaseCubit, DatabaseState>(
          builder: (context, state) {
            if (state is LoadDatabaseState) {
              return HomePage();
            }
            else {
              return Container();
            }
          }
      ),
    );
  }
}
