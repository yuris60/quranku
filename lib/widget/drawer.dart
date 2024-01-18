import 'package:Quranku/ui/about_page.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class CoreDrawer extends StatefulWidget {
  const CoreDrawer({super.key});

  @override
  State<CoreDrawer> createState() => _CoreDrawerState();
}

class _CoreDrawerState extends State<CoreDrawer> {

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Palette.primary,
            ),
            currentAccountPicture: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(
                        "assets/image/logo_quranku_white.png"
                      )
                  )
              ),
            ),
            accountName: Text(
              "Quranku",
              style: TextStyle(color: Colors.white, fontSize: 22*ffem, fontFamily: "Inter Bold"),
            ),
            accountEmail: Text(
              "v." + Palette.app_version,
              style: TextStyle(color: Colors.white),
            ),
          ),
          // Image.asset("assets/image/yuris.png")
          ListTile(
            title: Text("Tentang Aplikasi", style: TextStyle(color: Palette.primary)),
            leading: Icon(
              Icons.info_outline,
              color: Palette.primary,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => AboutPage()
                  )
              );
            },
          ),
        ],
      ),
    );
  }
}