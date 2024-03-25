import 'dart:async';

import 'package:Quranku/cubit/database/database_cubit.dart';
import 'package:Quranku/cubit/database/database_logic.dart';
import 'package:Quranku/cubit/waktu_shalat/waktu_shalat_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../cubit/baca/baca_cubit.dart';
import '../widget/core_leading.dart';
import '../utils/tglindo.dart';

class JadwalShalatPage extends StatefulWidget {
  const JadwalShalatPage({super.key});

  @override
  State<JadwalShalatPage> createState() => _JadwalShalatPageState();
}

class _JadwalShalatPageState extends State<JadwalShalatPage> {
  String? _hariini, _shalatsekarang, _shalatsekarang2, _shalatwaktusekarang, _shalatwaktuselesaisekarang, _shalatselanjutnya, _shalatwaktuselanjutnya, _shalatwaktuselesaiselanjutnya, _jamsaatini, text_ucapan;

  @override
  void initState() {
    if(mounted) {
      setState(() {
        _jamsaatini = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
        _hariini = _formatDateTime(DateTime.now());
        Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
        super.initState();
      });
    }
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    if(mounted) {
      setState(() {
        _hariini = formattedDateTime;
      });
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return formatTglIndo(dateTime.toString());
  }

  Future onRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      super.initState();
    });
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider<DatabaseCubit>(
                    create: (context) => DatabaseCubit()..initDB(),
                  ),
                  BlocProvider<BacaCubit>(
                    create: (context) => BacaCubit(database: context.read<DatabaseCubit>().database!)..getRandomAyat(),
                  ),
                  BlocProvider<WaktuShalatCubit>(
                    create: (context) => WaktuShalatCubit(database: context.read<DatabaseCubit>().database!)..getWaktuShalat(),
                  ),
                ],
                child: DatabaseCubicLogic(),
              );
            },
          ),
        );
        return true;
      },
      child: Container(
        width: double.infinity,
        child: BlocBuilder<DatabaseCubit, DatabaseState>(
          builder: (context, state) {
            if(state is LoadDatabaseState) {
              return BlocBuilder<WaktuShalatCubit, WaktuShalatState>(
                builder: (context, state){
                  if(state is WaktuShalatSuccess){
                    return Container(
                      width: double.infinity,
                      child: ListView.builder(
                          physics: ScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: state.waktushalat.length,
                          itemBuilder: (context, index){
                            final waktushalat = state.waktushalat[index];

                            String subuh = waktushalat.tanggal! + " " + waktushalat.subuh!;
                            String fajar = waktushalat.tanggal! + " " + waktushalat.fajar!;
                            String dzuhur = waktushalat.tanggal! + " " + waktushalat.dzuhur!;
                            String ashar = waktushalat.tanggal! + " " + waktushalat.ashar!;
                            String magrib = waktushalat.tanggal! + " " + waktushalat.magrib!;
                            String isya = waktushalat.tanggal! + " " + waktushalat.isya!;

                            DateTime _waktusubuh = DateTime.parse(subuh);
                            DateTime _waktufajar = DateTime.parse(fajar);
                            DateTime _waktudzuhur = DateTime.parse(dzuhur);
                            DateTime _waktuashar = DateTime.parse(ashar);
                            DateTime _waktumagrib = DateTime.parse(magrib);
                            DateTime _waktuisya = DateTime.parse(isya);

                            int _selisihsubuh = DateTime.parse(_jamsaatini!).difference(_waktusubuh).inSeconds;
                            int _selisihfajar = DateTime.parse(_jamsaatini!).difference(_waktufajar).inSeconds;
                            int _selisihdzuhur = DateTime.parse(_jamsaatini!).difference(_waktudzuhur).inSeconds;
                            int _selisihashar = DateTime.parse(_jamsaatini!).difference(_waktuashar).inSeconds;
                            int _selisihmagrib = DateTime.parse(_jamsaatini!).difference(_waktumagrib).inSeconds;
                            int _selisihisya = DateTime.parse(_jamsaatini!).difference(_waktuisya).inSeconds;

                            if(_selisihsubuh>0 && _selisihfajar<0){
                              _shalatsekarang = "subuh";
                              _shalatsekarang2 = "Subuh";
                            } else if(_selisihfajar>0 && _selisihdzuhur<0){
                              _shalatsekarang = "fajar";
                              _shalatsekarang2 = "Terbit Fajar";
                            } else if(_selisihdzuhur>0 && _selisihashar<0){
                              _shalatsekarang = "dzuhur";
                              _shalatsekarang2 = "Dzuhur";
                            } else if(_selisihashar>0 && _selisihmagrib<0){
                              _shalatsekarang = "ashar";
                              _shalatsekarang2 = "Ashar";
                            } else if(_selisihmagrib>0 && _selisihisya<0){
                              _shalatsekarang = "magrib";
                              _shalatsekarang2 = "Magrib";
                            } else {
                              _shalatsekarang = "isya";
                              _shalatsekarang2 = "Isya";
                            }

                            return Container(
                              constraints: BoxConstraints.expand(
                                height: 734*fem,
                                // width: 300*fem
                              ),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/image/bg_" + _shalatsekarang.toString() + ".png"),
                                  // image: AssetImage("assets/image/bg_fajar.png"),
                                  fit: BoxFit.cover
                                ),
                              ),
                              child: Scaffold(
                                resizeToAvoidBottomInset: true,
                                backgroundColor: Colors.transparent,
                                appBar: AppBar(
                                  title: Text("Jadwal Shalat", style: TextStyle(fontFamily: "Inter Bold",color: Colors.white)),
                                  centerTitle: true,
                                  iconTheme: IconThemeData(color: Colors.white),
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  leading: CoreLeading(page: 0, color: Colors.white),
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
                                body: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.fromLTRB(15*fem, 30*fem, 15*fem, 0),
                                  child: Column(
                                    children: [
                                      Text(waktushalat.kota!, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20*ffem),),
                                      SizedBox(height: 5*fem,),
                                      Text(DateFormat("HH:mm:ss").format(DateTime.now()), style: TextStyle(fontFamily: "Inter Bold", fontSize: 50*ffem, color: Colors.white),),

                                      SizedBox(height: 230*fem,),

                                      Container(
                                        width: double.infinity,
                                        margin: EdgeInsets.only(bottom: 10*fem),
                                        decoration: BoxDecoration(
                                          color: (_shalatsekarang2=="Subuh") ? Colors.white.withOpacity(1) : Colors.white.withOpacity(0.6),
                                          borderRadius: BorderRadius.circular(10*fem)
                                        ),
                                        child: ListTile(
                                          leading: Padding(
                                            padding: EdgeInsets.all(4*fem),
                                            child: SizedBox(
                                              height: 22*fem,
                                              width: 22*fem,
                                              child: CircleAvatar(
                                                backgroundColor: waktushalat.subuh_cek==1? Palette.success : Palette.dangers,
                                                child: Center(
                                                  child: waktushalat.subuh_cek==1?Icon(FontAwesomeIcons.check, color: Colors.white, size: 18*ffem,):Icon(FontAwesomeIcons.times, color: Colors.white, size: 16*ffem,),
                                                ),
                                              ),
                                            ),
                                          ),
                                          title: Text("Subuh", style: TextStyle(fontFamily: (_shalatsekarang2=="Subuh") ? "Inter Bold" : "Inter", fontSize: 18*ffem),),
                                          visualDensity: VisualDensity(vertical: -3),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(waktushalat.subuh!.substring(0,5), style: TextStyle(fontFamily: (_shalatsekarang2=="Subuh") ? "Inter Bold" : "Inter", fontSize: 18*ffem),),
                                              SizedBox(width: 3*fem,),
                                              GestureDetector(
                                                child: Icon(Icons.more_horiz, size: 24*ffem, color: Colors.black,),
                                                onTap: (){
                                                  showModalBottomSheet(
                                                      context: context,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.vertical(
                                                          top: Radius.circular(10*fem),
                                                        ),
                                                      ),
                                                      builder:(context) {
                                                        return Container(
                                                          height: 90*fem,
                                                          child: Column(
                                                            children: [
                                                              SizedBox(height: 10*fem,),
                                                              Container(
                                                                width: 65*fem,
                                                                height: 5*fem,
                                                                decoration: BoxDecoration(
                                                                    color: Colors.grey,
                                                                    borderRadius: BorderRadius.circular(10*fem)
                                                                ),
                                                              ),
                                                              SizedBox(height: 10*fem,),

                                                              waktushalat.subuh_cek.toString()=="0"? // jika belum shalat
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Navigator.pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) {
                                                                        return MultiBlocProvider(
                                                                          providers: [
                                                                            BlocProvider<DatabaseCubit>(
                                                                              create: (context) => DatabaseCubit()..initDB(),
                                                                            ),
                                                                            BlocProvider<WaktuShalatCubit>(
                                                                              create: (context) => WaktuShalatCubit(database: context.read<DatabaseCubit>().database!)..setSudahShalat('subuh_cek', waktushalat.id!.toString()),
                                                                            ),
                                                                          ],
                                                                          child: JadwalShalatPage(),
                                                                        );
                                                                      },
                                                                    ),
                                                                  );
                                                                },
                                                                child: ListTile(
                                                                  leading: Icon(Icons.check_circle, size: 24*ffem,),
                                                                  title: Text("Tandai Sudah Shalat Subuh", style: TextStyle(fontSize: 14*ffem),),
                                                                ),
                                                              )
                                                                  : // jika membatalkan
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Navigator.pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) {
                                                                        return MultiBlocProvider(
                                                                          providers: [
                                                                            BlocProvider<DatabaseCubit>(
                                                                              create: (context) => DatabaseCubit()..initDB(),
                                                                            ),
                                                                            BlocProvider<WaktuShalatCubit>(
                                                                              create: (context) => WaktuShalatCubit(database: context.read<DatabaseCubit>().database!)..setBelumShalat('subuh_cek', waktushalat.id!.toString()),
                                                                            ),
                                                                          ],
                                                                          child: JadwalShalatPage(),
                                                                        );
                                                                      },
                                                                    ),
                                                                  );
                                                                },
                                                                child: ListTile(
                                                                  leading: Icon(Icons.check_circle, size: 24*ffem,),
                                                                  title: Text("Tandai Belum Shalat Subuh", style: TextStyle(fontSize: 16*ffem),),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      }
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        margin: EdgeInsets.only(bottom: 10*fem),
                                        decoration: BoxDecoration(
                                            color: (_shalatsekarang2=="Dzuhur") ? Colors.white.withOpacity(1) : Colors.white.withOpacity(0.6),
                                            borderRadius: BorderRadius.circular(10*fem)
                                        ),
                                        child: ListTile(
                                          leading: Padding(
                                            padding: EdgeInsets.all(4*fem),
                                            child: SizedBox(
                                              height: 22*fem,
                                              width: 22*fem,
                                              child: CircleAvatar(
                                                backgroundColor: waktushalat.dzuhur_cek==1? Palette.success : Palette.dangers,
                                                child: Center(
                                                  child: waktushalat.dzuhur_cek==1?Icon(FontAwesomeIcons.check, color: Colors.white, size: 16*ffem,):Icon(FontAwesomeIcons.times, color: Colors.white, size: 16*ffem,),
                                                ),
                                              ),
                                            ),
                                          ),
                                          title: Text("Dzuhur", style: TextStyle(fontFamily: (_shalatsekarang2=="Dzuhur") ? "Inter Bold" : "Inter", fontSize: 18*ffem),),
                                          visualDensity: VisualDensity(vertical: -3),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(waktushalat.dzuhur!.substring(0,5), style: TextStyle(fontFamily: (_shalatsekarang2=="Dzuhur") ? "Inter Bold" : "Inter", fontSize: 18*ffem),),
                                              SizedBox(width: 3*fem,),
                                              GestureDetector(
                                                child: Icon(Icons.more_horiz, size: 24*ffem, color: Colors.black,),
                                                onTap: (){
                                                  showModalBottomSheet(
                                                      context: context,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.vertical(
                                                          top: Radius.circular(10*fem),
                                                        ),
                                                      ),
                                                      builder:(context) {
                                                        return Container(
                                                          height: 90*fem,
                                                          child: Column(
                                                            children: [
                                                              SizedBox(height: 10*fem,),
                                                              Container(
                                                                width: 65*fem,
                                                                height: 5*fem,
                                                                decoration: BoxDecoration(
                                                                    color: Colors.grey,
                                                                    borderRadius: BorderRadius.circular(10*fem)
                                                                ),
                                                              ),
                                                              SizedBox(height: 10*fem,),

                                                              waktushalat.dzuhur_cek.toString()=="0"? // jika belum shalat
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Navigator.pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) {
                                                                        return MultiBlocProvider(
                                                                          providers: [
                                                                            BlocProvider<DatabaseCubit>(
                                                                              create: (context) => DatabaseCubit()..initDB(),
                                                                            ),
                                                                            BlocProvider<WaktuShalatCubit>(
                                                                              create: (context) => WaktuShalatCubit(database: context.read<DatabaseCubit>().database!)..setSudahShalat('dzuhur_cek', waktushalat.id!.toString()),
                                                                            ),
                                                                          ],
                                                                          child: JadwalShalatPage(),
                                                                        );
                                                                      },
                                                                    ),
                                                                  );
                                                                },
                                                                child: ListTile(
                                                                  leading: Icon(Icons.check_circle, size: 24*ffem,),
                                                                  title: Text("Tandai Sudah Shalat Dzuhur", style: TextStyle(fontSize: 14*ffem),),
                                                                ),
                                                              )
                                                                  : // jika membatalkan
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Navigator.pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) {
                                                                        return MultiBlocProvider(
                                                                          providers: [
                                                                            BlocProvider<DatabaseCubit>(
                                                                              create: (context) => DatabaseCubit()..initDB(),
                                                                            ),
                                                                            BlocProvider<WaktuShalatCubit>(
                                                                              create: (context) => WaktuShalatCubit(database: context.read<DatabaseCubit>().database!)..setBelumShalat('dzuhur_cek', waktushalat.id!.toString()),
                                                                            ),
                                                                          ],
                                                                          child: JadwalShalatPage(),
                                                                        );
                                                                      },
                                                                    ),
                                                                  );
                                                                },
                                                                child: ListTile(
                                                                  leading: Icon(Icons.check_circle, size: 24*ffem,),
                                                                  title: Text("Tandai Belum Shalat Dzuhur", style: TextStyle(fontSize: 16*ffem),),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      }
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        margin: EdgeInsets.only(bottom: 10*fem),
                                        decoration: BoxDecoration(
                                            color: (_shalatsekarang2=="Ashar") ? Colors.white.withOpacity(1) : Colors.white.withOpacity(0.6),
                                            borderRadius: BorderRadius.circular(10*fem)
                                        ),
                                        child: ListTile(
                                          leading: Padding(
                                            padding: EdgeInsets.all(4*fem),
                                            child: SizedBox(
                                              height: 22*fem,
                                              width: 22*fem,
                                              child: CircleAvatar(
                                                backgroundColor: waktushalat.ashar_cek==1? Palette.success : Palette.dangers,
                                                child: Center(
                                                  child: waktushalat.ashar_cek==1?Icon(FontAwesomeIcons.check, color: Colors.white, size: 16*ffem,):Icon(FontAwesomeIcons.times, color: Colors.white, size: 16*ffem,),
                                                ),
                                              ),
                                            ),
                                          ),
                                          title: Text("Ashar", style: TextStyle(fontFamily: (_shalatsekarang2=="Ashar") ? "Inter Bold" : "Inter", fontSize: 18*ffem),),
                                          visualDensity: VisualDensity(vertical: -3),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(waktushalat.ashar!.substring(0,5), style: TextStyle(fontFamily: (_shalatsekarang2=="Ashar") ? "Inter Bold" : "Inter", fontSize: 18*ffem),),
                                              SizedBox(width: 3*fem,),
                                              GestureDetector(
                                                child: Icon(Icons.more_horiz, size: 24*ffem, color: Colors.black,),
                                                onTap: (){
                                                  showModalBottomSheet(
                                                      context: context,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.vertical(
                                                          top: Radius.circular(10*fem),
                                                        ),
                                                      ),
                                                      builder:(context) {
                                                        return Container(
                                                          height: 90*fem,
                                                          child: Column(
                                                            children: [
                                                              SizedBox(height: 10*fem,),
                                                              Container(
                                                                width: 65*fem,
                                                                height: 5*fem,
                                                                decoration: BoxDecoration(
                                                                    color: Colors.grey,
                                                                    borderRadius: BorderRadius.circular(10*fem)
                                                                ),
                                                              ),
                                                              SizedBox(height: 10*fem,),

                                                              waktushalat.ashar_cek.toString()=="0"? // jika belum shalat
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Navigator.pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) {
                                                                        return MultiBlocProvider(
                                                                          providers: [
                                                                            BlocProvider<DatabaseCubit>(
                                                                              create: (context) => DatabaseCubit()..initDB(),
                                                                            ),
                                                                            BlocProvider<WaktuShalatCubit>(
                                                                              create: (context) => WaktuShalatCubit(database: context.read<DatabaseCubit>().database!)..setSudahShalat('ashar_cek', waktushalat.id!.toString()),
                                                                            ),
                                                                          ],
                                                                          child: JadwalShalatPage(),
                                                                        );
                                                                      },
                                                                    ),
                                                                  );
                                                                },
                                                                child: ListTile(
                                                                  leading: Icon(Icons.check_circle, size: 24*ffem,),
                                                                  title: Text("Tandai Sudah Shalat Ashar", style: TextStyle(fontSize: 14*ffem),),
                                                                ),
                                                              )
                                                                  : // jika membatalkan
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Navigator.pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) {
                                                                        return MultiBlocProvider(
                                                                          providers: [
                                                                            BlocProvider<DatabaseCubit>(
                                                                              create: (context) => DatabaseCubit()..initDB(),
                                                                            ),
                                                                            BlocProvider<WaktuShalatCubit>(
                                                                              create: (context) => WaktuShalatCubit(database: context.read<DatabaseCubit>().database!)..setBelumShalat('ashar_cek', waktushalat.id!.toString()),
                                                                            ),
                                                                          ],
                                                                          child: JadwalShalatPage(),
                                                                        );
                                                                      },
                                                                    ),
                                                                  );
                                                                },
                                                                child: ListTile(
                                                                  leading: Icon(Icons.check_circle, size: 24*ffem,),
                                                                  title: Text("Tandai Belum Shalat Ashar", style: TextStyle(fontSize: 16*ffem),),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      }
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        margin: EdgeInsets.only(bottom: 10*fem),
                                        decoration: BoxDecoration(
                                            color: (_shalatsekarang2=="Magrib") ? Colors.white.withOpacity(1) : Colors.white.withOpacity(0.6),
                                            borderRadius: BorderRadius.circular(10*fem)
                                        ),
                                        child: ListTile(
                                          leading: Padding(
                                            padding: EdgeInsets.all(4*fem),
                                            child: SizedBox(
                                              height: 22*fem,
                                              width: 22*fem,
                                              child: CircleAvatar(
                                                backgroundColor: waktushalat.magrib_cek==1? Palette.success : Palette.dangers,
                                                child: Center(
                                                  child: waktushalat.magrib_cek==1?Icon(FontAwesomeIcons.check, color: Colors.white, size: 16*ffem,):Icon(FontAwesomeIcons.times, color: Colors.white, size: 16*ffem,),
                                                ),
                                              ),
                                            ),
                                          ),
                                          title: Text("Magrib", style: TextStyle(fontFamily: (_shalatsekarang2=="Magrib") ? "Inter Bold" : "Inter", fontSize: 18*ffem),),
                                          visualDensity: VisualDensity(vertical: -3),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(waktushalat.magrib!.substring(0,5), style: TextStyle(fontFamily: (_shalatsekarang2=="Magrib") ? "Inter Bold" : "Inter", fontSize: 18*ffem),),
                                              SizedBox(width: 3*fem,),
                                              GestureDetector(
                                                child: Icon(Icons.more_horiz, size: 24*ffem, color: Colors.black,),
                                                onTap: (){
                                                  showModalBottomSheet(
                                                      context: context,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.vertical(
                                                          top: Radius.circular(10*fem),
                                                        ),
                                                      ),
                                                      builder:(context) {
                                                        return Container(
                                                          height: 90*fem,
                                                          child: Column(
                                                            children: [
                                                              SizedBox(height: 10*fem,),
                                                              Container(
                                                                width: 65*fem,
                                                                height: 5*fem,
                                                                decoration: BoxDecoration(
                                                                    color: Colors.grey,
                                                                    borderRadius: BorderRadius.circular(10*fem)
                                                                ),
                                                              ),
                                                              SizedBox(height: 10*fem,),

                                                              waktushalat.magrib_cek.toString()=="0"? // jika belum shalat
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Navigator.pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) {
                                                                        return MultiBlocProvider(
                                                                          providers: [
                                                                            BlocProvider<DatabaseCubit>(
                                                                              create: (context) => DatabaseCubit()..initDB(),
                                                                            ),
                                                                            BlocProvider<WaktuShalatCubit>(
                                                                              create: (context) => WaktuShalatCubit(database: context.read<DatabaseCubit>().database!)..setSudahShalat('magrib_cek', waktushalat.id!.toString()),
                                                                            ),
                                                                          ],
                                                                          child: JadwalShalatPage(),
                                                                        );
                                                                      },
                                                                    ),
                                                                  );
                                                                },
                                                                child: ListTile(
                                                                  leading: Icon(Icons.check_circle, size: 24*ffem,),
                                                                  title: Text("Tandai Sudah Shalat Magrib", style: TextStyle(fontSize: 14*ffem),),
                                                                ),
                                                              )
                                                                  : // jika membatalkan
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Navigator.pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) {
                                                                        return MultiBlocProvider(
                                                                          providers: [
                                                                            BlocProvider<DatabaseCubit>(
                                                                              create: (context) => DatabaseCubit()..initDB(),
                                                                            ),
                                                                            BlocProvider<WaktuShalatCubit>(
                                                                              create: (context) => WaktuShalatCubit(database: context.read<DatabaseCubit>().database!)..setBelumShalat('magrib_cek', waktushalat.id!.toString()),
                                                                            ),
                                                                          ],
                                                                          child: JadwalShalatPage(),
                                                                        );
                                                                      },
                                                                    ),
                                                                  );
                                                                },
                                                                child: ListTile(
                                                                  leading: Icon(Icons.check_circle, size: 24*ffem,),
                                                                  title: Text("Tandai Belum Shalat Magrib", style: TextStyle(fontSize: 16*ffem),),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      }
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        margin: EdgeInsets.only(bottom: 5*fem),
                                        decoration: BoxDecoration(
                                            color: (_shalatsekarang2=="Isya") ? Colors.white.withOpacity(1) : Colors.white.withOpacity(0.6),
                                            borderRadius: BorderRadius.circular(10*fem)
                                        ),
                                        child: ListTile(
                                          leading: Padding(
                                            padding: EdgeInsets.all(4*fem),
                                            child: SizedBox(
                                              height: 22*fem,
                                              width: 22*fem,
                                              child: CircleAvatar(
                                                backgroundColor: waktushalat.isya_cek==1? Palette.success : Palette.dangers,
                                                child: Center(
                                                  child: waktushalat.isya_cek==1?Icon(FontAwesomeIcons.check, color: Colors.white, size: 16*ffem,):Icon(FontAwesomeIcons.times, color: Colors.white, size: 16*ffem,),
                                                ),
                                              ),
                                            ),
                                          ),
                                          title: Text("Isya", style: TextStyle(fontFamily: (_shalatsekarang2=="Isya") ? "Inter Bold" : "Inter", fontSize: 18*ffem),),
                                          visualDensity: VisualDensity(vertical: -3),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(waktushalat.isya!.substring(0,5), style: TextStyle(fontFamily: (_shalatsekarang2=="Isya") ? "Inter Bold" : "Inter", fontSize: 18*ffem),),
                                              SizedBox(width: 3*fem,),
                                              GestureDetector(
                                                child: Icon(Icons.more_horiz, size: 24*ffem, color: Colors.black,),
                                                onTap: (){
                                                  showModalBottomSheet(
                                                      context: context,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.vertical(
                                                          top: Radius.circular(10*fem),
                                                        ),
                                                      ),
                                                      builder:(context) {
                                                        return Container(
                                                          height: 90*fem,
                                                          child: Column(
                                                            children: [
                                                              SizedBox(height: 10*fem,),
                                                              Container(
                                                                width: 65*fem,
                                                                height: 5*fem,
                                                                decoration: BoxDecoration(
                                                                    color: Colors.grey,
                                                                    borderRadius: BorderRadius.circular(10*fem)
                                                                ),
                                                              ),
                                                              SizedBox(height: 10*fem,),

                                                              waktushalat.isya_cek.toString()=="0"? // jika belum shalat
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Navigator.pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) {
                                                                        return MultiBlocProvider(
                                                                          providers: [
                                                                            BlocProvider<DatabaseCubit>(
                                                                              create: (context) => DatabaseCubit()..initDB(),
                                                                            ),
                                                                            BlocProvider<WaktuShalatCubit>(
                                                                              create: (context) => WaktuShalatCubit(database: context.read<DatabaseCubit>().database!)..setSudahShalat('isya_cek', waktushalat.id!.toString()),
                                                                            ),
                                                                          ],
                                                                          child: JadwalShalatPage(),
                                                                        );
                                                                      },
                                                                    ),
                                                                  );
                                                                },
                                                                child: ListTile(
                                                                  leading: Icon(Icons.check_circle, size: 24*ffem,),
                                                                  title: Text("Tandai Sudah Shalat Isya", style: TextStyle(fontSize: 14*ffem),),
                                                                ),
                                                              )
                                                                  : // jika membatalkan
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Navigator.pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) {
                                                                        return MultiBlocProvider(
                                                                          providers: [
                                                                            BlocProvider<DatabaseCubit>(
                                                                              create: (context) => DatabaseCubit()..initDB(),
                                                                            ),
                                                                            BlocProvider<WaktuShalatCubit>(
                                                                              create: (context) => WaktuShalatCubit(database: context.read<DatabaseCubit>().database!)..setBelumShalat('isya_cek', waktushalat.id!.toString()),
                                                                            ),
                                                                          ],
                                                                          child: JadwalShalatPage(),
                                                                        );
                                                                      },
                                                                    ),
                                                                  );
                                                                },
                                                                child: ListTile(
                                                                  leading: Icon(Icons.check_circle, size: 24*ffem,),
                                                                  title: Text("Tandai Belum Shalat Isya", style: TextStyle(fontSize: 16*ffem),),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      }
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      Divider(color: Colors.white),

                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: (_shalatsekarang2=="Terbit Fajar") ? Colors.white.withOpacity(1) : Colors.white.withOpacity(0.6),
                                            borderRadius: BorderRadius.circular(10*fem)
                                        ),
                                        child: ListTile(
                                          leading: Padding(
                                            padding: EdgeInsets.all(4*fem),
                                            child: SizedBox(
                                              height: 22*fem,
                                              width: 22*fem,
                                              child: CircleAvatar(
                                                backgroundColor: Palette.info,
                                                child: Center(
                                                  child: Icon(FontAwesomeIcons.info, color: Colors.white, size: 14*ffem,)
                                                ),
                                              ),
                                            ),
                                          ),
                                          title: Text("Terbit Fajar", style: TextStyle(fontFamily: (_shalatsekarang2=="Terbit Fajar") ? "Inter Bold" : "Inter", fontSize: 18*ffem),),
                                          visualDensity: VisualDensity(vertical: -3),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(waktushalat.fajar!.substring(0,5), style: TextStyle(fontFamily: (_shalatsekarang2=="Terbit Fajar") ? "Inter Bold" : "Inter", fontSize: 18*ffem),),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                      ),
                    );
                  } else {
                    return Container();
                  }
                }
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Widget wNowNext(){
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Row(
      children: [
        BlocBuilder<WaktuShalatCubit, WaktuShalatState>(
            builder: (context, state){
              if(state is WaktuShalatSuccess){
                return Expanded(
                  child: ListView.builder(
                      physics: ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: state.waktushalat.length,
                      itemBuilder: (context, index){
                        final waktushalat = state.waktushalat[index];

                        String subuh = waktushalat.tanggal! + " " + waktushalat.subuh!;
                        String fajar = waktushalat.tanggal! + " " + waktushalat.fajar!;
                        String dzuhur = waktushalat.tanggal! + " " + waktushalat.dzuhur!;
                        String ashar = waktushalat.tanggal! + " " + waktushalat.ashar!;
                        String magrib = waktushalat.tanggal! + " " + waktushalat.magrib!;
                        String isya = waktushalat.tanggal! + " " + waktushalat.isya!;

                        DateTime _waktusubuh = DateTime.parse(subuh);
                        DateTime _waktufajar = DateTime.parse(fajar);
                        DateTime _waktudzuhur = DateTime.parse(dzuhur);
                        DateTime _waktuashar = DateTime.parse(ashar);
                        DateTime _waktumagrib = DateTime.parse(magrib);
                        DateTime _waktuisya = DateTime.parse(isya);

                        int _selisihsubuh = DateTime.parse(_jamsaatini!).difference(_waktusubuh).inSeconds;
                        int _selisihfajar = DateTime.parse(_jamsaatini!).difference(_waktufajar).inSeconds;
                        int _selisihdzuhur = DateTime.parse(_jamsaatini!).difference(_waktudzuhur).inSeconds;
                        int _selisihashar = DateTime.parse(_jamsaatini!).difference(_waktuashar).inSeconds;
                        int _selisihmagrib = DateTime.parse(_jamsaatini!).difference(_waktumagrib).inSeconds;
                        int _selisihisya = DateTime.parse(_jamsaatini!).difference(_waktuisya).inSeconds;

                        if(_selisihsubuh>0 && _selisihfajar<0){
                          _shalatsekarang = "Subuh";
                          _shalatwaktusekarang = waktushalat.subuh;
                          _shalatwaktuselesaisekarang = waktushalat.dzuhur;
                        } else if(_selisihdzuhur>0 && _selisihashar<0){
                          _shalatsekarang = "Dzuhur";
                          _shalatwaktusekarang = waktushalat.dzuhur;
                          _shalatwaktuselesaisekarang = waktushalat.ashar;
                        } else if(_selisihashar>0 && _selisihmagrib<0){
                          _shalatsekarang = "Ashar";
                          _shalatwaktusekarang = waktushalat.ashar;
                          _shalatwaktuselesaisekarang = waktushalat.magrib;
                        } else if(_selisihmagrib>0 && _selisihisya<0){
                          _shalatsekarang = "Magrib";
                          _shalatwaktusekarang = waktushalat.magrib;
                          _shalatwaktuselesaisekarang = waktushalat.isya;
                        } else if(_selisihisya>0 || _selisihisya<0){
                          _shalatsekarang = "Isya";
                          _shalatwaktusekarang = waktushalat.isya;
                          _shalatwaktuselesaisekarang = waktushalat.subuh;
                        } else {
                          _shalatsekarang = "-";
                          _shalatwaktusekarang = "00:00";
                          _shalatwaktuselesaisekarang = "00:00";
                        }
                        return Container(
                          margin: EdgeInsets.fromLTRB(10*fem, 0*fem, 0*fem, 0*fem),
                          padding: EdgeInsets.fromLTRB(10*fem, 20*fem, 10*fem, 20*fem),
                          decoration: BoxDecoration(
                            color: Palette.primary,
                            borderRadius: BorderRadius.circular(20*fem),
                            image: DecorationImage(
                                image: AssetImage("assets/image/banner_home.png"),
                                fit: BoxFit.cover,
                                opacity: 0.8
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Saat ini:", style: TextStyle(color: Colors.white, fontSize: 14*ffem),),
                              SizedBox(height: 15*fem,),
                              Text(_shalatsekarang!, style: TextStyle(color: Colors.white, fontSize: 20*ffem),),
                              Text(_shalatwaktusekarang!.substring(0,5), style: TextStyle(color: Colors.white, fontSize: 40*ffem),),
                              Text("Berakhir sampai " + _shalatwaktuselesaisekarang!.substring(0,5), style: TextStyle(color: Colors.white, fontSize: 12*ffem),),
                            ],
                          ),
                        );
                      }
                  ),
                );
              } else {
                return Container();
              }
            }
        ),
        SizedBox(width: 8*fem,),
        BlocBuilder<WaktuShalatCubit, WaktuShalatState>(
            builder: (context, state){
              if(state is WaktuShalatSuccess){
                return Expanded(
                  child: ListView.builder(
                      physics: ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: state.waktushalat.length,
                      itemBuilder: (context, index){
                        final waktushalat = state.waktushalat[index];

                        String subuh = waktushalat.tanggal! + " " + waktushalat.subuh!;
                        String fajar = waktushalat.tanggal! + " " + waktushalat.fajar!;
                        String dzuhur = waktushalat.tanggal! + " " + waktushalat.dzuhur!;
                        String ashar = waktushalat.tanggal! + " " + waktushalat.ashar!;
                        String magrib = waktushalat.tanggal! + " " + waktushalat.magrib!;
                        String isya = waktushalat.tanggal! + " " + waktushalat.isya!;

                        DateTime _waktusubuh = DateTime.parse(subuh);
                        DateTime _waktufajar = DateTime.parse(fajar);
                        DateTime _waktudzuhur = DateTime.parse(dzuhur);
                        DateTime _waktuashar = DateTime.parse(ashar);
                        DateTime _waktumagrib = DateTime.parse(magrib);
                        DateTime _waktuisya = DateTime.parse(isya);

                        int _selisihsubuh = DateTime.parse(_jamsaatini!).difference(_waktusubuh).inSeconds;
                        int _selisihfajar = DateTime.parse(_jamsaatini!).difference(_waktufajar).inSeconds;
                        int _selisihdzuhur = DateTime.parse(_jamsaatini!).difference(_waktudzuhur).inSeconds;
                        int _selisihashar = DateTime.parse(_jamsaatini!).difference(_waktuashar).inSeconds;
                        int _selisihmagrib = DateTime.parse(_jamsaatini!).difference(_waktumagrib).inSeconds;
                        int _selisihisya = DateTime.parse(_jamsaatini!).difference(_waktuisya).inSeconds;

                        if(_selisihsubuh>0 && _selisihfajar<0){
                          _shalatselanjutnya = "-";
                          _shalatwaktuselanjutnya = "00:00";
                          _shalatwaktuselesaiselanjutnya = "00:00";
                        } else if(_selisihdzuhur>0 && _selisihashar<0){
                          _shalatselanjutnya = "Ashar";
                          _shalatwaktuselanjutnya = waktushalat.ashar;
                          _shalatwaktuselesaiselanjutnya = waktushalat.magrib;
                        } else if(_selisihashar>0 && _selisihmagrib<0){
                          _shalatselanjutnya = "Magrib";
                          _shalatwaktuselanjutnya = waktushalat.magrib;
                          _shalatwaktuselesaiselanjutnya = waktushalat.isya;
                        } else if(_selisihmagrib>0 && _selisihisya<0){
                          _shalatselanjutnya = "Isya";
                          _shalatwaktuselanjutnya = waktushalat.isya;
                          _shalatwaktuselesaiselanjutnya = waktushalat.subuh;
                        } else if(_selisihisya>0 || _selisihisya<0){
                          _shalatselanjutnya = "Subuh";
                          _shalatwaktuselanjutnya = waktushalat.subuh;
                          _shalatwaktuselesaiselanjutnya = waktushalat.fajar;
                        } else {
                          _shalatselanjutnya = "Dzuhur";
                          _shalatwaktuselanjutnya = waktushalat.dzuhur;
                          _shalatwaktuselesaiselanjutnya = waktushalat.ashar;
                        }
                        return Container(
                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 10*fem, 0*fem),
                          padding: EdgeInsets.fromLTRB(10*fem, 20*fem, 10*fem, 20*fem),
                          decoration: BoxDecoration(
                            color: Palette.secondary,
                            borderRadius: BorderRadius.circular(20*fem),
                            image: DecorationImage(
                                image: AssetImage("assets/image/banner_home2.png"),
                                fit: BoxFit.cover,
                                opacity: 0.8
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Selanjutnya:", style: TextStyle(color: Colors.white, fontSize: 14*ffem),),
                              SizedBox(height: 15*fem,),
                              Text(_shalatselanjutnya!, style: TextStyle(color: Colors.white, fontFamily: "Inter Bold", fontSize: 20*ffem),),
                              Text(_shalatwaktuselanjutnya!.substring(0,5), style: TextStyle(color: Colors.white, fontSize: 40*ffem),),
                              Text("Berakhir sampai " + _shalatwaktuselesaiselanjutnya!.substring(0,5), style: TextStyle(color: Colors.white, fontSize: 12*ffem),),
                            ],
                          ),
                        );
                      }
                  ),
                );
              } else {
                return Container();
              }
            }
        ),
      ],
    );
  }

  Widget wTanggalShalat(){
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return BlocBuilder<WaktuShalatCubit, WaktuShalatState>(
        builder: (context, state){
          if(state is WaktuShalatSuccess){
            return ListView.builder(
              // physics: ScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: state.waktushalat.length,
                itemBuilder: (context, index) {
                  final waktushalat = state.waktushalat[index];
                  return Padding(
                    padding: EdgeInsets.fromLTRB(15*fem, 0, 15*fem, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return MultiBlocProvider(
                                      providers: [
                                        BlocProvider<DatabaseCubit>(
                                          create: (context) => DatabaseCubit()..initDB(),
                                        ),
                                        BlocProvider<WaktuShalatCubit>(
                                          create: (context) => WaktuShalatCubit(database: context.read<DatabaseCubit>().database!)..getTanggalSebelumnya(waktushalat.id!.toString()),
                                        ),
                                      ],
                                      child: JadwalShalatPage(),
                                    );
                                  },
                                ),
                              );
                            },
                            child: Icon(FontAwesomeIcons.arrowLeftLong, color: Colors.black, size: 30*ffem,)
                        ),
                        Column(
                          children: [
                            // Text(formatTglIndo(DateTime.now().toString()), style: TextStyle(fontFamily: "Inter Bold", fontSize: 16*ffem)),
                            Text(formatTglIndo(waktushalat.tanggal.toString()), style: TextStyle(fontFamily: "Inter Bold", fontSize: 16*ffem)),
                            // Text(HijriCalendar.now().hDay.toString() + " " + HijriCalendar.now().getLongMonthName().toString() + " " + HijriCalendar.now().hYear.toString() + ' H', style: TextStyle(fontSize: 16*ffem)),
                            Text(HijriCalendar.fromDate(DateTime.parse(waktushalat.tanggal.toString() + " 00:00:00")).hDay.toString() + " " + HijriCalendar.fromDate(DateTime.parse(waktushalat.tanggal.toString() + " 00:00:00")).getLongMonthName().toString() + " " + HijriCalendar.fromDate(DateTime.parse(waktushalat.tanggal.toString() + " 00:00:00")).hYear.toString(), style: TextStyle(fontSize: 16*ffem)),
                          ],
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return MultiBlocProvider(
                                      providers: [
                                        BlocProvider<DatabaseCubit>(
                                          create: (context) => DatabaseCubit()..initDB(),
                                        ),
                                        BlocProvider<WaktuShalatCubit>(
                                          create: (context) => WaktuShalatCubit(database: context.read<DatabaseCubit>().database!)..getTanggalSetelahnya(waktushalat.id!.toString()),
                                        ),
                                      ],
                                      child: JadwalShalatPage(),
                                    );
                                  },
                                ),
                              );
                            },
                            child: Icon(FontAwesomeIcons.arrowRightLong, color: Colors.black, size: 30*ffem,)
                        ),
                      ],
                    ),
                  );
                }
            );
          } else {
            return Container();
          }
        }
    );
  }

  Widget wListWaktuShalat(){
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return BlocBuilder<WaktuShalatCubit, WaktuShalatState>(
        builder: (context, state){
          if(state is WaktuShalatSuccess){
            return ListView.builder(
              // physics: ScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: state.waktushalat.length,
                itemBuilder: (context, index){
                  final waktushalat = state.waktushalat[index];
                  return Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(10*fem, 0*fem, 10*fem, 8*fem),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10*fem),
                          color: Colors.white,
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 75*fem,
                            height: 75*fem,
                            decoration: BoxDecoration(
                              color: Palette.primary,
                              borderRadius: BorderRadius.circular(5*fem),
                              image: DecorationImage(
                                image: AssetImage("assets/image/waktu_shalat_subuh.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text("Subuh", style: TextStyle(fontSize: 20*ffem, fontFamily: "Inter Bold"),),
                          subtitle: Text("Waktu Shalat: " + waktushalat.subuh!.substring(0,5), style: TextStyle(fontSize: 12*ffem),),
                          trailing: Wrap(
                            children: [
                              waktushalat.subuh_cek.toString()=="0"? // jika belum shalat
                              Icon(FontAwesomeIcons.timesCircle, size: 24*ffem, color: Palette.dangers,)
                                  : // jika sudah shalat
                              Icon(FontAwesomeIcons.circleCheck, size: 24*ffem, color: Palette.success,),
                              SizedBox(width: 5*fem,),
                              GestureDetector(
                                child: Icon(Icons.more_horiz, size: 24*ffem, color: Colors.black,),
                                onTap: (){
                                  showModalBottomSheet(
                                      context: context,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(10*fem),
                                        ),
                                      ),
                                      builder:(context) {
                                        return Container(
                                          height: 90*fem,
                                          child: Column(
                                            children: [
                                              SizedBox(height: 10*fem,),
                                              Container(
                                                width: 65*fem,
                                                height: 5*fem,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius: BorderRadius.circular(10*fem)
                                                ),
                                              ),
                                              SizedBox(height: 10*fem,),

                                              waktushalat.subuh_cek.toString()=="0"? // jika belum shalat
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) {
                                                        return MultiBlocProvider(
                                                          providers: [
                                                            BlocProvider<DatabaseCubit>(
                                                              create: (context) => DatabaseCubit()..initDB(),
                                                            ),
                                                            BlocProvider<WaktuShalatCubit>(
                                                              create: (context) => WaktuShalatCubit(database: context.read<DatabaseCubit>().database!)..setSudahShalat('subuh_cek', waktushalat.id!.toString()),
                                                            ),
                                                          ],
                                                          child: JadwalShalatPage(),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                                child: ListTile(
                                                  leading: Icon(Icons.check_circle, size: 24*ffem,),
                                                  title: Text("Tandai Sudah Shalat Subuh", style: TextStyle(fontSize: 14*ffem),),
                                                ),
                                              )
                                                  : // jika membatalkan
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) {
                                                        return MultiBlocProvider(
                                                          providers: [
                                                            BlocProvider<DatabaseCubit>(
                                                              create: (context) => DatabaseCubit()..initDB(),
                                                            ),
                                                            BlocProvider<WaktuShalatCubit>(
                                                              create: (context) => WaktuShalatCubit(database: context.read<DatabaseCubit>().database!)..setBelumShalat('subuh_cek', waktushalat.id!.toString()),
                                                            ),
                                                          ],
                                                          child: JadwalShalatPage(),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                                child: ListTile(
                                                  leading: Icon(Icons.check_circle, size: 24*ffem,),
                                                  title: Text("Tandai Belum Shalat Subuh", style: TextStyle(fontSize: 16*ffem),),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10*fem, 0*fem, 10*fem, 8*fem),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10*fem),
                          color: Colors.white,
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 75*fem,
                            height: 75*fem,
                            decoration: BoxDecoration(
                              color: Palette.primary,
                              borderRadius: BorderRadius.circular(5*fem),
                              image: DecorationImage(
                                image: AssetImage("assets/image/waktu_shalat_dzuhur.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text("Dzuhur", style: TextStyle(fontSize: 20*ffem, fontFamily: "Inter Bold"),),
                          subtitle: Text("Waktu Shalat: "+ waktushalat.dzuhur!.substring(0,5), style: TextStyle(fontSize: 12*ffem),),
                          trailing: Wrap(
                            children: [
                              waktushalat.dzuhur_cek.toString()=="0"?
                              Icon(FontAwesomeIcons.timesCircle, size: 24*ffem, color: Palette.dangers,) // jika belum shalat
                                  :
                              Icon(FontAwesomeIcons.circleCheck, size: 24*ffem, color: Palette.success,), // jika sudah shalat
                              SizedBox(width: 5*fem,),
                              GestureDetector(
                                child: Icon(Icons.more_horiz, size: 24*ffem, color: Colors.black,),
                                onTap: (){
                                  showModalBottomSheet(
                                      context: context,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(10*fem),
                                        ),
                                      ),
                                      builder:(context) {
                                        return Container(
                                          height: 90*fem,
                                          child: Column(
                                            children: [
                                              SizedBox(height: 10*fem,),
                                              Container(
                                                width: 65*fem,
                                                height: 5*fem,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius: BorderRadius.circular(10*fem)
                                                ),
                                              ),
                                              SizedBox(height: 10*fem,),

                                              waktushalat.dzuhur_cek.toString()=="0"? // jika belum shalat
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) {
                                                        return MultiBlocProvider(
                                                          providers: [
                                                            BlocProvider<DatabaseCubit>(
                                                              create: (context) => DatabaseCubit()..initDB(),
                                                            ),
                                                            BlocProvider<WaktuShalatCubit>(
                                                              create: (context) => WaktuShalatCubit(database: context.read<DatabaseCubit>().database!)..setSudahShalat('dzuhur_cek', waktushalat.id!.toString()),
                                                            ),
                                                          ],
                                                          child: JadwalShalatPage(),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                                child: ListTile(
                                                  leading: Icon(Icons.check_circle, size: 24*ffem,),
                                                  title: Text("Tandai Sudah Shalat Dzuhur", style: TextStyle(fontSize: 14*ffem),),
                                                ),
                                              )
                                                  : // jika membatalkan
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) {
                                                        return MultiBlocProvider(
                                                          providers: [
                                                            BlocProvider<DatabaseCubit>(
                                                              create: (context) => DatabaseCubit()..initDB(),
                                                            ),
                                                            BlocProvider<WaktuShalatCubit>(
                                                              create: (context) => WaktuShalatCubit(database: context.read<DatabaseCubit>().database!)..setBelumShalat('dzuhur_cek' ,waktushalat.id!.toString()),
                                                            ),
                                                          ],
                                                          child: JadwalShalatPage(),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                                child: ListTile(
                                                  leading: Icon(Icons.check_circle, size: 24*ffem,),
                                                  title: Text("Tandai Belum Shalat Dzuhur", style: TextStyle(fontSize: 16*ffem),),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10*fem, 0*fem, 10*fem, 8*fem),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10*fem),
                          color: Colors.white,
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 75*fem,
                            height: 75*fem,
                            decoration: BoxDecoration(
                              color: Palette.primary,
                              borderRadius: BorderRadius.circular(5*fem),
                              image: DecorationImage(
                                image: AssetImage("assets/image/waktu_shalat_ashar.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text("Ashar", style: TextStyle(fontSize: 20*ffem, fontFamily: "Inter Bold"),),
                          subtitle: Text("Waktu Shalat: "+ waktushalat.ashar!.substring(0,5), style: TextStyle(fontSize: 12*ffem),),
                          trailing: Wrap(
                            children: [
                              waktushalat.ashar_cek.toString()=="0"?
                              Icon(FontAwesomeIcons.timesCircle, size: 24*ffem, color: Palette.dangers,) // jika belum shalat
                                  :
                              Icon(FontAwesomeIcons.circleCheck, size: 24*ffem, color: Palette.success,), // jika sudah shalat
                              SizedBox(width: 5*fem,),
                              GestureDetector(
                                child: Icon(Icons.more_horiz, size: 24*ffem, color: Colors.black,),
                                onTap: (){
                                  showModalBottomSheet(
                                      context: context,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(10*fem),
                                        ),
                                      ),
                                      builder:(context) {
                                        return Container(
                                          height: 90*fem,
                                          child: Column(
                                            children: [
                                              SizedBox(height: 10*fem,),
                                              Container(
                                                width: 65*fem,
                                                height: 5*fem,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius: BorderRadius.circular(10*fem)
                                                ),
                                              ),
                                              SizedBox(height: 10*fem,),

                                              waktushalat.ashar_cek.toString()=="0"? // jika belum shalat
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) {
                                                        return MultiBlocProvider(
                                                          providers: [
                                                            BlocProvider<DatabaseCubit>(
                                                              create: (context) => DatabaseCubit()..initDB(),
                                                            ),
                                                            BlocProvider<WaktuShalatCubit>(
                                                              create: (context) => WaktuShalatCubit(database: context.read<DatabaseCubit>().database!)..setSudahShalat('ashar_cek', waktushalat.id!.toString()),
                                                            ),
                                                          ],
                                                          child: JadwalShalatPage(),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                                child: ListTile(
                                                  leading: Icon(Icons.check_circle, size: 24*ffem,),
                                                  title: Text("Tandai Sudah Shalat Ashar", style: TextStyle(fontSize: 14*ffem),),
                                                ),
                                              )
                                                  : // jika membatalkan
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) {
                                                        return MultiBlocProvider(
                                                          providers: [
                                                            BlocProvider<DatabaseCubit>(
                                                              create: (context) => DatabaseCubit()..initDB(),
                                                            ),
                                                            BlocProvider<WaktuShalatCubit>(
                                                              create: (context) => WaktuShalatCubit(database: context.read<DatabaseCubit>().database!)..setBelumShalat('ashar_cek' ,waktushalat.id!.toString()),
                                                            ),
                                                          ],
                                                          child: JadwalShalatPage(),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                                child: ListTile(
                                                  leading: Icon(Icons.check_circle, size: 24*ffem,),
                                                  title: Text("Tandai Belum Shalat Ashar", style: TextStyle(fontSize: 16*ffem),),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10*fem, 0*fem, 10*fem, 8*fem),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10*fem),
                          color: Colors.white,
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 75*fem,
                            height: 75*fem,
                            decoration: BoxDecoration(
                              color: Palette.primary,
                              borderRadius: BorderRadius.circular(5*fem),
                              image: DecorationImage(
                                image: AssetImage("assets/image/waktu_shalat_magrib.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text("Magrib", style: TextStyle(fontSize: 20*ffem, fontFamily: "Inter Bold"),),
                          subtitle: Text("Waktu Shalat: " + waktushalat.magrib!.substring(0,5), style: TextStyle(fontSize: 12*ffem),),
                          trailing: Wrap(
                            children: [
                              waktushalat.magrib_cek.toString()=="0"?
                              Icon(FontAwesomeIcons.timesCircle, size: 24*ffem, color: Palette.dangers,) // jika belum shalat
                                  :
                              Icon(FontAwesomeIcons.circleCheck, size: 24*ffem, color: Palette.success,), // jika sudah shalat
                              SizedBox(width: 5*fem,),
                              GestureDetector(
                                child: Icon(Icons.more_horiz, size: 24*ffem, color: Colors.black,),
                                onTap: (){
                                  showModalBottomSheet(
                                      context: context,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(10*fem),
                                        ),
                                      ),
                                      builder:(context) {
                                        return Container(
                                          height: 90*fem,
                                          child: Column(
                                            children: [
                                              SizedBox(height: 10*fem,),
                                              Container(
                                                width: 65*fem,
                                                height: 5*fem,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius: BorderRadius.circular(10*fem)
                                                ),
                                              ),
                                              SizedBox(height: 10*fem,),

                                              waktushalat.magrib_cek.toString()=="0"? // jika belum shalat
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) {
                                                        return MultiBlocProvider(
                                                          providers: [
                                                            BlocProvider<DatabaseCubit>(
                                                              create: (context) => DatabaseCubit()..initDB(),
                                                            ),
                                                            BlocProvider<WaktuShalatCubit>(
                                                              create: (context) => WaktuShalatCubit(database: context.read<DatabaseCubit>().database!)..setSudahShalat('magrib_cek', waktushalat.id!.toString()),
                                                            ),
                                                          ],
                                                          child: JadwalShalatPage(),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                                child: ListTile(
                                                  leading: Icon(Icons.check_circle, size: 24*ffem,),
                                                  title: Text("Tandai Sudah Shalat Magrib", style: TextStyle(fontSize: 14*ffem),),
                                                ),
                                              )
                                                  : // jika membatalkan
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) {
                                                        return MultiBlocProvider(
                                                          providers: [
                                                            BlocProvider<DatabaseCubit>(
                                                              create: (context) => DatabaseCubit()..initDB(),
                                                            ),
                                                            BlocProvider<WaktuShalatCubit>(
                                                              create: (context) => WaktuShalatCubit(database: context.read<DatabaseCubit>().database!)..setBelumShalat('magrib_cek' ,waktushalat.id!.toString()),
                                                            ),
                                                          ],
                                                          child: JadwalShalatPage(),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                                child: ListTile(
                                                  leading: Icon(Icons.check_circle, size: 24*ffem,),
                                                  title: Text("Tandai Belum Shalat Magrib", style: TextStyle(fontSize: 16*ffem),),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10*fem, 0*fem, 10*fem, 8*fem),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10*fem),
                          color: Colors.white,
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 75*fem,
                            height: 75*fem,
                            decoration: BoxDecoration(
                              color: Palette.primary,
                              borderRadius: BorderRadius.circular(5*fem),
                              image: DecorationImage(
                                image: AssetImage("assets/image/waktu_shalat_isya.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text("Isya", style: TextStyle(fontSize: 20*ffem, fontFamily: "Inter Bold"),),
                          subtitle: Text("Waktu Shalat: " + waktushalat.isya!.substring(0,5), style: TextStyle(fontSize: 12*ffem),),
                          trailing: Wrap(
                            children: [
                              waktushalat.isya_cek.toString()=="0"?
                              Icon(FontAwesomeIcons.timesCircle, size: 24*ffem, color: Palette.dangers,) // jika belum shalat
                                  :
                              Icon(FontAwesomeIcons.circleCheck, size: 24*ffem, color: Palette.success,), // jika sudah shalat
                              SizedBox(width: 5*fem,),
                              GestureDetector(
                                child: Icon(Icons.more_horiz, size: 24*ffem, color: Colors.black,),
                                onTap: (){
                                  showModalBottomSheet(
                                      context: context,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(10*fem),
                                        ),
                                      ),
                                      builder:(context) {
                                        return Container(
                                          height: 90*fem,
                                          child: Column(
                                            children: [
                                              SizedBox(height: 10*fem,),
                                              Container(
                                                width: 65*fem,
                                                height: 5*fem,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius: BorderRadius.circular(10*fem)
                                                ),
                                              ),
                                              SizedBox(height: 10*fem,),

                                              waktushalat.isya_cek.toString()=="0"? // jika belum shalat
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) {
                                                        return MultiBlocProvider(
                                                          providers: [
                                                            BlocProvider<DatabaseCubit>(
                                                              create: (context) => DatabaseCubit()..initDB(),
                                                            ),
                                                            BlocProvider<WaktuShalatCubit>(
                                                              create: (context) => WaktuShalatCubit(database: context.read<DatabaseCubit>().database!)..setSudahShalat('isya_cek', waktushalat.id!.toString()),
                                                            ),
                                                          ],
                                                          child: JadwalShalatPage(),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                                child: ListTile(
                                                  leading: Icon(Icons.check_circle, size: 24*ffem,),
                                                  title: Text("Tandai Sudah Shalat Isya", style: TextStyle(fontSize: 14*ffem),),
                                                ),
                                              )
                                                  : // jika membatalkan
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) {
                                                        return MultiBlocProvider(
                                                          providers: [
                                                            BlocProvider<DatabaseCubit>(
                                                              create: (context) => DatabaseCubit()..initDB(),
                                                            ),
                                                            BlocProvider<WaktuShalatCubit>(
                                                              create: (context) => WaktuShalatCubit(database: context.read<DatabaseCubit>().database!)..setBelumShalat('isya_cek' ,waktushalat.id!.toString()),
                                                            ),
                                                          ],
                                                          child: JadwalShalatPage(),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                                child: ListTile(
                                                  leading: Icon(Icons.check_circle, size: 24*ffem,),
                                                  title: Text("Tandai Belum Shalat Isya", style: TextStyle(fontSize: 16*ffem),),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
            );
          } else {
            return Container();
          }
        }
    );
  }
}
