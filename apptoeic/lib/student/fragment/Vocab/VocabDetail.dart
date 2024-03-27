import 'package:flutter/material.dart';
import 'package:apptoeic/model/Vocabulary.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class VocabDetailPage extends StatefulWidget {
  final Vocabulary vocabulary;

  VocabDetailPage({required this.vocabulary});

  @override
  State<VocabDetailPage> createState() =>
      _VocabDetailPageState(vocabulary: vocabulary);
}

class _VocabDetailPageState extends State<VocabDetailPage> {
  final Vocabulary vocabulary;

  _VocabDetailPageState({required this.vocabulary});

  List<VocabData> listVocabData = [];

  void getVocabDetailFromFirebase() async {
    final DatabaseReference databaseReference =
    FirebaseDatabase.instance.ref("vocab");

    await databaseReference.onValue.listen((event) async {
      if (listVocabData.isNotEmpty) {
        listVocabData.clear();
      }

      setState(() {});
    }, onError: (error) {
      // Error.
    });
  }

  @override
  void initState() {
    super.initState();
    getVocabDetailFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery
                  .sizeOf(context)
                  .height * 0.2,),
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .height * 0.4,
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.3,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.white70,
                      width: 3.0,
                      style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(12),
                  // Bo góc với bán kính 10
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      // Màu sắc của bóng đổ
                      spreadRadius: 3,
                      // Bán kính bóng đổ
                      blurRadius: 5,
                      // Độ mờ của bóng đổ
                      offset: Offset(0, 3), // Vị trí của bóng đổ
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    color: Colors.grey.withOpacity(0.5),
                    colorBlendMode: BlendMode.overlay,
                    vocabulary.image!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      vocabulary.eng!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF263472),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      vocabulary.spell ?? '',
                      style: const TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      vocabulary.vie ?? '',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFCCE4D),
                      ),
                    ),
                    const SizedBox(height: 2),
                    if (vocabulary.audio != null)
                      IconButton(
                        icon: const Icon(Icons.volume_up),
                        iconSize: 36,
                        onPressed: () {
                          // Phát audio
                        },
                      ),
                    const SizedBox(height: 16),
                    if (vocabulary.example != null) ...[
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.black),
                              children: <TextSpan>[
                                const TextSpan(
                                  text: 'Example: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                    text: vocabulary.example,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal))
                              ])),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
