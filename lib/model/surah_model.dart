import 'dart:convert';

class ListSurahModel {
  int? id;
  String? nama_surah;
  String? arabic;
  int? jml_ayat;
  String? arti;
  String? kategori;

  ListSurahModel({this.id, this.nama_surah, this.arabic, this.jml_ayat, this.arti, this.kategori});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['nama_surah'] = nama_surah;
    data['arabic'] = arabic;
    data['jml_ayat'] = jml_ayat;
    data['arti'] = arti;
    data['kategori'] = kategori;
    return data;
  }

  factory ListSurahModel.fromMap(Map<String, dynamic> map) {
    return ListSurahModel(
      id: map['id'] as int,
      nama_surah: map['nama_surah'] as String,
      arabic: map['arabic'] as String,
      jml_ayat: map['jml_ayat'] as int,
      arti: map['arti'] as String,
      kategori: map['kategori'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ListSurahModel.fromJson(String source) =>
      ListSurahModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class BacaSurahModel {
  int? id;
  int? id_surah;
  int? no_ayat;
  String? ayat_text;
  String? indo_text;
  String? baca_text;

  BacaSurahModel({this.id, this.id_surah, this.no_ayat, this.ayat_text, this.indo_text, this.baca_text});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['id_surah'] = id_surah;
    data['no_ayat'] = no_ayat;
    data['ayat_text'] = ayat_text;
    data['indo_text'] = indo_text;
    data['baca_text'] = baca_text;
    return data;
  }

  factory BacaSurahModel.fromMap(Map<String, dynamic> map) {
    return BacaSurahModel(
      id: map['id'] as int,
      id_surah: map['id_surah'] as int,
      no_ayat: map['no_ayat'] as int,
      ayat_text: map['ayat_text'] as String,
      indo_text: map['indo_text'] as String,
      baca_text: map['baca_text'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory BacaSurahModel.fromJson(String source) =>
      BacaSurahModel.fromMap(json.decode(source) as Map<String, dynamic>);
}