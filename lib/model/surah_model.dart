import 'dart:convert';

class ListSurahModel {
  int? id;
  String? nama_surah;
  String? arabic;
  int? jml_ayat;
  String? arti;
  String? kategori;
  int? is_bookmark;

  ListSurahModel({this.id, this.nama_surah, this.arabic, this.jml_ayat, this.arti, this.kategori, this.is_bookmark});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['nama_surah'] = nama_surah;
    data['arabic'] = arabic;
    data['jml_ayat'] = jml_ayat;
    data['arti'] = arti;
    data['kategori'] = kategori;
    data['is_bookmark'] = is_bookmark;
    return data;
  }

  factory ListSurahModel.fromMap(Map<String, dynamic> map) {
    return ListSurahModel(
      id: map['id'],
      nama_surah: map['nama_surah'] as String,
      arabic: map['arabic'] as String,
      jml_ayat: map['jml_ayat'],
      arti: map['arti'] as String,
      kategori: map['kategori'] as String,
      is_bookmark: map['is_bookmark'],
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
  int? juz;
  int? halaman;
  String? ayat_text;
  String? indo_text;
  String? baca_text;
  String? nama_surah;

  BacaSurahModel({this.id, this.id_surah, this.no_ayat, this.juz, this.halaman, this.ayat_text, this.indo_text, this.baca_text, this.nama_surah});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['id_surah'] = id_surah;
    data['no_ayat'] = no_ayat;
    data['juz'] = juz;
    data['halaman'] = halaman;
    data['ayat_text'] = ayat_text;
    data['indo_text'] = indo_text;
    data['baca_text'] = baca_text;
    data['nama_surah'] = nama_surah;
    return data;
  }

  factory BacaSurahModel.fromMap(Map<String, dynamic> map) {
    return BacaSurahModel(
      id: map['id'],
      id_surah: map['id_surah'],
      no_ayat: map['no_ayat'],
      juz: map['juz'],
      halaman: map['halaman'],
      ayat_text: map['ayat_text'] as String,
      indo_text: map['indo_text'] as String,
      baca_text: map['baca_text'] as String,
      nama_surah: map['nama_surah'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory BacaSurahModel.fromJson(String source) =>
      BacaSurahModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class RandomAyatModel {
  int? id;
  int? id_surah;
  int? no_ayat;
  String? ayat_text;
  String? indo_text;
  String? nama_surah;
  int? random_ayat;

  RandomAyatModel({this.id,this.id_surah, this.no_ayat, this.ayat_text, this.indo_text, this.nama_surah, this.random_ayat});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['id_surah'] = id_surah;
    data['no_ayat'] = no_ayat;
    data['ayat_text'] = ayat_text;
    data['indo_text'] = indo_text;
    data['nama_surah'] = nama_surah;
    data['random_ayat'] = random_ayat;
    return data;
  }

  factory RandomAyatModel.fromMap(Map<String, dynamic> map) {
    return RandomAyatModel(
      id: map['id'],
      id_surah: map['id_surah'],
      no_ayat: map['no_ayat'],
      ayat_text: map['ayat_text'] as String,
      indo_text: map['indo_text'] as String,
      nama_surah: map['nama_surah'] as String,
      random_ayat: map['random_ayat'],
    );
  }

  String toJson() => json.encode(toMap());

  factory RandomAyatModel.fromJson(String source) =>
      RandomAyatModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class KhatamQuranModel {
  int? id;
  int? id_surah;
  int? no_ayat;
  String? ayat_text;
  String? indo_text;
  String? nama_surah;

  KhatamQuranModel({this.id,this.id_surah, this.no_ayat, this.ayat_text, this.indo_text, this.nama_surah});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['id_surah'] = id_surah;
    data['no_ayat'] = no_ayat;
    data['ayat_text'] = ayat_text;
    data['indo_text'] = indo_text;
    data['nama_surah'] = nama_surah;
    return data;
  }

  factory KhatamQuranModel.fromMap(Map<String, dynamic> map) {
    return KhatamQuranModel(
      id: map['id'],
      id_surah: map['id_surah'],
      no_ayat: map['no_ayat'],
      ayat_text: map['ayat_text'] as String,
      indo_text: map['indo_text'] as String,
      nama_surah: map['nama_surah'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory KhatamQuranModel.fromJson(String source) =>
      KhatamQuranModel.fromMap(json.decode(source) as Map<String, dynamic>);
}