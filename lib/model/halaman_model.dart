import 'dart:convert';

class ListHalamanModel {
  int? id;
  int? id_surah_mulai;
  int? no_ayat_mulai;
  int? id_surah_akhir;
  int? no_ayat_akhir;
  String? nama_surah;

  ListHalamanModel({this.id, this.id_surah_mulai, this.no_ayat_mulai, this.id_surah_akhir, this.no_ayat_akhir, this.nama_surah});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['id_surah_mulai'] = id_surah_mulai;
    data['no_ayat_mulai'] = no_ayat_mulai;
    data['id_surah_akhir'] = id_surah_akhir;
    data['no_ayat_akhir'] = no_ayat_akhir;
    data['nama_surah'] = nama_surah;
    return data;
  }

  factory ListHalamanModel.fromMap(Map<String, dynamic> map) {
    return ListHalamanModel(
      id: map['id'],
      id_surah_mulai: map['id_surah_mulai'],
      no_ayat_mulai: map['no_ayat_mulai'],
      id_surah_akhir: map['id_surah_akhir'],
      no_ayat_akhir: map['no_ayat_akhir'],
      nama_surah: map['nama_surah'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ListHalamanModel.fromJson(String source) =>
      ListHalamanModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class BacaHalamanModel {
  int? id;
  int? id_surah;
  String? nama_surah;
  String? kategori;
  String? ayat_text;
  int? no_ayat;
  String? indo_text;
  String? baca_text;
  String? arti;
  int? jml_ayat;

  BacaHalamanModel({this.id, this.id_surah, this.nama_surah, this.kategori, this.ayat_text, this.no_ayat, this.indo_text, this.baca_text, this.arti, this.jml_ayat});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['id_surah'] = id_surah;
    data['nama_surah'] = nama_surah;
    data['kategori'] = kategori;
    data['ayat_text'] = ayat_text;
    data['no_ayat'] = no_ayat;
    data['indo_text'] = indo_text;
    data['baca_text'] = baca_text;
    data['arti'] = arti;
    data['jml_ayat'] = jml_ayat;
    return data;
  }

  factory BacaHalamanModel.fromMap(Map<String, dynamic> map) {
    return BacaHalamanModel(
      id: map['id'],
      id_surah: map['id_surah'],
      nama_surah: map['nama_surah'] as String,
      kategori: map['kategori'] as String,
      ayat_text: map['ayat_text'] as String,
      no_ayat: map['no_ayat'] as int,
      indo_text: map['indo_text'] as String,
      baca_text: map['baca_text'] as String,
      arti: map['arti'] as String,
      jml_ayat: map['jml_ayat'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory BacaHalamanModel.fromJson(String source) =>
      BacaHalamanModel.fromMap(json.decode(source) as Map<String, dynamic>);
}