import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  String? id;
  String? content;
  String? audio;
  String? image;
  String? opA;
  String? opB;
  String? opC;
  String? opD;
  int? answer;

  // String? practiceCate;
  // String? level;

  Question({
    required this.id,
    required this.content,
    required this.audio,
    required this.image,
    required this.opA,
    required this.opB,
    required this.opC,
    required this.opD,
    required this.answer,
    //required this.practiceCate,
    // required this.level,
  });

  factory Question.fromSnapShot(QueryDocumentSnapshot snapshot) {
    return Question(
      id: snapshot['id'],
      content: snapshot['content'],
      audio: snapshot['audio'],
      image: snapshot['image'],
      opA: snapshot['opA'],
      opB: snapshot['opB'],
      opC: snapshot['opC'],
      opD: snapshot['opD'],
      answer: snapshot['answer'],
      //practiceCate:snapshot['practiceCate'],
      // level:snapshot['level'],
    );
  }
}
