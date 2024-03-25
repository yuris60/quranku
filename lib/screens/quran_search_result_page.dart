import 'package:Quranku/cubit/database/database_cubit.dart';
import 'package:Quranku/cubit/surah/surah_cubit.dart';
import 'package:Quranku/screens/quran_searh_form_page.dart';
import 'package:arabic_font/arabic_font.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants.dart';
import '../cubit/baca/baca_cubit.dart';
import '../widget/core_title.dart';
import '../widget/empty_bookmark.dart';
import 'baca_surah_page.dart';

class QuranSearchResultPage extends StatefulWidget {
  String? keyword;
  QuranSearchResultPage({required this.keyword});

  @override
  State<QuranSearchResultPage> createState() => _QuranSearchResultPageState();
}

class _QuranSearchResultPageState extends State<QuranSearchResultPage> {

  TextEditingController _searchcontroller = new TextEditingController();
  final arabicNumber = ArabicNumbers();

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
        appBar: AppBar(
          title: CoreTitle(title: "Cari Surah", color: Colors.white, fontsize: 18),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.white)
          ),
          backgroundColor: Palette.primary,
          elevation: 0,
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
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(15*fem, 0, 15*fem, 10*fem),
                          decoration: BoxDecoration(
                            color: Palette.primary
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Pencarian Kamu :", style: TextStyle(fontSize: 14*ffem, color: Colors.white),),
                                  Text(widget.keyword!, style: TextStyle(fontSize: 22*ffem, fontFamily: "Inter Bold", color: Colors.white),),
                                ],
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(8*fem),
                                  primary: Palette.secondary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5*fem))
                                  )
                                ),
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                                child: Text("Kembali", style: TextStyle(fontSize: 14*ffem),)
                              )
                            ],
                          )
                        ),
                        SizedBox(height: 15*fem,),

                        BlocBuilder<SurahCubit, SurahState>(
                            builder: (context, state){
                              if(state is ListSurahSuccess){
                                return Expanded(
                                  child: ListView.builder(
                                      physics: ScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: state.surahlist.length,
                                      itemBuilder: (context, index){
                                        return resultSurah();
                                      }
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            }
                        ),
                      ],
                    )
                );
              } else {
                return Container();
              }
            }
        )
    );
  }

  Widget resultSurah(){
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return RawScrollbar(
      thickness: 5,
      thumbColor: Palette.primary,
      child: SingleChildScrollView(
        child: BlocBuilder<SurahCubit, SurahState>(
          builder: (context, state) {
            if (state is ListSurahSuccess) {
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
                                ],
                                child: BacaSurahPage(),
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
                                // color: (surah.id!%2==1)?Palette.primary : Palette.secondary,
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
                                      // Image.asset((surah.id!%2==1)?"assets/image/frame.png":"assets/image/frame2.png", height: 50*fem),
                                      Image.asset("assets/image/frame.png", height: 42*fem),
                                      SizedBox(
                                        width: 40*fem,
                                        height: 40*fem,
                                        child: Text(
                                            arabicNumber.convert(surah.id!.toString()),
                                            style: ArabicTextStyle(
                                                arabicFont: ArabicFont.scheherazade,
                                                fontSize: (surah.id!.toString().length >= 3) ? 24*ffem : 26*fem,
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
                                        width: 235*fem,
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

            else {
              return EmptyBookmark(
                title: "Maaf, Surah Tidak Ditemukan",
                subtitle: "Silahkan periksa kembali kata kunci yang digunakan.",
              );
            }
          },
        ),
      ),
    );
  }
}
