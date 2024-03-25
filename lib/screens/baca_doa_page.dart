import 'package:Quranku/cubit/baca/baca_cubit.dart';
import 'package:arabic_font/arabic_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants.dart';
import '../cubit/database/database_cubit.dart';

class BacaDoaPage extends StatefulWidget {
  const BacaDoaPage({super.key});

  @override
  State<BacaDoaPage> createState() => _BacaDoaPageState();
}

class _BacaDoaPageState extends State<BacaDoaPage> {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      appBar: AppBar(
        title: Text("Doa Sehari-Hari", style: TextStyle(color: Colors.white, fontSize: 18*ffem),),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Palette.primary,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(15*fem),
            child: SizedBox(
                width: 24*fem,
                height: 24*fem,
                child: Image.asset("assets/image/logo_quranku_new_white.png")
            ),
          )
        ],
      ),
      body: BlocBuilder<DatabaseCubit, DatabaseState>(
        builder: (context, state) {
          if(state is LoadDatabaseState) {
            return Container(
              width: double.infinity,
              child: RawScrollbar(
                thickness: 5,
                thumbColor: Palette.primary,
                child: SingleChildScrollView(
                  child: BlocBuilder<BacaCubit, BacaState>(
                    builder: (context, state) {
                      if(state is BacaDoaSuccess) {
                        return ListView.builder(
                          physics: ScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: state.doabaca.length,
                          itemBuilder: (context, index) {
                            final doa = state.doabaca[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(20*fem, 30*fem, 20*fem, 30*fem),
                                  width: double.infinity,
                                  height: 130*fem,
                                  decoration: BoxDecoration(
                                    // borderRadius: BorderRadius.all(Radius.circular(10 * fem)),
                                    color: Palette.primary,
                                    image: DecorationImage(
                                      image: AssetImage("assets/image/banner_doa.jpg"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 180*fem,
                                        child: Text(doa.nama_doa!, style: TextStyle(color: Colors.white, fontSize: 20 * ffem, fontWeight: FontWeight.bold),)
                                      ),
                                    ],
                                  ),
                                ),
                                Image.asset("assets/image/bismillah_header.jpg"),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.fromLTRB(10*fem, 20*fem, 10*fem, 13*fem),
                                  child: Text(
                                    doa.ayat_doa!,
                                    style: ArabicTextStyle(
                                        arabicFont: ArabicFont.scheherazade,
                                        fontSize: 40 * ffem,
                                        height: 1.4*fem
                                    ),
                                    textAlign: TextAlign.end,
                                    softWrap: true,
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.fromLTRB(10*fem, 20*fem, 10*fem, 0),
                                  color: Palette.primary.withOpacity(0.05),
                                  child: Text(doa.latin_doa!, style: TextStyle(fontSize: 14*ffem, color: Palette.primary),)
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.fromLTRB(10*fem, 10*fem, 10*fem, 20*fem),
                                  color: Palette.primary.withOpacity(0.05),
                                  child: Text(doa.arti_doa!, style: TextStyle(fontSize: 14*ffem),)
                                ),
                              ],
                            );
                          }
                        );
                      } else {
                        return Container();
                      }
                    }
                  ),
                ),
              ),
            );
          } else {
            return Container();
          }
        }
      ),
    );
  }
}
