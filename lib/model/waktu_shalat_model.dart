import 'dart:convert';

class WaktuShalatModel {
  int? id;
  String? tanggal;
  String? kota;
  String? subuh;
  int? subuh_cek;
  String? fajar;
  String? dzuhur;
  int? dzuhur_cek;
  String? ashar;
  int? ashar_cek;
  String? magrib;
  int? magrib_cek;
  String? isya;
  int? isya_cek;

  WaktuShalatModel({this.id, this.tanggal, this.kota, this.subuh, this.subuh_cek, this.fajar, this.dzuhur, this.dzuhur_cek, this.ashar, this.ashar_cek, this.magrib, this.magrib_cek, this.isya, this.isya_cek});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['tanggal'] = tanggal;
    data['kota'] = kota;
    data['subuh'] = subuh;
    data['subuh_cek'] = subuh_cek;
    data['fajar'] = fajar;
    data['dzuhur'] = dzuhur;
    data['dzuhur_cek'] = dzuhur_cek;
    data['ashar'] = ashar;
    data['ashar_cek'] = ashar_cek;
    data['magrib'] = magrib;
    data['magrib_cek'] = magrib_cek;
    data['isya'] = isya;
    data['isya_cek'] = isya_cek;
    return data;
  }

  factory WaktuShalatModel.fromMap(Map<String, dynamic> map) {
    return WaktuShalatModel(
      id: map['id'],
      tanggal: map['tanggal'] as String,
      kota: map['kota'] as String,
      subuh: map['subuh'] as String,
      subuh_cek: map['subuh_cek'],
      fajar: map['fajar'] as String,
      dzuhur: map['dzuhur'] as String,
      dzuhur_cek: map['dzuhur_cek'],
      ashar: map['ashar'] as String,
      ashar_cek: map['ashar_cek'],
      magrib: map['magrib'] as String,
      magrib_cek: map['magrib_cek'],
      isya: map['isya'] as String,
      isya_cek: map['isya_cek'],
    );
  }

  String toJson() => json.encode(toMap());

  factory WaktuShalatModel.fromJson(String source) =>
      WaktuShalatModel.fromMap(json.decode(source) as Map<String, dynamic>);
}