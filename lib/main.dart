import 'package:flutter/material.dart';
import 'package:Quranku/ui/home_page.dart';

void main() {
  runApp(const QurankuApp());
}

class QurankuApp extends StatefulWidget {
  const QurankuApp({super.key});

  @override
  State<QurankuApp> createState() => _QurankuAppState();
}

class _QurankuAppState extends State<QurankuApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter'
      ),
      home: HomePage(),
    );
  }
}

