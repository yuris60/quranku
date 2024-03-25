import 'package:flutter/material.dart';

class CoreTitle extends StatefulWidget {
  final int? fontsize;
  final Color? color;
  final String? title;
  const CoreTitle({this.fontsize, this.color, this.title});

  @override
  State<CoreTitle> createState() => _CoreTitleState();
}

class _CoreTitleState extends State<CoreTitle> {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Text(widget.title!, style: TextStyle(color: widget.color!, fontFamily: "Inter Bold", fontSize: widget.fontsize!*ffem));
  }
}
