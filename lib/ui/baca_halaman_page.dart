import 'package:arabic_font/arabic_font.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../model/halaman_model.dart';
import '../service/halaman_service.dart';

class BacaHalamanPage extends StatefulWidget {
  String? id_halaman;
  BacaHalamanPage({required this.id_halaman});

  @override
  State<BacaHalamanPage> createState() => _BacaHalamanPageState();
}

class _BacaHalamanPageState extends State<BacaHalamanPage> {

  bool _isloading = true;
  final arabicNumber = ArabicNumbers();
  final ayats = <BacaHalamanModel>[];
  getAyat() async {
    final ayat = await HalamanService.instance.bacaHalaman(widget.id_halaman!);
    setState(() {
      this.ayats.clear();
      this.ayats.addAll(ayat);
      _isloading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getAyat();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    if (_isloading == false) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Quranku (Halaman " + widget.id_halaman! + ")",
            style: TextStyle(color: Colors.white, fontSize: 18*ffem),),
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
              padding: EdgeInsets.all(8*fem),
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
                  ListView.builder(
                    // physics: AlwaysScrollableScrollPhysics(),
                    physics: ScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: ayats.length,
                    itemBuilder: (context, index) {
                      final ayat = ayats[index];
                      return Container(
                        color: (ayat.no_ayat! % 2 == 1) ? Colors.white : Palette.primary.withOpacity(0.05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if((ayat.no_ayat!.toString() == "1") || index==0)
                              Container(
                                // margin: EdgeInsets.fromLTRB(10*fem, 10*fem, 10*fem, 10*fem),
                                padding: EdgeInsets.fromLTRB(20 * fem, 30 * fem, 20 * fem, 30 * fem),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  // borderRadius: BorderRadius.all(Radius.circular(10 * fem)),
                                  color: Palette.primary,
                                  image: DecorationImage(
                                    image: AssetImage(
                                        (ayat.kategori == 'Makiyah')
                                            ? "assets/image/banner_mekkah.jpg"
                                            : "assets/image/banner_madinah.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(ayat.nama_surah!, style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20 * ffem,
                                        fontWeight: FontWeight.bold),),
                                    Text(ayat.arti!, style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16 * ffem)),
                                    SizedBox(height: 15 * fem,),
                                    Text(ayat.jml_ayat!.toString() + " Ayat",
                                        style: TextStyle(color: Colors.white,
                                            fontSize: 16 * ffem)),
                                    Text(ayat.kategori!, style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12 * ffem))
                                  ],
                                ),
                              ),

                            if((ayat.no_ayat!.toString() == "1" && ayat.id!.toString() != "0") || (index==0 && ayat.id_surah.toString() != "1"))
                              Image.asset("assets/image/bismillah_header2.jpg"),

                            Container(
                              padding: EdgeInsets.fromLTRB(15*fem, 10*fem, 15*fem, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Flexible(
                                    child: Stack(
                                      fit: StackFit.loose,
                                      children: [
                                        Image.asset("assets/image/frame.png",
                                            height: 40 * fem),
                                        SizedBox(
                                          width: 37 * fem,
                                          height: 40 * fem,
                                          child: Text(arabicNumber.convert(
                                              ayat.no_ayat.toString()),
                                              style: ArabicTextStyle(
                                                  arabicFont: ArabicFont.scheherazade,
                                                  fontSize: (ayat.no_ayat!.toString().length >= 3) ? 24 * ffem : 26 * fem,
                                                  letterSpacing: -2),
                                              textAlign: TextAlign.center),
                                        )
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    flex: 6,
                                    child: Text(ayat.ayat_text!,
                                      style: ArabicTextStyle(
                                          arabicFont: ArabicFont.scheherazade,
                                          fontSize: 32 * ffem,
                                          height: 1.3 * fem),
                                      textAlign: TextAlign.end,
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 15 * fem),
                              child: Text(ayat.baca_text!, style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: Palette.primary
                              ),
                                textAlign: TextAlign.start,),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 15 * fem, vertical: 10 * fem),
                              child: Text(ayat.indo_text!,
                                style: TextStyle(fontFamily: 'Inter'),
                                textAlign: TextAlign.start,),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Center(
          child: Container(
            color: Colors.white,
            child: SizedBox(
                height: 300*fem,
                child: Image.asset("assets/image/loading.png")
            ),
          ),
        ),
      );
    }
  }
}
