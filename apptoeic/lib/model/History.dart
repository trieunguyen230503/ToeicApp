import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryUser {
  String? historyID;
  String? type;
  int? numberQuestion;
  String? date;
  double? rate;
  String? uid;

  HistoryUser({
    required this.historyID,
    required this.type,
    required this.numberQuestion,
    required this.date,
    required this.rate,
    required this.uid,
  });

  factory HistoryUser.fromSnapshot(QueryDocumentSnapshot documentSnapshot) {
    return HistoryUser(
        historyID: documentSnapshot['historyId'],
        type: documentSnapshot['type'],
        numberQuestion: documentSnapshot['numberQuestion'],
        date: documentSnapshot['date'],
        rate: documentSnapshot['rate'],
        uid: documentSnapshot['uid']);
  }
}
