import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants.dart';
import '../cubit/baca/baca_cubit.dart';
import '../cubit/database/database_cubit.dart';
import '../cubit/surah/surah_cubit.dart';
import '../screens/baca_surah_page.dart';

class ConfirmDialog extends StatelessWidget {
  final int? id_ayat;
  final int? id_surah;
  final int? no_ayat;
  final String? nama_surah;
  const ConfirmDialog({this.id_ayat, this.id_surah, this.nama_surah, this.no_ayat});

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10*fem)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        height: 140*fem,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10*fem)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Tandai ayat ini sebagai terakhir dibaca?", style: TextStyle(fontSize: 14*ffem),),
            SizedBox(height: 8*fem,),
            Text("Q.S. " + nama_surah! + ":" + no_ayat!.toString(), style: TextStyle(fontFamily: "Inter Bold", fontSize: 18*ffem),),
            SizedBox(height: 8*fem,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.info,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10*fem))
                      ),
                      padding: EdgeInsets.all(10*fem),
                    ),
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return MultiBlocProvider(
                              providers: [
                                BlocProvider<DatabaseCubit>(
                                  create: (context) => DatabaseCubit()..initDB(),
                                ),
                                BlocProvider<BacaCubit>(
                                  create: (context) => BacaCubit(database: context.read<DatabaseCubit>().database!)..setKhatamQuran(id_ayat!.toString(), id_surah!.toString()),
                                ),
                                BlocProvider<SurahCubit>(
                                  create: (context) => SurahCubit(database: context.read<DatabaseCubit>().database!)..getSurah(id_surah!.toString()),
                                ),
                              ],
                              child: BacaSurahPage(),
                            );
                          },
                        ),
                      );// To close the dialog
                    },
                    child: Text("Ya", style: TextStyle(color: Colors.white)),
                  ),
                ),
                SizedBox(width: 10*fem),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.greys,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10*fem))
                      ),
                      padding: EdgeInsets.all(10*fem),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // To close the dialog
                    },
                    child: Text("Tidak", style: TextStyle(color: Colors.white)),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

