import 'package:firebase_database/firebase_database.dart';

class Vocabulary {
  final String vocabId;
  final String eng;
  final String vie;
  final String spell;
  String? example;
  String? image;
  int? vocabCate;
  String? audio;

  Vocabulary({
    required this.vocabId,
    required this.eng,
    required this.vie,
    required this.spell,
    required this.image,
    required this.example,
    required this.audio,
    required this.vocabCate
  });

  Vocabulary.qui(this.vocabId, this.eng, this.vie, this.spell,
      this.example, this.vocabCate, this.audio, this.image);

  String? key;
  VocabData? vocabData;

  Vocabulary.all(this.vocabId, this.eng, this.vie, this.spell, this.image, this.vocabCate,
      {this.key, this.vocabData});

  Vocabulary.fromSnapshot(DataSnapshot snapshot)
      : vocabId = snapshot.child('VocabId').value.toString(),
        eng = snapshot.child('Eng').value.toString(),
        vie = snapshot.child('Vie').value.toString(),
        spell = snapshot.child('Spell').value.toString(),
        example = snapshot.child('Example').value.toString(),
        image = snapshot.child('url').value.toString(),
        vocabCate = int.parse(snapshot.child('VocabCate').value.toString()),
        audio = snapshot.child('audio').value.toString();

  toJson() {
    return {
      'VocabId': vocabId,
      'Eng': eng,
      'Vie': vie,
      'Spell': spell,
      'Example': example,
      'VocabCate': vocabCate,
      'audio': audio,
      'image': image
    };
  }
}

class VocabData {
  String? vocabId;
  String? eng;
  int? vocabCate;
  String? audio;
  String? vie;
  String? example;
  String? spell;
  String? url;

  VocabData(
      {this.vocabId,
        this.eng,
        this.vie,
        this.spell,
        this.vocabCate,
        this.audio,
        this.example,
        this.url});

  VocabData.fromSnapshot(DataSnapshot snapshot)
      : vocabId = snapshot.child('VocabId').value.toString(),
        eng = snapshot.child('Eng').value.toString(),
        vie = snapshot.child('Vie').value.toString(),
        spell = snapshot.child('Spell').value.toString(),
        example = snapshot.child('Example').value.toString(),
        url = snapshot.child('url').value.toString(),
        vocabCate = int.parse(snapshot.child('VocabCate').value.toString()),
        audio = snapshot.child('audio').value.toString();

  VocabData.fromJson(Map<dynamic, dynamic> json) {
    vocabId = json["VocabId"];
    eng = json["Eng"];
    vie = json["Vie"];
    spell = json["Spell"];
    vocabCate = json["VocabCate"];
    audio = json["audio"];
    example = json["Example"];
    url = json["url"];
  }
}
