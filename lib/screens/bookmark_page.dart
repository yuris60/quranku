import 'package:Quranku/cubit/database/database_cubit.dart';
import 'package:Quranku/cubit/surah/surah_cubit.dart';
import 'package:Quranku/widget/core_leading.dart';
import 'package:Quranku/widget/empty_bookmark.dart';
import 'package:arabic_font/arabic_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants.dart';
import '../cubit/baca/baca_cubit.dart';
import '../cubit/database/database_logic.dart';
import '../cubit/doa/doa_cubit.dart';
import '../cubit/waktu_shalat/waktu_shalat_cubit.dart';
import '../widget/core_title.dart';
import 'baca_doa_page.dart';
import 'baca_surah_page.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => BookmarkPageState();
}

class BookmarkPageState extends State<BookmarkPage> {
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
          title: CoreTitle(title: "Bookmark", color: Colors.black, fontsize: 18),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Palette.black),
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
          builder: (context, state){
            if(state is LoadDatabaseState) {
              return Container(
                padding: EdgeInsets.fromLTRB(15*fem, 0*fem, 15*fem, 0),
                width: double.infinity,
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      wTabs(),
                      Expanded(
                        child: TabBarView(
                          children: [
                            wSurah(),
                            wDoa()
                          ],
                        ),
                      )
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

    return Container(
      width: double.infinity,
      height: 35*fem,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 15*fem),
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
        padding: EdgeInsets.zero,
        indicator: BoxDecoration(
          color: Palette.primary,
          borderRadius: BorderRadius.circular(50*fem),
        ),
        labelStyle: TextStyle(color: Colors.white, fontSize: 16*ffem, fontWeight: FontWeight.bold),
        tabs: [
          Tab(text: "Surah"),
          Tab(text: "Doa"),
        ],
      ),
    );
  }

  Widget wSurah(){
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return RawScrollbar(
      thickness: 5,
      thumbColor: Palette.primary,
      child: SingleChildScrollView(
        child: BlocBuilder<SurahCubit, SurahState>(
            builder: (context, state){
              if(state is ListSurahSuccess){
                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3.5/2,
                        crossAxisSpacing: 10*fem,
                        mainAxisSpacing: 10*fem
                    ),
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
                          height: 64*fem,
                          padding: EdgeInsets.fromLTRB(0*fem, 2*fem, 0*fem, 0*fem),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10*fem)
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 3*fem,
                                left: 133*fem,
                                child: GestureDetector(
                                  onTap: (){
                                    showModalBottomSheet(
                                        context: context,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(10*fem),
                                          ),
                                        ),
                                        builder:(context) {
                                          return Container(
                                            height: 90*fem,
                                            child: Column(
                                              children: [
                                                SizedBox(height: 10*fem,),
                                                Container(
                                                  width: 65*fem,
                                                  height: 5*fem,
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                      borderRadius: BorderRadius.circular(10*fem)
                                                  ),
                                                ),
                                                SizedBox(height: 10*fem,),

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
                                                                create: (context) => SurahCubit(database: context.read<DatabaseCubit>().database!)..setRemoveBoorkmarkSurah2(surah.id!.toString()),
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
                                                  child: ListTile(
                                                    leading: Icon(FontAwesomeIcons.heart, size: 24*ffem,),
                                                    title: Text("Hapus Surah Dari Bookmark", style: TextStyle(fontSize: 14*ffem),),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                    );
                                  },
                                  child: SizedBox(
                                    width: 20*fem,
                                    height: 20*fem,
                                    child: CircleAvatar(
                                        backgroundColor: Palette.secondary,
                                        child: Icon(Icons.more_horiz_rounded, color: Colors.black, size: 18*ffem,)
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                  top: 14*fem,
                                  left: 0,
                                  child: Container(
                                    width: 159*fem,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                surah.arabic!,
                                                style: ArabicTextStyle(
                                                    arabicFont: ArabicFont.scheherazade,
                                                    fontSize: 40*ffem,
                                                    height: 1*fem
                                                ),
                                                textAlign: TextAlign.end,
                                                softWrap: true,
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(bottom: 12*fem),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.fromLTRB(7*fem, 3*fem, 7*fem, 3*fem),
                                                      margin: EdgeInsets.only(right: 5*fem),
                                                      child: Text(surah.nama_surah!, style: TextStyle(fontSize: 9*ffem, fontFamily: "Inter Medium", color: Palette.primary,),),
                                                      decoration: BoxDecoration(
                                                          color: Palette.primary.withOpacity(0.1),
                                                          borderRadius: BorderRadius.circular(10*fem)
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.fromLTRB(7*fem, 3*fem, 7*fem, 3*fem),
                                                      child: Text(surah.jml_ayat!.toString() + " Ayat", style: TextStyle(fontSize: 9*ffem, fontFamily: "Inter Medium", color: Palette.primary,)),
                                                      decoration: BoxDecoration(
                                                          color: Palette.primary.withOpacity(0.1),
                                                          borderRadius: BorderRadius.circular(10*fem)
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 6*fem,
                                          decoration: BoxDecoration(
                                              color: Palette.primary,
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(10*fem),
                                                  bottomRight: Radius.circular(10*fem)
                                              )
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                );
              } else {
                return EmptyBookmark(
                  title: "Bookmark Surah Kosong",
                  subtitle: "Kamu bisa menambahkan bookmark surah pada halaman baca Quran",
                );
              }
            }
        ),
      ),
    );
  }

  Widget wDoa(){
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return RawScrollbar(
      thickness: 5,
      thumbColor: Palette.primary,
      child: SingleChildScrollView(
        child: BlocBuilder<DoaCubit, DoaState>(
            builder: (context, state){
              if(state is ListDoaSuccess){
                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3.5/2,
                        crossAxisSpacing: 10*fem,
                        mainAxisSpacing: 10*fem
                    ),
                    shrinkWrap: true,
                    itemCount: state.listdoa.length,
                    itemBuilder: (context, index) {
                      final doa = state.listdoa[index];
                      return GestureDetector(
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
                          height: 64*fem,
                          padding: EdgeInsets.fromLTRB(0*fem, 2*fem, 0*fem, 0*fem),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10*fem)
                          ),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 7*fem, top: 5*fem),
                                  child: GestureDetector(
                                    onTap: (){
                                      showModalBottomSheet(
                                          context: context,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(10*fem),
                                            ),
                                          ),
                                          builder:(context) {
                                            return Container(
                                              height: 90*fem,
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 10*fem,),
                                                  Container(
                                                    width: 65*fem,
                                                    height: 5*fem,
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey,
                                                        borderRadius: BorderRadius.circular(10*fem)
                                                    ),
                                                  ),
                                                  SizedBox(height: 10*fem,),

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
                                                                  create: (context) => DoaCubit(database: context.read<DatabaseCubit>().database!)..setRemoveBoorkmarkDoa2(doa.id!.toString()),
                                                                ),
                                                                BlocProvider<SurahCubit>(
                                                                  create: (context) => SurahCubit(database: context.read<DatabaseCubit>().database!)..getBookmarkSurah(),
                                                                ),
                                                              ],
                                                              child: BookmarkPage(),
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    },
                                                    child: ListTile(
                                                      leading: Icon(FontAwesomeIcons.heart, size: 24*ffem,),
                                                      title: Text("Hapus Doa Dari Bookmark", style: TextStyle(fontSize: 14*ffem),),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                      );
                                    },
                                    child: SizedBox(
                                      width: 20*fem,
                                      height: 20*fem,
                                      child: CircleAvatar(
                                          backgroundColor: Palette.secondary,
                                          child: Icon(Icons.more_horiz_rounded, color: Colors.black, size: 18*ffem,)
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.fromLTRB(5*fem, 5*fem, 5*fem, 17*fem),
                                  child: Text(doa.nama_doa!, textAlign: TextAlign.center, style: TextStyle(fontSize: 14*ffem),)
                              ),
                              Container(
                                height: 6*fem,
                                decoration: BoxDecoration(
                                    color: Palette.primary,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10*fem),
                                        bottomRight: Radius.circular(10*fem)
                                    )
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                );
              } else {
                return EmptyBookmark(
                  title: "Bookmark Doa Kosong",
                  subtitle: "Kamu bisa menambahkan bookmark doa pada halaman doa sehari-hari",
                );
              }
            }
        ),
      ),
    );
  }
}
