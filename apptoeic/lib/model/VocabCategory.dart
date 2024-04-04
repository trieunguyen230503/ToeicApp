import 'package:firebase_database/firebase_database.dart';

class VocabCategory {
  String? cateId;
  String? cateName;

  VocabCategory(
      {this.cateId,
        this.cateName});

  VocabCategory.fromSnapshot(DataSnapshot snapshot)
      : cateId = snapshot.child('CateId').value.toString(),
        cateName = snapshot.child('CateName').value.toString();

  VocabCategory.fromJson(Map<dynamic, dynamic> json) {
    cateId = json["CateId"];
    cateName = json["CateName"];
  }
}
