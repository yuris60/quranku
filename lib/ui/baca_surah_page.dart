import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:arabic_font/arabic_font.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants.dart';
import '../cubit/database/database_cubit.dart';
import '../cubit/surah_cubit.dart';
import '../model/surah_model.dart';


class BacaSurahPage extends StatefulWidget {
  const BacaSurahPage({super.key});

  @override
  State<BacaSurahPage> createState() => _BacaSurahPageState();
}

class _BacaSurahPageState extends State<BacaSurahPage> {

  ScrollController controller = ScrollController();

  final arabicNumber = ArabicNumbers();

  SurahCubit? _surah;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
       backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Quranku", style: TextStyle(color: Colors.white),),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          backgroundColor: Palette.primary,
          // centerTitle: true,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("assets/image/logo_quranku_white.png"),
            )
          ],
        ),
        body: Container(
          width: double.infinity,
          child: RawScrollbar(
            thickness: 5,
            thumbColor: Palette.primary,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                    // Container(
                    //   // margin: EdgeInsets.fromLTRB(10*fem, 10*fem, 10*fem, 10*fem),
                    //   padding: EdgeInsets.fromLTRB(20*fem, 30*fem, 20*fem, 30*fem),
                    //   width: double.infinity,
                    //   decoration: BoxDecoration(
                    //     // borderRadius: BorderRadius.all(Radius.circular(10*fem)),
                    //     color: Palette.primary,
                    //     image: DecorationImage(
                    //       image: AssetImage((widget.surah.kategori == 'Makiyah') ?  "assets/image/banner_mekkah.jpg" : "assets/image/banner_madinah.jpg"),
                    //       fit: BoxFit.cover,
                    //     ),
                    //   ),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text(widget.surah.nama_surah!, style: TextStyle(color: Colors.white, fontSize: 20 * ffem, fontWeight: FontWeight.bold),),
                    //       Text(widget.surah.arti!, style: TextStyle(color: Colors.white, fontSize: 16 * ffem)),
                    //       SizedBox(height: 15*fem,),
                    //       Text(widget.surah.jml_ayat.toString()! + " Ayat", style: TextStyle(color: Colors.white, fontSize: 16 * ffem)),
                    //       Text(widget.surah.kategori!, style: TextStyle(color: Colors.white, fontSize: 12 * ffem))
                    //     ],
                    //   ),
                    // ),

                    // if(widget.surah.id.toString() != "1")
                    //   Image.asset("assets/image/bismillah_header2.jpg"),

                    BlocBuilder<SurahCubit, SurahState>(
                      builder: (context, state) {
                        if (state is BacaSurahLoading) {
                          return Padding(
                            padding: EdgeInsets.only(top: 70*fem),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        else if(state is BacaSurahSuccess) {
                          return ListView.builder(
                            // physics: AlwaysScrollableScrollPhysics(),
                            physics: ScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: state.surahbaca.length,
                            itemBuilder: (context, index) {
                              final ayat = state.surahbaca[index];
                              return Container(
                                padding: EdgeInsets.symmetric(vertical: 10*fem, horizontal: 15*fem),
                                color: (ayat.no_ayat! % 2 == 1)
                                    ? Colors.white
                                    : Palette.primary.withOpacity(0.05),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text(ayat.ayahText!, style: TextStyle(fontSize: 24), textAlign: TextAlign.end),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Flexible(
                                          child: Stack(
                                            fit: StackFit.loose,
                                            children: [
                                              Image.asset("assets/image/frame.png", height: 40*fem),
                                              SizedBox(
                                                width: 37*fem,
                                                height: 40*fem,
                                                child: Text(
                                                    arabicNumber.convert(ayat.no_ayat.toString()),
                                                    style: ArabicTextStyle(
                                                        arabicFont: ArabicFont.scheherazade,
                                                        fontSize: (ayat.no_ayat!.toString().length >= 3) ? 24 * ffem : 26*fem,
                                                        letterSpacing: -2
                                                    ),
                                                    textAlign: TextAlign
                                                        .center
                                                ),
                                              )
                                            ],
                                          ),
                                        ),

                                        Flexible(
                                          flex: 6,
                                          child: Text(
                                            ayat.ayat_text!,
                                            style: ArabicTextStyle(
                                                arabicFont: ArabicFont
                                                    .scheherazade,
                                                fontSize: 32 * ffem,
                                                height: 1.4*fem
                                            ),
                                            textAlign: TextAlign.end,
                                            softWrap: true,
                                          ),
                                        ),
                                      ],
                                    ),

                                    Text(
                                      ayat.baca_text!,
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          color: Palette.primary
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                    SizedBox(height: 10*fem),
                                    Text(
                                      ayat.indo_text!,
                                      style: TextStyle(
                                          fontFamily: 'Inter'),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                        return Container();
                      },
                    ),
                  ],
                ),
              ),
            ),
          )
       );
    // } else {
    //   return Scaffold(
    //     backgroundColor: Colors.white,
    //     appBar: AppBar(
    //       backgroundColor: Colors.white,
    //       elevation: 0,
    //     ),
    //     body: Center(
    //       child: Container(
    //         color: Colors.white,
    //         child: SizedBox(
    //           height: 300*fem,
    //           child: Image.asset("assets/image/loading.png")
    //         ),
    //       ),
    //     ),
    //   );
    // }
  }
}
