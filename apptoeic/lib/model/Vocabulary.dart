import 'package:firebase_database/firebase_database.dart';

class Vocabulary {
  final String vocabId;
  final String eng;
  final String vie;
  final String spell;
  String? example;
  String? image;
  String? vocabCate;
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

  String? key;
  VocabData? vocabData;

  Vocabulary.all(this.vocabId, this.eng, this.vie, this.spell, this.image, this.audio, this.vocabCate,
      {this.key, this.vocabData});

  Vocabulary.fromSnapshot(DataSnapshot snapshot)
      : vocabId = snapshot.child('VocabId').value.toString(),
        eng = snapshot.child('Eng').value.toString(),
        vie = snapshot.child('Vie').value.toString(),
        spell = snapshot.child('Spell').value.toString(),
        example = snapshot.child('Example').value.toString(),
        image = snapshot.child('Url').value.toString(),
        vocabCate = snapshot.child('VocabCate').value.toString(),
        audio = snapshot.child('Audio').value.toString();

  toJson() {
    return {
      'VocabId': vocabId,
      'Eng': eng,
      'Vie': vie,
      'Spell': spell,
      'Example': example,
      'VocabCate': vocabCate,
      'Audio': audio,
      'Image': image
    };
  }
}

class VocabData {
  String? vocabId;
  String? eng;
  String? vocabCate;
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
        url = snapshot.child('Url').value.toString(),
        vocabCate = snapshot.child('VocabCate').value.toString(),
        audio = snapshot.child('Audio').value.toString();

  VocabData.fromJson(Map<dynamic, dynamic> json) {
    vocabId = json["VocabId"];
    eng = json["Eng"];
    vie = json["Vie"];
    spell = json["Spell"];
    vocabCate = json["VocabCate"];
    audio = json["Audio"];
    example = json["Example"];
    url = json["Url"];
  }
}
