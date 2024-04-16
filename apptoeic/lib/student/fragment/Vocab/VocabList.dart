import 'package:apptoeic/utils/next_screen.dart';
import 'package:flutter/material.dart';
import '../../../utils/constColor.dart';
import '../../../utils/constText.dart';
import 'package:apptoeic/student/fragment/Vocab/VocabDetail.dart';
import 'package:apptoeic/model/Vocabulary.dart';
import 'package:apptoeic/model/VocabCategory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class VocabList extends StatefulWidget {
  final String? cateId;
  final String? cateName;

  VocabList({required this.cateId, this.cateName});

  @override
  State<VocabList> createState() => _VocabListState(cateId: cateId, cateName: cateName);
}

class _VocabListState extends State<VocabList> {
  late final String? cateId;
  late final String? cateName;

  List<Vocabulary> _vocabularyList = [];

  _VocabListState({required this.cateId, required this.cateName});


  Future<void> getVocabListFromFirebase() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('vocab')
        .where('vocabCate', isEqualTo: cateId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var document in querySnapshot.docs) {
        _vocabularyList.add(Vocabulary(
          vocabId: document['vocabId'],
          eng: document['eng'],
          vie: document['vie'],
          spell: document['spell'],
          image: document['image'],
          example: document['example'],
          audio: document['audio'],
          vocabCate: document['vocabCate'],
        ));
      }
    }
    print(_vocabularyList.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: darkblue,
        centerTitle: true,
        title: Text(cateName!.toUpperCase()),
      ),
      body: FutureBuilder<void>(
        future: getVocabListFromFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                const SizedBox(height: 15),
                Expanded(
                  child: ListView.builder(
                      itemCount: _vocabularyList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.sizeOf(context).width *0.06,
                              right: MediaQuery.sizeOf(context).width *0.08),
                          child: InkWell(
                            onTap: () {
                              nextScreen(context, VocabDetailPage(
                                  vocabulary: _vocabularyList[index]));
                            },
                            child: Padding(
                              padding: EdgeInsets.all(0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20),
                                  Text(
                                    _vocabularyList[index].eng.toString(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _vocabularyList[index].vie.toString(),
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Divider(
                                    color: Colors.grey,
                                    thickness: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                )
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: darkblue,
                strokeWidth: 3,
              ),
            );
          }
        },
      ));
  }
}



