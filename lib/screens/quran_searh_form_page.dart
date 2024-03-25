import 'package:Quranku/cubit/database/database_cubit.dart';
import 'package:Quranku/cubit/surah/surah_cubit.dart';
import 'package:Quranku/screens/quran_search_result_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants.dart';
import '../widget/core_leading.dart';
import '../widget/core_title.dart';

class QuranSearchFormPage extends StatefulWidget {
  const QuranSearchFormPage({super.key});

  @override
  State<QuranSearchFormPage> createState() => _QuranSearchFormPageState();
}

class _QuranSearchFormPageState extends State<QuranSearchFormPage> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController _searchcontroller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      appBar: AppBar(
        title: CoreTitle(title: "Cari Surah", color: Colors.white, fontsize: 18),
        centerTitle: true,
        leading: CoreLeading(page: 1, color: Colors.white,),
        backgroundColor: Palette.primary,
        elevation: 0,
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
      body: BlocBuilder<DatabaseCubit, DatabaseState>(
        builder: (context, state) {
          if(state is LoadDatabaseState) {
            return Container(
              width: double.infinity,
              // margin: EdgeInsets.fromLTRB(15*fem, 10*fem, 15*fem, 0),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(15*fem, 5*fem, 15*fem, 15*fem),
                    color: Palette.primary,
                    child: Container(
                      height: 38*fem,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50*fem),
                        color: Colors.white,
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.only(left: 20*fem),
                        leading: SizedBox(height: 60*fem, child: Icon(Icons.search, color: Colors.black,)),
                        title: SizedBox(
                          height: 25*fem,
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              controller: _searchcontroller,
                              onFieldSubmitted: (value) {
                                if(_formKey.currentState!.validate()){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return MultiBlocProvider(
                                          providers: [
                                            BlocProvider<DatabaseCubit>(
                                              create: (context) => DatabaseCubit()..initDB(),
                                            ),
                                            BlocProvider<SurahCubit>(
                                              create: (context) => SurahCubit(database: context.read<DatabaseCubit>().database!)..getSearchSurah(value),
                                            ),
                                          ],
                                          child: QuranSearchResultPage(keyword: value),
                                        );
                                      },
                                    ),
                                  );
                                }
                              },
                              decoration: InputDecoration(
                                hintText: "Ketikkan Nama Surah", border: InputBorder.none,
                                contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 13*fem),
                              ),
                            ),
                          ),
                        ),
                        visualDensity: VisualDensity(vertical: -3),
                        trailing: Padding(
                          padding: EdgeInsets.only(right: 10*fem),
                          child: IconButton(
                            onPressed: () {
                              _searchcontroller.clear();
                            },
                            icon: Icon(Icons.cancel, color: Colors.black)),
                        ),
                      ),
                    ),
                  ),
                  BlocBuilder<SurahCubit, SurahState>(
                    builder: (context, state){
                      if(state is ListSurahSuccess){
                        return ListView.builder(
                          physics: ScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: state.surahlist.length,
                          itemBuilder: (context, index){
                            return Column(
                              children: [

                              ],
                            );
                          }
                        );
                      } else {
                        return Container();
                      }
                    }
                  ),
                ],
              )
            );
          } else {
            return Container();
          }
        }
      )
    );
  }
}
