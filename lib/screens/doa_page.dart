import 'package:Quranku/cubit/database/database_cubit.dart';
import 'package:Quranku/cubit/database/database_logic.dart';
import 'package:Quranku/screens/baca_doa_page.dart';
import 'package:Quranku/widget/core_leading.dart';
import 'package:Quranku/widget/core_title.dart';
import 'package:arabic_font/arabic_font.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants.dart';
import '../cubit/baca/baca_cubit.dart';
import '../cubit/doa/doa_cubit.dart';

class DoaPage extends StatefulWidget {
  const DoaPage({super.key});

  @override
  State<DoaPage> createState() => _DoaPageState();
}

class _DoaPageState extends State<DoaPage> {
  final arabicNumber = ArabicNumbers();

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      appBar: AppBar(
        title: CoreTitle(title: "Doa Sehari-Hari", color: Colors.black, fontsize: 18),
        centerTitle: true,
        iconTheme: IconThemeData(color: Palette.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: CoreLeading(page: 0, color: Colors.black),
        actions: [
          Padding(
            padding: EdgeInsets.all(15*fem),
            child: SizedBox(
              width: 24*fem,
              height: 24*fem,
              child: Image.asset("assets/image/logo_quranku_new_black.png")
            ),
          )
        ],
      ),
      body: BlocBuilder<DatabaseCubit, DatabaseState>(
        builder: (context, state) {
          if(state is LoadDatabaseState) {
            return Container(
              width: double.infinity,
              child: Column(
                children: [
                  wHeader(),
                  wListDoa(),
                ],
              ),
            );
          } else {
            return Container();
          }
        }
      ),
    );
  }

  Widget wHeader(){
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(15*fem, 10*fem, 15*fem, 15*fem),
      padding: EdgeInsets.fromLTRB(15*fem, 20*fem, 15*fem, 20*fem),
      decoration: BoxDecoration(
        color: Palette.primary,
        borderRadius: BorderRadius.circular(10*fem),
        image: DecorationImage(
            image: AssetImage("assets/image/banner_home.png"),
            fit: BoxFit.cover
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Doa Sehari-Hari", style: TextStyle(fontSize: 22*ffem, fontFamily: "Inter Bold", color: Colors.white),),
          SizedBox(
              height: 75*fem,
              width: 75*fem,
              child: Image.asset("assets/image/doa.png")
          ),
        ],
      ),
    );
  }

  Widget wListDoa(){
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Expanded(
      child: RawScrollbar(
        thumbColor: Palette.primary,
        thickness: 5,
        child: SingleChildScrollView(
          child: BlocBuilder<DoaCubit, DoaState> (
            builder: (context, statedoa) {
              if(statedoa is ListDoaSuccess) {
                return ListView.builder(
                    padding: EdgeInsets.only(top: 5*fem),
                    physics: ScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: statedoa.listdoa.length,
                    itemBuilder: (context, index) {
                      final doa = statedoa.listdoa[index];
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
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
                                          create: (context) => BacaCubit(database: context.read<DatabaseCubit>().database!)..getBacaDoa(doa.id!.toString()),
                                        ),
                                      ],
                                      child: BacaDoaPage(),
                                    );
                                  },
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 13*fem),
                              padding: EdgeInsets.fromLTRB(0*fem, 0, 0*fem, 0),
                              child: Row(
                                children: [
                                  Container(
                                    height: 50*fem,
                                    width: 40*fem,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: 0,
                                          left: 17*fem,
                                          child:
                                          Container(
                                            height: 50*fem,
                                            width: 7*fem,
                                            decoration: BoxDecoration(
                                              // color: (surah.id!%2==1)?Palette.primary : Palette.secondary,
                                                color: Palette.primary,
                                                borderRadius: BorderRadius.circular(5*fem)
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 13*fem,
                                          left: 8*fem,
                                          child: SizedBox(
                                              width: 25*fem,
                                              height: 25*fem,
                                              child: (doa.is_bookmark==0) ?
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) {
                                                        return MultiBlocProvider(
                                                          providers: [
                                                            BlocProvider<DatabaseCubit>(
                                                              create: (context) => DatabaseCubit()..initDB(),
                                                            ),
                                                            BlocProvider<DoaCubit>(
                                                              create: (context) => DoaCubit(database: context.read<DatabaseCubit>().database!)..setAddBoorkmarkDoa(doa.id!.toString()),
                                                            ),
                                                          ],
                                                          child: DoaPage(),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  child: CircleAvatar(
                                                    backgroundColor: Colors.white,
                                                    child: Icon(FontAwesomeIcons.solidHeart, size: 16*ffem, color: Colors.grey),
                                                  ),
                                                ),
                                              )
                                                  :
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) {
                                                        return MultiBlocProvider(
                                                          providers: [
                                                            BlocProvider<DatabaseCubit>(
                                                              create: (context) => DatabaseCubit()..initDB(),
                                                            ),
                                                            BlocProvider<DoaCubit>(
                                                              create: (context) => DoaCubit(database: context.read<DatabaseCubit>().database!)..setRemoveBoorkmarkDoa(doa.id!.toString()),
                                                            ),
                                                          ],
                                                          child: DoaPage(),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  child: CircleAvatar(
                                                    backgroundColor: Colors.white,
                                                    child: Icon(FontAwesomeIcons.solidHeart, size: 16*ffem, color: Palette.dangers),
                                                  ),
                                                ),
                                              )
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 0*fem,),
                                  Container(
                                    width: 305*fem,
                                    padding: EdgeInsets.fromLTRB(10*fem, 5*fem, 10*fem, 5*fem),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10*fem),
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //     color: Colors.grey,
                                      //     offset: Offset(
                                      //       0.1*fem, 0.1*fem,
                                      //     ),
                                      //     blurRadius: 1*fem
                                      //   )
                                      // ]
                                    ),
                                    child: Row(
                                      children: [
                                        Stack(
                                          fit: StackFit.loose,
                                          children: [
                                            Image.asset("assets/image/frame.png", height: 40*fem),
                                            SizedBox(
                                              width: 40*fem,
                                              height: 40*fem,
                                              child: Text(
                                                  arabicNumber.convert(doa.id!.toString()),
                                                  style: ArabicTextStyle(
                                                    arabicFont: ArabicFont.scheherazade,
                                                    fontSize: (doa.id!.toString().length >= 3) ? 22*ffem : 24*fem,
                                                    letterSpacing: -2,
                                                  ),
                                                  textAlign: TextAlign.center
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(width: 10*fem,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 215*fem,
                                              child: Text(doa.nama_doa!, style: TextStyle(fontFamily: 'Inter Bold', fontSize: 14*ffem), maxLines: 4,),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    }
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
