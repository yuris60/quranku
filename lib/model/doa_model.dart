import 'dart:convert';

class ListDoaModel {
  int? id;
  String? nama_doa;
  String? ayat_doa;
  String? latin_doa;
  String? arti_doa;
  int? is_bookmark;

  ListDoaModel({this.id, this.nama_doa, this.ayat_doa, this.latin_doa, this.arti_doa, this.is_bookmark});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['nama_doa'] = nama_doa;
    data['ayat_doa'] = ayat_doa;
    data['latin_doa'] = latin_doa;
    data['arti_doa'] = arti_doa;
    data['is_bookmark'] = is_bookmark;
    return data;
  }

  factory ListDoaModel.fromMap(Map<String, dynamic> map) {
    return ListDoaModel(
      id: map['id'],
      nama_doa: map['nama_doa'] as String,
      ayat_doa: map['ayat_doa'] as String,
      latin_doa: map['latin_doa'] as String,
      arti_doa: map['arti_doa'] as String,
      is_bookmark: map['is_bookmark'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ListDoaModel.fromJson(String source) =>
      ListDoaModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class BacaDoaModel {
  int? id;
  String? nama_doa;
  String? ayat_doa;
  String? latin_doa;
  String? arti_doa;
  int? is_bookmark;

  BacaDoaModel({this.id, this.nama_doa, this.ayat_doa, this.latin_doa, this.arti_doa, this.is_bookmark});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['nama_doa'] = nama_doa;
    data['ayat_doa'] = ayat_doa;
    data['latin_doa'] = latin_doa;
    data['arti_doa'] = arti_doa;
    data['is_bookmark'] = is_bookmark;
    return data;
  }

  factory BacaDoaModel.fromMap(Map<String, dynamic> map) {
    return BacaDoaModel(
      id: map['id'],
      nama_doa: map['nama_doa'] as String,
      ayat_doa: map['ayat_doa'] as String,
      latin_doa: map['latin_doa'] as String,
      arti_doa: map['arti_doa'] as String,
      is_bookmark: map['is_bookmark'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BacaDoaModel.fromJson(String source) =>
      BacaDoaModel.fromMap(json.decode(source) as Map<String, dynamic>);
}