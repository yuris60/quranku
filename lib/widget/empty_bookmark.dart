import 'package:flutter/material.dart';

class EmptyBookmark extends StatefulWidget {
  final String? title;
  final String? subtitle;
  const EmptyBookmark({this.title, this.subtitle});

  @override
  State<EmptyBookmark> createState() => _EmptyBookmarkState();
}

class _EmptyBookmarkState extends State<EmptyBookmark> {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 25*fem),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              width: 230*fem,
              height: 230*fem,
              child: Image.asset("assets/image/empty.png")
          ),
          SizedBox(height: 10*fem,),
          Text(widget.title!, style: TextStyle(fontSize: 20*ffem, fontFamily: "Inter Bold"),),
          SizedBox(height: 5*fem,),
          Text(widget.subtitle!, textAlign: TextAlign.center, style: TextStyle(fontSize: 14*ffem,)),
        ],
      ),
    );;
  }
}
