import 'dart:convert';

import 'package:http/http.dart' as http;

import '../main.dart';

ModelDht22 modelDht22FromJson(String str) =>
    ModelDht22.fromJson(json.decode(str));

String modelDht22ToJson(ModelDht22 data) => json.encode(data.toJson());

class ModelDht22 {
  int? value;
  String? message;
  List<Datum>? data;

  ModelDht22({
    this.value,
    this.message,
    this.data,
  });

  factory ModelDht22.fromJson(Map<String, dynamic> json) => ModelDht22(
        value: json["value"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };

  static Future<ModelDht22> fetchData() async {
    final response = await http.get(Uri.parse("$urlAPI/API-IoT/read_data.php"));
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ModelDht22.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<ModelDht22> fetchAllData() async {
    final response =
        await http.get(Uri.parse("$urlAPI/API-IoT/read_all_data.php"));
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ModelDht22.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
}

class Datum {
  String? id;
  String? suhu;
  String? kelembapan;
  dynamic waktu;

  Datum({
    this.id,
    this.suhu,
    this.kelembapan,
    this.waktu,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        suhu: json["suhu"],
        kelembapan: json["kelembapan"],
        waktu: json["waktu"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "suhu": suhu,
        "kelembapan": kelembapan,
        "waktu": waktu,
      };
}
