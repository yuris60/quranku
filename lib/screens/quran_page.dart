import 'package:Quranku/screens/quran_searh_form_page.dart';
import 'package:Quranku/widget/core_leading.dart';
import 'package:arabic_font/arabic_font.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../constants.dart';

import '../cubit/baca/baca_cubit.dart';
import '../cubit/database/database_logic.dart';
import '../cubit/surah/surah_cubit.dart';
import '../cubit/juz/juz_cubit.dart';
import '../cubit/halaman/halaman_cubit.dart';
import '../cubit/database/database_cubit.dart';

import '../cubit/waktu_shalat/waktu_shalat_cubit.dart';
import '../widget/core_title.dart';
import 'baca_juz_page.dart';
import 'baca_halaman_page.dart';
import 'baca_surah_page.dart';

class QuranPage extends StatefulWidget {
  const QuranPage({super.key});

  @override
  State<QuranPage> createState() => Baca_QuranPageState();
}

class Baca_QuranPageState extends State<QuranPage> {

  TextEditingController _searchcontroller = new TextEditingController();
  ScrollController _scrollController = ScrollController();
  final arabicNumber = ArabicNumbers();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              return MultiBlocProvider(
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
              );
            },
          ),
        );
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: CoreTitle(title: "Baca Quran", color: Colors.black, fontsize: 18),
          centerTitle: true,
          iconTheme: IconThemeData(color: Palette.black),
          backgroundColor: Colors.transparent,
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
                            create: (context) => SurahCubit(database: context.read<DatabaseCubit>().database!)..getListSurah(),
                          ),
                        ],
                        child: QuranSearchFormPage(),
                      );
                    },
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.all(15*fem),
                child: Icon(Icons.search, size: 24*ffem,)
              ),
            ),
          ],
          leading: CoreLeading(page: 0, color: Colors.black),
        ),
        body: BlocBuilder<DatabaseCubit, DatabaseState> (
          builder: (context, state) {
            if(state is LoadDatabaseState) {
              return Container(
                width: double.infinity,
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      Container(
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
                        child: BlocBuilder<BacaCubit, BacaState>(
                          builder: (context, state){
                            if(state is KhatamQuranSuccess){
                              return ListView.builder(
                                physics: ScrollPhysics(),
                                controller: _scrollController,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: state.khatamget.length,
                                itemBuilder: (context, index) {
                                  final surah = state.khatamget[index];
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Khatam Quran", style: TextStyle(fontSize: 22*ffem, fontFamily: "Inter Bold", color: Colors.white),),
                                          SizedBox(height: 10*fem,),
                                          Text("Terakhir Baca :", style: TextStyle(fontSize: 12*ffem, color: Colors.white),),
                                          SizedBox(height: 3*fem,),
                                          Text((surah.id!.toString()!='0')?"Q.S. " + surah.nama_surah! + ":" + surah.no_ayat!.toString() : "-", style: TextStyle(fontSize: 16*ffem, color: Colors.white),),
                                          SizedBox(height: 10*fem,),
                                          Container(
                                              width: 200*fem,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("Progress Khatam", style: TextStyle(fontSize: 14*ffem, color: Colors.white),),
                                                  Text((surah.id!.toString()!='0') ? ((surah.id!+1)/6236 * 100).toString().substring(0,5) + "%" : "0%", style: TextStyle(fontSize: 14*ffem, color: Colors.white),),
                                                ],
                                              )
                                          ),
                                          SizedBox(height: 3*fem,),
                                          Container(
                                            width: 200*fem,
                                            child: StepProgressIndicator(
                                              totalSteps: 6236,
                                              currentStep: surah.id!,
                                              size: 7*fem,
                                              padding: 0,
                                              selectedColor: Colors.yellow,
                                              unselectedColor: Colors.cyan,
                                              roundedEdges: Radius.circular(10),
                                              selectedGradientColor: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [Palette.third, Palette.secondary],
                                              ),
                                              unselectedGradientColor: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [Colors.black, Colors.black],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                          height: 75*fem,
                                          width: 75*fem,
                                          child: Image.asset("assets/image/quran.png")
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

                      Container(
                        width: double.infinity,
                        height: 35*fem,
                        margin: EdgeInsets.fromLTRB(15*fem, 0, 15*fem, 15*fem),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(50*fem)
                        ),
                        child: TabBar(
                          labelColor: Colors.white,
                          unselectedLabelColor: Palette.greys,
                          dividerColor: Palette.primary,
                          indicatorColor: Palette.primary,
                          indicatorSize: TabBarIndicatorSize.tab,
                          // indicatorPadding: EdgeInsets.only(top: 5*fem, bottom: 5*fem),
                          padding: EdgeInsets.zero,
                          indicator: BoxDecoration(
                            color: Palette.primary,
                            borderRadius: BorderRadius.circular(50*fem),
                          ),
                          labelStyle: TextStyle(color: Colors.white, fontSize: 16*ffem, fontWeight: FontWeight.bold),
                          tabs: [
                            Tab(text: "Surah"),
                            Tab(text: "Juz"),
                            Tab(text: "Halaman"),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            wKategoriSurah(),
                            wKategoriJuz(),
                            wKategoriHalaman()
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Container();
            }
          }
        )
      ),
    );
  }

  Widget wTabs(){
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 35*fem,
          margin: EdgeInsets.fromLTRB(15*fem, 0, 15*fem, 0),
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.25),
              borderRadius: BorderRadius.circular(50*fem)
          ),
          child: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Palette.greys,
            dividerColor: Palette.primary,
            indicatorColor: Palette.primary,
            indicatorSize: TabBarIndicatorSize.tab,
            // indicatorPadding: EdgeInsets.only(top: 5*fem, bottom: 5*fem),
            padding: EdgeInsets.zero,
            indicator: BoxDecoration(
              color: Palette.primary,
              borderRadius: BorderRadius.circular(50*fem),
            ),
            labelStyle: TextStyle(color: Colors.white, fontSize: 16*ffem, fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: "Surah"),
              Tab(text: "Juz"),
              Tab(text: "Halaman"),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            children: <Widget>[
              wKategoriSurah(),
              wKategoriJuz(),
              wKategoriHalaman()
            ],
          ),
        ),
      ],
    );
  }

  Widget wKategoriSurah(){
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return RawScrollbar(
      thickness: 5,
      thumbColor: Palette.primary,
      child: SingleChildScrollView(
        child: Column(
          children: [
            BlocBuilder<SurahCubit, SurahState>(
              builder: (context, state) {
                if (state is ListSurahLoading) {
                  return Container();
                }
                else if (state is ListSurahSuccess) {
                  return Container(
                    // margin: EdgeInsets.only(top: 10*fem),
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 5*fem),
                      physics: ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: state.surahlist.length,
                      itemBuilder: (context, index) {
                        final surah = state.surahlist[index];
                        return GestureDetector(
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
                                      BlocProvider<BacaCubit>(
                                        create: (context) => BacaCubit(database: context.read<DatabaseCubit>().database!)..getBacaSurah(surah.id!.toString()),
                                      ),
                                      BlocProvider<SurahCubit>(
                                        create: (context) => SurahCubit(database: context.read<DatabaseCubit>().database!)..getSurah(surah.id!.toString()),
                                      ),
                                    ],
                                    child: BacaSurahPage(),
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 13*fem),
                            padding: EdgeInsets.fromLTRB(0*fem, 0, 15*fem, 0),
                            child: Row(
                              children: [
                                Container(
                                  height: 68*fem,
                                  width: 40*fem,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 0,
                                        left: 17*fem,
                                        child:
                                        Container(
                                          height: 68*fem,
                                          width: 7*fem,
                                          decoration: BoxDecoration(
                                            // color: (surah.id!%2==1)?Palette.primary : Palette.secondary,
                                            color: Palette.primary,
                                            borderRadius: BorderRadius.circular(5*fem)
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top:22*fem,
                                        left: 8*fem,
                                        child: SizedBox(
                                          width: 25*fem,
                                          height: 25*fem,
                                          child: (surah.is_bookmark==0) ?
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
                                                        BlocProvider<SurahCubit>(
                                                          create: (context) => SurahCubit(database: context.read<DatabaseCubit>().database!)..setAddBoorkmarkSurah(surah.id!.toString()),
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
                                                        BlocProvider<SurahCubit>(
                                                          create: (context) => SurahCubit(database: context.read<DatabaseCubit>().database!)..setRemoveBoorkmarkSurah(surah.id!.toString()),
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
                                  width: 300*fem,
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
                                          // Image.asset((surah.id!%2==1)?"assets/image/frame.png":"assets/image/frame2.png", height: 50*fem),
                                          Image.asset("assets/image/frame.png", height: 50*fem),
                                          SizedBox(
                                            width: 50*fem,
                                            height: 50*fem,
                                            child: Text(
                                                arabicNumber.convert(surah.id!.toString()),
                                                style: ArabicTextStyle(
                                                  arabicFont: ArabicFont.scheherazade,
                                                  fontSize: (surah.id!.toString().length >= 3) ? 28*ffem : 30*fem,
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
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(surah.nama_surah!, style: TextStyle(fontFamily: 'Inter Bold', fontSize: 16*ffem)),
                                                Container(
                                                  padding: EdgeInsets.only(top: 5*fem),
                                                  child: Text(
                                                    surah.arabic!,
                                                    style: ArabicTextStyle(
                                                      arabicFont: ArabicFont.scheherazade,
                                                      fontWeight: FontWeight.bold,
                                                      // color: (surah.id!%2==1)?Palette.primary:Palette.secondary,
                                                      color: Palette.primary,
                                                      fontSize: 29*ffem,
                                                      height: 1*fem
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(bottom: 7*fem),
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.fromLTRB(7*fem, 3*fem, 7*fem, 3*fem),
                                                  margin: EdgeInsets.only(right: 5*fem),
                                                  child: Text(surah.arti!,
                                                    style: TextStyle(fontSize: 9*ffem, fontFamily: "Inter Medium",
                                                      // color: (surah.id!%2==1)?Palette.primary:Palette.secondary,
                                                      color: Palette.primary,
                                                    ),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    // color: (surah.id!%2==1)?Palette.primary.withOpacity(0.1):Palette.secondary.withOpacity(0.1),
                                                      color: Palette.primary.withOpacity(0.1),
                                                      borderRadius: BorderRadius.circular(10*fem)
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.fromLTRB(7*fem, 3*fem, 7*fem, 3*fem),
                                                  child: Text(surah.jml_ayat!.toString() + " Ayat",
                                                    style: TextStyle(fontSize: 9*ffem, fontFamily: "Inter Medium",
                                                      // color: (surah.id!%2==1)?Palette.primary:Palette.secondary,
                                                      color: Palette.primary,
                                                    ),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    // color: (surah.id!%2==1)?Palette.primary.withOpacity(0.1):Palette.secondary.withOpacity(0.1),
                                                      color: Palette.primary.withOpacity(0.1),
                                                      borderRadius: BorderRadius.circular(10*fem)
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget wKategoriJuz(){
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return RawScrollbar(
      thickness: 5,
      thumbColor: Palette.primary,
      child: SingleChildScrollView(
        child: BlocBuilder<JuzCubit, JuzState>(
          builder: (context, state) {
            if (state is ListJuzLoading) {
              return Container();
            }

            else if (state is ListJuzSuccess) {
              return Container(
                // margin: EdgeInsets.only(top: 10*fem),
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 5*fem),
                  physics: ScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: state.juzlist.length,
                  itemBuilder: (context, index) {
                    final juz = state.juzlist[index];
                    return GestureDetector(
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
                                  BlocProvider<BacaCubit>(
                                    create: (context) => BacaCubit(database: context.read<DatabaseCubit>().database!)..getBacaJuz(juz.id!.toString()),
                                  ),
                                ],
                                child: BacaJuzPage(id_juz: juz.id!.toString()),
                              );
                            },
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 13*fem),
                        padding: EdgeInsets.fromLTRB(15*fem, 0, 15*fem, 0),
                        child: Row(
                          children: [
                            Container(
                              height: 60*fem,
                              width: 7*fem,
                              decoration: BoxDecoration(
                                // color: (juz.id!%2==1)?Palette.primary : Palette.secondary,
                                  color: Palette.primary,
                                  borderRadius: BorderRadius.circular(5*fem)
                              ),
                            ),
                            SizedBox(width: 10*fem,),
                            Container(
                              width: 310*fem,
                              padding: EdgeInsets.fromLTRB(10*fem, 5*fem, 10*fem, 5*fem),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10*fem),
                              ),
                              child: Row(
                                children: [
                                  Stack(
                                    fit: StackFit.loose,
                                    children: [
                                      // Image.asset((juz.id!%2==1)?"assets/image/frame.png":"assets/image/frame2.png", height: 50*fem),
                                      Image.asset("assets/image/frame.png", height: 42*fem),
                                      SizedBox(
                                        width: 40*fem,
                                        height: 40*fem,
                                        child: Text(
                                            arabicNumber.convert(juz.id!.toString()),
                                            style: ArabicTextStyle(
                                                arabicFont: ArabicFont.scheherazade,
                                                fontSize: (juz.id!.toString().length >= 3) ? 24*ffem : 26*fem,
                                                letterSpacing: -2
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
                                        width: 225*fem,
                                        padding: EdgeInsets.only(top: 5*fem),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Juz " + juz.id!.toString(), style: TextStyle(fontFamily: 'Inter Bold', fontSize: 16*ffem)),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(bottom: 7*fem, top: 3*fem),
                                            child: Text("Mulai dari : ",
                                              style: TextStyle(
                                                  fontSize: 10*ffem),),
                                          ),
                                          Container(
                                            padding: EdgeInsets.fromLTRB(7*fem, 3*fem, 7*fem, 3*fem),
                                            margin: EdgeInsets.only(right: 5*fem),
                                            child: Text("Surah "+ juz.nama_surah! + " Ayat " +
                                                juz.no_ayat_mulai!.toString(),
                                              style: TextStyle(fontSize: 9*ffem, fontFamily: "Inter Medium",
                                                color: Palette.primary,
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                color: Palette.primary.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(10*fem)
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }

            return Container();
          },
        ),
      ),
    );
  }

  Widget wKategoriHalaman(){
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return RawScrollbar(
      thickness: 5,
      thumbColor: Palette.primary,
      child: SingleChildScrollView(
        child: BlocBuilder<HalamanCubit, HalamanState>(
          builder: (context, state) {
            if (state is ListHalamanLoading) {
              return Container();
            }

            else if (state is ListHalamanSuccess) {
              return Container(
                // margin: EdgeInsets.only(top: 10*fem),
                child: ListView.builder(
                    padding: EdgeInsets.only(top: 5*fem),
                    physics: ScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: state.halamanlist.length,
                    itemBuilder: (context, index) {
                      final halaman = state.halamanlist[index];
                      return GestureDetector(
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
                                    BlocProvider<BacaCubit>(
                                      create: (context) => BacaCubit(database: context.read<DatabaseCubit>().database!)..getBacaHalaman(halaman.id!.toString()),
                                    ),
                                  ],
                                  child: BacaHalamanPage(id_halaman: halaman.id!.toString()),
                                );
                              },
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 13*fem),
                          padding: EdgeInsets.fromLTRB(15*fem, 0, 15*fem, 0),
                          child: Row(
                            children: [
                              Container(
                                height: 60*fem,
                                width: 7*fem,
                                decoration: BoxDecoration(
                                  // color: (juz.id!%2==1)?Palette.primary : Palette.secondary,
                                    color: Palette.primary,
                                    borderRadius: BorderRadius.circular(5*fem)
                                ),
                              ),
                              SizedBox(width: 10*fem,),
                              Container(
                                width: 310*fem,
                                padding: EdgeInsets.fromLTRB(10*fem, 5*fem, 10*fem, 5*fem),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10*fem),
                                ),
                                child: Row(
                                  children: [
                                    Stack(
                                      fit: StackFit.loose,
                                      children: [
                                        // Image.asset((juz.id!%2==1)?"assets/image/frame.png":"assets/image/frame2.png", height: 50*fem),
                                        Image.asset("assets/image/frame.png", height: 42*fem),
                                        SizedBox(
                                          width: 40*fem,
                                          height: 40*fem,
                                          child: Text(
                                              arabicNumber.convert(halaman.id!.toString()),
                                              style: ArabicTextStyle(
                                                  arabicFont: ArabicFont.scheherazade,
                                                  fontSize: (halaman.id!.toString().length >= 3) ? 24*ffem : 26*fem,
                                                  letterSpacing: -2
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
                                          width: 225*fem,
                                          padding: EdgeInsets.only(top: 5*fem, bottom: 3*fem),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Halaman " + halaman.id!.toString(), style: TextStyle(fontFamily: 'Inter Bold', fontSize: 16*ffem)),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(bottom: 7*fem, top: 3*fem),
                                              child: Text("Mulai dari : ",
                                                style: TextStyle(
                                                    fontSize: 10*ffem),),
                                            ),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(7*fem, 3*fem, 7*fem, 3*fem),
                                              margin: EdgeInsets.only(right: 5*fem),
                                              child: Text("Surah "+ halaman.nama_surah! + " Ayat " +
                                                  halaman.no_ayat_mulai!.toString(),
                                                style: TextStyle(fontSize: 9*ffem, fontFamily: "Inter Medium",
                                                  color: Palette.primary,
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                  color: Palette.primary.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(10*fem)
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}