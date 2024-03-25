import 'dart:async';

import 'package:Quranku/cubit/waktu_shalat/waktu_shalat_cubit.dart';
import 'package:Quranku/screens/bookmark_page.dart';
import 'package:Quranku/screens/jadwal_shalat_page.dart';
import 'package:Quranku/utils/tglindo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

import '../cubit/baca/baca_cubit.dart';
import '../cubit/doa/doa_cubit.dart';
import '../cubit/surah/surah_cubit.dart';
import '../cubit/juz/juz_cubit.dart';
import '../cubit/halaman/halaman_cubit.dart';

import '../constants.dart';
import '../widget/core_drawer.dart';

import '../widget/core_title.dart';
import 'doa_page.dart';
import 'quran_page.dart';

import '../cubit/database/database_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _hariini;

  @override
  void initState() {
    _hariini = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _hariini = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return formatTglIndo(dateTime.toString());
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      appBar: AppBar(
        title: CoreTitle(title: "QURANKU", color: Colors.black, fontsize: 18),
        centerTitle: true,
        iconTheme: IconThemeData(color: Palette.black),
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: SizedBox(
                  height: 22*fem,
                  width: 22*fem,
                  child: Image.asset("assets/image/menu.png")
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          }
        ),
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: (){
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
                          create: (context) => SurahCubit(database: context.read<DatabaseCubit>().database!)..getBookmarkSurah(),
                        ),
                        BlocProvider<DoaCubit>(
                          create: (context) => DoaCubit(database: context.read<DatabaseCubit>().database!)..getBookmarkDoa(),
                        ),
                      ],
                      child: BookmarkPage(),
                    );
                  },
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(15*fem),
              child: Icon(FontAwesomeIcons.heart, size: 20*ffem,)
            ),
          ),
        ],
      ),
      drawer: CoreDrawer(),
      // endDrawer: Icon(Icons.heart_broken),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(15*fem, 10*fem, 15*fem, 10*fem),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              wTanggal(),
              wHeader(),
              wRandomAyat(),
              wWaktuShalat(),
              wFiturFitur()
            ],
          ),
        ),
      ),
    );
  }

  Widget wTanggal(){
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_hariini! + ' M', style: TextStyle(fontFamily: "Inter Bold", fontSize: 16*ffem)),
        Text(HijriCalendar.now().hDay.toString() + " " + HijriCalendar.now().getLongMonthName().toString() + " " + HijriCalendar.now().hYear.toString() + ' H', style: TextStyle(fontSize: 16*ffem)),
      ],
    );
  }

  Widget wHeader(){
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(0*fem, 10*fem, 0*fem, 0),
      padding: EdgeInsets.fromLTRB(10*fem, 50*fem, 10*fem, 50*fem),
      decoration: BoxDecoration(
        color: Palette.primary,
        borderRadius: BorderRadius.circular(10*fem),
        image: DecorationImage(
            image: AssetImage("assets/image/banner_home.png"),
            fit: BoxFit.cover
        ),
      ),
      child: Column(
        children: [
          Text(DateFormat("HH:mm").format(DateTime.now()), style: TextStyle(fontFamily: "Inter Bold", fontSize: 50*ffem, color: Colors.white),),
          // Text("1 jam 20 menit menjelang Shalat Dzuhur", style: TextStyle(fontSize: 14*ffem, color: Colors.white),)
        ],
      ),
    );
  }

  Widget wRandomAyat(){
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.fromLTRB(0*fem, 20*fem, 0*fem, 0*fem),
            child: Text("Random Ayat", style: TextStyle(fontSize: 16*ffem, fontFamily: "Inter Bold", color: Palette.black),)
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10*fem, 10*fem, 10*fem, 10*fem),
          margin: EdgeInsets.fromLTRB(0*fem, 10*fem, 0*fem, 0*fem),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10*fem)
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10*fem),
                height: 75*fem,
                width: 75*fem,
                decoration: BoxDecoration(
                    color: Palette.secondary,
                    borderRadius: BorderRadius.circular(10*fem)
                ),
                child: Image.asset("assets/image/quran.png"),
              ),
              SizedBox(width: 10*fem,),
              BlocBuilder<BacaCubit, BacaState>(
                  builder: (context, state){
                    if(state is RandomAyatSuccess){
                      return Expanded(
                        child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: state.ayatoftheday.length,
                            itemBuilder: (context, index){
                              final ayat = state.ayatoftheday[index];
                              return Container(
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(ayat.indo_text!, style: TextStyle(fontSize: 13*ffem),),
                                    SizedBox(height: 5*fem,),
                                    Text("(Q.S. " + ayat.nama_surah! + ":" + ayat.no_ayat!.toString() + ")", style: TextStyle(fontSize: 13*ffem, fontFamily: "Inter Bold"),)
                                  ],
                                ),
                              );
                            }
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget wWaktuShalat(){
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.fromLTRB(0*fem, 20*fem, 0*fem, 0*fem),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Waktu Shalat", style: TextStyle(fontSize: 16*ffem, fontFamily: "Inter Bold", color: Palette.black),),
                GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return MultiBlocProvider(
                              providers: [
                                BlocProvider<DatabaseCubit>(
                                  create: (context) => DatabaseCubit()..initDB(),
                                ),
                                BlocProvider<WaktuShalatCubit>(
                                  create: (context) => WaktuShalatCubit(database: context.read<DatabaseCubit>().database!)..getWaktuShalat(),
                                ),
                              ],
                              child: JadwalShalatPage(),
                            );
                          },
                        ),
                      ).then((value) {
                        setState(() {

                        });
                      });
                    },
                    child: Icon(FontAwesomeIcons.arrowRightLong, color: Colors.black,)
                )
              ],
            )
        ),
        Container(
            margin: EdgeInsets.fromLTRB(0*fem, 10*fem, 0*fem, 20*fem),
            child: BlocBuilder<WaktuShalatCubit, WaktuShalatState>(
                builder: (context, state) {
                  if(state is WaktuShalatSuccess){
                    return ListView.builder(
                        physics: ScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: state.waktushalat.length,
                        itemBuilder: (context, index){
                          final waktushalat = state.waktushalat[index];
                          return Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Container(
                                      height: 80*fem,
                                      width: 100*fem,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(10*fem)),
                                          image: DecorationImage(
                                              image: AssetImage("assets/image/waktu_shalat_subuh.png"),
                                              fit: BoxFit.fill
                                          )
                                      ),
                                      child: Align(
                                          alignment: Alignment.topRight,
                                          child: Padding(
                                            padding: EdgeInsets.all(4*fem),
                                            child: SizedBox(
                                              height: 22*fem,
                                              width: 22*fem,
                                              child: CircleAvatar(
                                                backgroundColor: waktushalat.subuh_cek==1? Palette.success : Palette.dangers,
                                                child: Center(
                                                  child: waktushalat.subuh_cek==1?Icon(FontAwesomeIcons.check, color: Colors.white, size: 16*ffem,):Icon(FontAwesomeIcons.times, color: Colors.white, size: 16*ffem,),
                                                ),
                                              ),
                                            ),
                                          )
                                      ),
                                    ),
                                    SizedBox(height: 3*fem,),
                                    Text("Subuh", style: TextStyle(fontSize: 13*ffem, fontFamily: "Inter Bold"),),
                                    Text(waktushalat.subuh!.substring(0,5), style: TextStyle(fontSize: 13*ffem),),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8*fem,),
                              Expanded(
                                child: Column(
                                  children: [
                                    Container(
                                      height: 80*fem,
                                      width: 100*fem,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(10*fem)),
                                          image: DecorationImage(
                                              image: AssetImage("assets/image/waktu_shalat_dzuhur.png"),
                                              fit: BoxFit.fill
                                          )
                                      ),
                                      child: Align(
                                          alignment: Alignment.topRight,
                                          child: Padding(
                                            padding: EdgeInsets.all(4*fem),
                                            child: SizedBox(
                                              height: 22*fem,
                                              width: 22*fem,
                                              child: CircleAvatar(
                                                backgroundColor: waktushalat.dzuhur_cek==1? Palette.success : Palette.dangers,
                                                child: Center(
                                                  child: waktushalat.dzuhur_cek==1?Icon(FontAwesomeIcons.check, color: Colors.white, size: 16*ffem,):Icon(FontAwesomeIcons.times, color: Colors.white, size: 16*ffem,),
                                                ),
                                              ),
                                            ),
                                          )
                                      ),
                                    ),
                                    SizedBox(height: 3*fem,),
                                    Text("Dzuhur", style: TextStyle(fontSize: 13*ffem, fontFamily: "Inter Bold"),),
                                    Text(waktushalat.dzuhur!.substring(0,5), style: TextStyle(fontSize: 13*ffem),),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8*fem,),
                              Expanded(
                                child: Column(
                                  children: [
                                    Container(
                                      height: 80*fem,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(10*fem)),
                                          image: DecorationImage(
                                              image: AssetImage("assets/image/waktu_shalat_ashar.png"),
                                              fit: BoxFit.fill
                                          )
                                      ),
                                      child: Align(
                                          alignment: Alignment.topRight,
                                          child: Padding(
                                            padding: EdgeInsets.all(4*fem),
                                            child: SizedBox(
                                              height: 22*fem,
                                              width: 22*fem,
                                              child: CircleAvatar(
                                                backgroundColor: waktushalat.ashar_cek==1? Palette.success : Palette.dangers,
                                                child: Center(
                                                  child: waktushalat.ashar_cek==1?Icon(FontAwesomeIcons.check, color: Colors.white, size: 16*ffem,):Icon(FontAwesomeIcons.times, color: Colors.white, size: 16*ffem,),
                                                ),
                                              ),
                                            ),
                                          )
                                      ),
                                    ),
                                    SizedBox(height: 3*fem,),
                                    Text("Ashar", style: TextStyle(fontSize: 13*ffem, fontFamily: "Inter Bold"),),
                                    Text(waktushalat.ashar!.substring(0,5), style: TextStyle(fontSize: 13*ffem),),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8*fem,),
                              Expanded(
                                child: Column(
                                  children: [
                                    Container(
                                      height: 80*fem,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(10*fem)),
                                          image: DecorationImage(
                                              image: AssetImage("assets/image/waktu_shalat_magrib.png"),
                                              fit: BoxFit.fill
                                          )
                                      ),
                                      child: Align(
                                          alignment: Alignment.topRight,
                                          child: Padding(
                                            padding: EdgeInsets.all(4*fem),
                                            child: SizedBox(
                                              height: 22*fem,
                                              width: 22*fem,
                                              child: CircleAvatar(
                                                backgroundColor: waktushalat.magrib_cek==1? Palette.success : Palette.dangers,
                                                child: Center(
                                                  child: waktushalat.magrib_cek==1?Icon(FontAwesomeIcons.check, color: Colors.white, size: 16*ffem,):Icon(FontAwesomeIcons.times, color: Colors.white, size: 16*ffem,),
                                                ),
                                              ),
                                            ),
                                          )
                                      ),
                                    ),
                                    SizedBox(height: 3*fem,),
                                    Text("Magrib", style: TextStyle(fontSize: 13*ffem, fontFamily: "Inter Bold"),),
                                    Text(waktushalat.magrib!.substring(0,5), style: TextStyle(fontSize: 13*ffem),),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8*fem,),
                              Expanded(
                                child: Column(
                                  children: [
                                    Container(
                                      height: 80*fem,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(10*fem)),
                                          image: DecorationImage(
                                              image: AssetImage("assets/image/waktu_shalat_isya.png"),
                                              fit: BoxFit.fill
                                          )
                                      ),
                                      child: Align(
                                          alignment: Alignment.topRight,
                                          child: Padding(
                                            padding: EdgeInsets.all(4*fem),
                                            child: SizedBox(
                                              height: 22*fem,
                                              width: 22*fem,
                                              child: CircleAvatar(
                                                backgroundColor: waktushalat.isya_cek==1? Palette.success : Palette.dangers,
                                                child: Center(
                                                  child: waktushalat.isya_cek==1?Icon(FontAwesomeIcons.check, color: Colors.white, size: 16*ffem,):Icon(FontAwesomeIcons.times, color: Colors.white, size: 16*ffem,),
                                                ),
                                              ),
                                            ),
                                          )
                                      ),
                                    ),
                                    SizedBox(height: 3*fem,),
                                    Text("Isya", style: TextStyle(fontSize: 13*ffem, fontFamily: "Inter Bold"),),
                                    Text(waktushalat.isya!.substring(0,5), style: TextStyle(fontSize: 13*ffem),),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                    );
                  } else {
                    return Container();
                  }
                }
            )
        ),
      ],
    );
  }

  Widget wFiturFitur(){
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 0*fem),
            child: Text("Fitur-Fitur", style: TextStyle(fontSize: 16*ffem, fontFamily: "Inter Bold", color: Palette.black),)
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0*fem, 10*fem, 0*fem, 0*fem),
          child: Column(
            children: [
              GestureDetector(
                onTap: (){
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
                child: Container(
                  margin: EdgeInsets.only(bottom: 8*fem),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10*fem),
                    color: Colors.white,
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 40*fem,
                      height: 40*fem,
                      decoration: BoxDecoration(
                          color: Palette.primary,
                          borderRadius: BorderRadius.circular(5*fem)
                      ),
                      child: Icon(FontAwesomeIcons.bookQuran, color: Colors.white, size: 20*ffem,),
                    ),
                    title: Text("Baca Quran", style: TextStyle(fontFamily: "Inter Bold"),),
                    trailing: Icon(Icons.arrow_circle_right, size: 24*ffem, color: Colors.black,),
                    subtitle: Text("Total: 30 Juz, 114 Surah, 6236 Ayat", style: TextStyle(fontSize: 11*ffem),),
                    contentPadding: EdgeInsets.fromLTRB(10*fem, 0, 10*fem, 0),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return MultiBlocProvider(
                          providers: [
                            BlocProvider<DatabaseCubit>(
                              create: (context) => DatabaseCubit()..initDB(),
                            ),
                            BlocProvider<DoaCubit>(
                              create: (context) => DoaCubit(database: context.read<DatabaseCubit>().database!)..getListDoa(),
                            ),
                          ],
                          child: DoaPage(),
                        );
                      },
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 8*fem),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10*fem),
                    color: Colors.white,
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 40*fem,
                      height: 40*fem,
                      decoration: BoxDecoration(
                          color: Palette.secondary,
                          borderRadius: BorderRadius.circular(5*fem)
                      ),
                      child: Icon(FontAwesomeIcons.handsPraying, color: Colors.white, size: 20*ffem,),
                    ),
                    title: Text("Doa Sehari-hari", style: TextStyle(fontFamily: "Inter Bold"),),
                    trailing: Icon(Icons.arrow_circle_right, size: 24*ffem, color: Colors.black,),
                    subtitle: Text("Total: 37 Doa", style: TextStyle(fontSize: 11*ffem),),
                    contentPadding: EdgeInsets.fromLTRB(10*fem, 0, 10*fem, 0),
                  ),
                ),
              ),

              // GestureDetector(
              //   onTap: (){
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) {
              //           return MultiBlocProvider(
              //             providers: [
              //               BlocProvider<DatabaseCubit>(
              //                 create: (context) => DatabaseCubit()..initDB(),
              //               ),
              //               BlocProvider<SurahCubit>(
              //                 create: (context) => SurahCubit(database: context.read<DatabaseCubit>().database!)..getListSurah(),
              //               ),
              //               BlocProvider<JuzCubit>(
              //                 create: (context) => JuzCubit(database: context.read<DatabaseCubit>().database!)..getListJuz(),
              //               ),
              //               BlocProvider<HalamanCubit>(
              //                 create: (context) => HalamanCubit(database: context.read<DatabaseCubit>().database!)..getListHalaman(),
              //               ),
              //             ],
              //             child: QuranPage(),
              //           );
              //         },
              //       ),
              //     );
              //   },
              //   child: Container(
              //     margin: EdgeInsets.only(bottom: 8*fem),
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(10*fem),
              //       color: Colors.white,
              //     ),
              //     child: ListTile(
              //       leading: Container(
              //         width: 40*fem,
              //         height: 40*fem,
              //         decoration: BoxDecoration(
              //             color: Palette.primary,
              //             borderRadius: BorderRadius.circular(5*fem)
              //         ),
              //         child: Icon(FontAwesomeIcons.bookQuran, color: Colors.white, size: 20*ffem,),
              //       ),
              //       title: Text("Kumpulan Hadits", style: TextStyle(fontFamily: "Inter Bold"),),
              //       trailing: Icon(Icons.arrow_circle_right, size: 24*ffem, color: Colors.black,),
              //       subtitle: Text("Total: ", style: TextStyle(fontSize: 11*ffem),),
              //       contentPadding: EdgeInsets.fromLTRB(10*fem, 0, 10*fem, 0),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}