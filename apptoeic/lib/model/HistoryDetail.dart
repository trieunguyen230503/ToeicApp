import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryDetail {
  String? historyDetailID;
  String? idQuestion;
  int? correctAnswer;
  int? actualAnswer;
  String? historyId;

  HistoryDetail({
    required this.historyDetailID,
    required this.idQuestion,
    required this.correctAnswer,
    required this.actualAnswer,
    required this.historyId,
  });

  factory HistoryDetail.fromSnapshot(QueryDocumentSnapshot documentSnapshot) {
    return HistoryDetail(
        historyDetailID: documentSnapshot['historyDetailId'],
        idQuestion: documentSnapshot['questionId'],
        correctAnswer: documentSnapshot['correctAnswer'],
        actualAnswer: documentSnapshot['actualAnswer'],
        historyId: documentSnapshot['historyId']);
  }
}
