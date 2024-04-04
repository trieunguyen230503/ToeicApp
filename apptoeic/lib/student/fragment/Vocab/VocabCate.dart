import 'package:apptoeic/model/VocabCategory.dart';
import 'package:apptoeic/utils/next_screen.dart';
import 'package:flutter/material.dart';
import '../../../utils/constColor.dart';
import '../../../utils/constText.dart';
import 'package:apptoeic/student/fragment/Vocab/VocabList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VocabulayCategory extends StatefulWidget {
  const VocabulayCategory({super.key});

  @override
  State<VocabulayCategory> createState() => _VocabulayCategoryState();
}

class _VocabulayCategoryState extends State<VocabulayCategory> {
  List<VocabCategory> categoryList = [];

  @override
  void initState() {
    super.initState();
    //getData();
  }

  void getData() async {
    await getVocabCateFromFirebase();
  }

  Future getVocabCateFromFirebase() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('category').get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var document in querySnapshot.docs) {
        categoryList.add(VocabCategory(
          cateId: document['cateId'],
          cateName: document['cateName'],
        ));
      }
    }
    print(categoryList.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: darkblue,
          centerTitle: true,
          title: TextAppbar('VOCABULARY'),
        ),
        body: FutureBuilder<void>(
          future: getVocabCateFromFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
             return Column(
                children: [
                  const SizedBox(height: 15),
                  Expanded(
                    child: ListView.builder(
                        itemCount: categoryList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.sizeOf(context).width *0.06,
                                right: MediaQuery.sizeOf(context).width *0.08),
                            child: InkWell(
                              onTap: () {
                                nextScreen(context, VocabList(cateId: categoryList[index].cateId, cateName:categoryList[index].cateName));
                              },
                              child: Padding(
                                padding: EdgeInsets.all(0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 20),
                                    Text(
                                      'Lesson ${index + 1}: ${categoryList[index].cateName.toString()}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
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
