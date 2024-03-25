import 'dart:convert';

class SettingModel {
  String? kota;

  SettingModel({this.kota});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};
    data['kota'] = kota;
    return data;
  }

  factory SettingModel.fromMap(Map<String, dynamic> map) {
    return SettingModel(
      kota: map['kota'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SettingModel.fromJson(String source) =>
      SettingModel.fromMap(json.decode(source) as Map<String, dynamic>);
}