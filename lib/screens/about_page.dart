import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../widget/core_title.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      appBar: AppBar(
        title: CoreTitle(title: "QURANKU", color: Colors.black, fontsize: 18),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Palette.black),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
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
      body: Center(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.fromLTRB(15*fem, 0, 15*fem, 0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 200*fem,
                  width: 200*fem,
                  child: Image.asset("assets/image/logo_quranku_new.png")
                ),
                SizedBox(height: 10*fem,),
                Text(
                  "QURANKU",
                  style: TextStyle(fontSize: 30*ffem, fontFamily: "Inter Medium"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Versi Aplikasi : "),
                    Container(
                      padding: EdgeInsets.fromLTRB(8*fem, 3*fem, 8*fem, 3*fem),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5*fem)),
                        color: Palette.primary
                      ),
                      child: Text(Palette.app_version, style: TextStyle(fontSize: 12*ffem, color: Colors.white)),
                    ),
                  ],
                ),
                SizedBox(height: 20*fem,),
                Text(
                  "Quranku adalah solusi alternatif bagi anda yang ingin membaca Al-Quran dimana saja. Dapatkan keberkahan Al-Quran hanya dalam genggaman anda.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15*ffem,
                  )
                ),
                SizedBox(height: 20*fem,),
                Text("What's New?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15*ffem, fontFamily: "Inter Medium"
                  )
                ),
                Text(Palette.whats_new,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15*ffem,
                  )
                ),
                SizedBox(height: 20*fem,),
                Text("Copyright © " + DateFormat("yyyy").format(DateTime.now()),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15*ffem, fontFamily: "Inter Medium")
                ),
                Text("Yuris Alkhalifi",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20*ffem,
                    )),
                Text("https://github.com/yuris60",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12*ffem,)
                ),
                SizedBox(height: 20*fem,),
                Text("Thanks to : ",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15*ffem, fontFamily: "Inter Medium")),
                Text("https://github.com/sinoridha",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12*ffem,)
                ),
                Text("https://github.com/gadingnst",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12*ffem,)
                ),
                Text("https://github.com/Abdallah-Mekky",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12*ffem,)
                ),
                Text("https://doa-doa-api-ahmadramadhan.fly.dev/api",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12*ffem,)
                ),
                Text("https://bimasislam.kemenag.go.id/jadwalshalat",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12*ffem,)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
