import 'package:Quranku/ui/baca_quran.dart';
import 'package:arabic_font/arabic_font.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../widget/drawer.dart';

import '../service/surah_service.dart';
import '../service/juz_service.dart';
import '../service/halaman_service.dart';

import '../model/surah_model.dart';
import '../model/halaman_model.dart';
import '../model/juz_model.dart';

import 'baca_juz_page.dart';
import 'baca_halaman_page.dart';
import 'baca_surah_page.dart';

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
  final surahs = <ListSurahModel>[];
  final _search = <ListSurahModel>[];

  getSurahAll() async {
    final surah = await SurahService.instance.listSurah();
    setState(() {
      this.surahs.clear();
      this.surahs.addAll(surah);
    });
  }

  bool _loadingjuz = true;
  final juzs = <ListJuzModel>[];
  getJuzAll() async {
    final juz = await JuzService.instance.listJuz();
    setState(() {
      this.juzs.clear();
      this.juzs.addAll(juz);
      _loadingjuz = false;
    });
  }

  final halamans = <ListHalamanModel>[];
  getHalamanAll() async {
    final halaman = await HalamanService.instance.listHalaman();
    setState(() {
      this.halamans.clear();
      this.halamans.addAll(halaman);
    });
  }

  onSearch(String text) async {
    _search.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    surahs.forEach((data) {
      if (data.nama_surah!.toLowerCase().contains(text) || data.nama_surah!.startsWith(text))
        _search.add(data);
    });

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getSurahAll();
    getJuzAll();
    getHalamanAll();
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
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: SizedBox(
                height: 200*fem,
                width: baseWidth*fem,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(20*fem, 20*fem, 20*fem, 20*fem),
                      height: 150*fem,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10*fem)),
                        color: Palette.primary,
                        image: DecorationImage(
                          image: AssetImage("assets/image/banner_mekkah.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 130*fem,
              left: 0*fem,
              child: SizedBox(
                // height: 100*fem,
                width: baseWidth*fem,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(30*fem, 20*fem, 30*fem, 20*fem),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10*fem)),
                        color: Palette.secondary,
                      ),
                      child: Text("Oke"),
                    ),

                    Container(
                      margin: EdgeInsets.fromLTRB(20*fem, 10*fem, 20*fem, 0*fem),
                      width: double.infinity,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 86*fem, 0*fem),
                        child: Text(
                          'Semua Fitur',
                          style: TextStyle (
                            fontFamily: 'Inter Bold',
                            fontSize: 18*ffem,
                            height: 1.5*ffem/fem,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20*fem, 10*fem, 20*fem, 20*fem),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return BacaQuranPage();
                                    },
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(10*fem, 10*fem, 10*fem, 10*fem),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10*fem),
                                  color: Colors.white,
                                ),
                                child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                            width: 100*fem,
                                            height: 100*fem,
                                            child: Image.asset("assets/image/logo_quranku.png")
                                        ),
                                        SizedBox(height: 3*fem,),
                                        Text("Al-Quran", textAlign: TextAlign.center, style: TextStyle(fontSize: 15*ffem, fontFamily: "Poppins Medium"),),
                                      ],
                                    )
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10*fem,),
                          Expanded(
                            child: GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return BacaQuranPage();
                                    },
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(10*fem, 10*fem, 10*fem, 10*fem),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10*fem),
                                  color: Colors.white,
                                ),
                                child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                            width: 100*fem,
                                            height: 100*fem,
                                            child: Image.asset("assets/image/logo_quranku.png")
                                        ),
                                        SizedBox(height: 3*fem,),
                                        Text("Doa", textAlign: TextAlign.center, style: TextStyle(fontSize: 15*ffem, fontFamily: "Poppins Medium"),),
                                      ],
                                    )
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}