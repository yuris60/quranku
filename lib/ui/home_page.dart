import 'package:Quranku/cubit/juz_cubit.dart';
import 'package:arabic_font/arabic_font.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants.dart';
import '../cubit/halaman_cubit.dart';
import '../cubit/surah_cubit.dart';
import '../widget/drawer.dart';

import 'baca_juz_page.dart';
import 'baca_halaman_page.dart';
import 'baca_surah_page.dart';

import '../cubit/database_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController _searchcontroller = new TextEditingController();

  // scroll controller for the TabBar
  ScrollController _scrollController = new ScrollController();

  final arabicNumber = ArabicNumbers();

  // onSearch(String text) async {
  //   _search.clear();
  //   if (text.isEmpty) {
  //     setState(() {});
  //     return;
  //   }
  //
  //   setState(() {});
  // }

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
      appBar: AppBar(
        title: Text("Quranku", style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Palette.primary,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/image/logo_quranku_white.png"),
          )
        ],
      ),
      drawer: CoreDrawer(),
      body: Container(
        width: double.infinity,
        child: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(15*fem, 20*fem, 15*fem, 10*fem),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Al-Quran", style: TextStyle(fontSize: 16*ffem, color: Colors.grey),),
                    Text("Baca Surah", style: TextStyle(fontSize: 32*ffem, fontFamily: 'Inter Bold'),),
                  ],
                ),
              ),

              Container(
                width: double.infinity,
                child: TabBar(
                  labelColor: Palette.primary,
                  unselectedLabelColor: Palette.greys,
                  dividerColor: Palette.primary,
                  indicatorColor: Palette.primary,
                  labelStyle: TextStyle(color: Palette.primary, fontSize: 16*ffem, fontWeight: FontWeight.bold),
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
                    RawScrollbar(
                      thickness: 5,
                      thumbColor: Palette.primary,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              height: 38*fem,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50*fem),
                                color: Palette.primary.withOpacity(0.1),
                                // border: Border.all(color: Palette.primary, width: 2)
                              ),
                              margin: EdgeInsets.fromLTRB(15*fem, 15*fem, 15*fem, 5*fem),
                              padding: EdgeInsets.only(left: 15*fem),
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: SizedBox(height: 60*fem, child: Icon(Icons.search, color: Palette.primary,)),
                                title: SizedBox(
                                  height: 25*fem,
                                  child: TextField(
                                    controller: _searchcontroller,
                                    // onChanged: onSearch,
                                    decoration: InputDecoration(
                                      hintText: "Cari Surah", border: InputBorder.none,
                                      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 13*fem),
                                      // filled: true,
                                      // fillColor: Color(0xffe1e1e1),
                                    ),
                                  ),
                                ),
                                visualDensity: VisualDensity(vertical: -3),
                                trailing:
                                IconButton(
                                  onPressed: () {
                                    _searchcontroller.clear();
                                    // onSearch('');
                                  },
                                  icon: Icon(Icons.cancel, color: Palette.primary),
                                )
                              ),
                            ),

                            BlocProvider(
                              create: (context) => ListSurahCubit()..getListSurah(),
                              child: BlocBuilder<ListSurahCubit, SurahState>(
                                builder: (context, state) {
                                  if (state is ListSurahLoading) {
                                    return Padding(
                                      padding: EdgeInsets.only(top: 20*fem),
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }

                                  else if(state is ListSurahSuccess){
                                    return ListView.builder(
                                    padding: EdgeInsets.only(top: 5*fem),
                                    physics: ScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: state.surahlist.length,
                                    itemBuilder: (context, index) {
                                      final surah = state.surahlist[index];
                                        return Column(
                                          children: [
                                            ListTile(
                                              leading: Stack(
                                                fit: StackFit.loose,
                                                children: [
                                                  Image.asset("assets/image/frame.png", height: 42*fem),
                                                  SizedBox(
                                                    width: 40*fem,
                                                    height: 40*fem,
                                                    child: Text(arabicNumber.convert(surah.id!.toString()), style: ArabicTextStyle(arabicFont: ArabicFont.scheherazade, fontSize: (surah.id!.toString().length>=3) ? 24*ffem : 26*fem, letterSpacing: -2), textAlign: TextAlign.center),
                                                  )
                                                ],
                                              ),
                                              title: Text(surah.nama_surah!, style: TextStyle(fontFamily: 'Inter Medium')),
                                              subtitle: Text(surah.arti! + " (" + surah.jml_ayat!.toString() + " ayat)", style: TextStyle(fontSize: 10*ffem),),
                                              trailing: Text(surah.arabic!, style: ArabicTextStyle(arabicFont: ArabicFont.scheherazade, fontWeight: FontWeight.bold, color: Palette.primary, fontSize: 29*ffem),),
                                              visualDensity: VisualDensity(vertical: -2),
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) {
                                                      return BacaSurahPage(
                                                        id: surah.id!.toString(),
                                                        surah: surah
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                            ),
                                            Divider(),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                  return Container();
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    // KATEGORI JUZ
                    RawScrollbar(
                      thickness: 5,
                      thumbColor: Palette.primary,
                      child: SingleChildScrollView(
                        child: BlocProvider(
                          create: (context) => ListJuzCubit()..getListJuz(),
                          child: BlocBuilder<ListJuzCubit, JuzState>(
                          builder: (context, state) {
                            if (state is ListJuzLoading) {
                              return Padding(
                                padding: EdgeInsets.only(top: 20*fem),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            else if(state is ListJuzSuccess){
                              return ListView.builder(
                                padding: EdgeInsets.only(top: 5*fem),
                                physics: ScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: state.listjuz.length,
                                itemBuilder: (context, index) {
                                  final juz = state.listjuz[index];
                                  return Column(
                                    children: [
                                      ListTile(
                                        leading: Stack(
                                          fit: StackFit.loose,
                                          children: [
                                            Image.asset("assets/image/frame.png", height: 42*fem),
                                            SizedBox(
                                              width: 40*fem,
                                              height: 40*fem,
                                              child: Text(arabicNumber.convert(juz.id!.toString()), style: ArabicTextStyle(arabicFont: ArabicFont.scheherazade, fontSize: 26*fem, letterSpacing: -2), textAlign: TextAlign.center),
                                            )
                                          ],
                                        ),
                                        title: Text("Juz " + juz.id!.toString(), style: TextStyle(fontFamily: 'Inter Medium')),
                                        subtitle: Text("Mulai dari : Surah " + juz.nama_surah! +  " Ayat " + juz.no_ayat_mulai!.toString(), style: TextStyle(fontSize: 10*ffem),),
                                        visualDensity: VisualDensity(vertical: -2),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return BacaJuzPage(
                                                  id_juz: juz.id!.toString(),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                      Divider(),
                                    ],
                                  );
                                },
                              );
                            }

                            return Container();
                          },
                        ),
                        ),
                      ),
                    ),

                    // KATEGORI HALAMAN
                    RawScrollbar(
                      thickness: 5,
                      thumbColor: Palette.primary,
                      child: SingleChildScrollView(
                        child: BlocProvider(
                          create: (context) => ListHalamanCubit()..getListHalaman(),
                          child: BlocBuilder<ListHalamanCubit, HalamanState>(
                            builder: (context, state) {
                              if (state is ListHalamanLoading) {
                                return Padding(
                                  padding: EdgeInsets.only(top: 20*fem),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              else if(state is ListHalamanSuccess) {
                                return ListView.builder(
                                    padding: EdgeInsets.only(top: 5 * fem),
                                    physics: ScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: state.listhalaman.length,
                                    itemBuilder: (context, index) {
                                      final halaman = state.listhalaman[index];
                                      return Column(
                                        children: [
                                          ListTile(
                                            leading: Stack(
                                              fit: StackFit.loose,
                                              children: [
                                                Image.asset(
                                                    "assets/image/frame.png",
                                                    height: 42 * fem),
                                                SizedBox(
                                                  width: 40 * fem,
                                                  height: 40 * fem,
                                                  child: Text(
                                                      arabicNumber.convert(halaman.id!.toString()),
                                                      style: ArabicTextStyle(
                                                          arabicFont: ArabicFont.scheherazade,
                                                          fontSize: 26 * fem,
                                                          letterSpacing: -2),
                                                      textAlign: TextAlign.center),
                                                )
                                              ],
                                            ),
                                            title: Text("Halaman " +
                                                halaman.id!.toString(),
                                                style: TextStyle(fontFamily: 'Inter Medium')),
                                            subtitle: Text(
                                              "Mulai dari : Surah " + halaman.nama_surah! + " Ayat " + halaman.no_ayat_mulai!.toString(),
                                              style: TextStyle(fontSize: 10 * ffem),),
                                            visualDensity: VisualDensity(vertical: -2),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return BacaHalamanPage(
                                                      id_halaman: halaman.id!
                                                          .toString(),
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                          Divider(),
                                        ],
                                      );
                                    }
                                );
                              }
                              return Container();
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}