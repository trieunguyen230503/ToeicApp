import 'package:apptoeic/utils/next_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:apptoeic/model/Vocabulary.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

import '../VocabDetail.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final TextEditingController _searchController = TextEditingController();

  List<String> _searchHistory = [];
  List<Vocabulary> _vocabularyList = [];
  List<Vocabulary> _vocabularyListTemp = [];

  @override
  void initState() {
    super.initState();
    getData();
    //_searchController.onChange(_performSearch);
    _loadSearchHistory();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void getData() async {
    await getVocabFromFirebase();
  }

  Future getVocabFromFirebase() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('vocab').get();

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
    print(_vocabularyList[0].eng);
  }

  Future<void> _performSearch(String keyword) async {
    setState(() {
      _vocabularyListTemp = _vocabularyList
          .where((vocab) =>
              vocab.eng.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    });
  }

  Future<bool> _isQueryInHistory(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('search_history') ?? [];
    return history.contains(query);
  }

  Future<void> _addSearchHistory(String query) async {
    if (await _isQueryInHistory(query)) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('search_history') ?? [];
    history.insert(0, query);

    await prefs.setStringList('search_history', history);

    _loadSearchHistory();
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('search_history') ?? [];
    setState(() {
      _searchHistory = history;
    });
  }

  Future<void> _clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('search_history');
    setState(() {
      _searchHistory.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 100,
        backgroundColor: Colors.white,
        title: Container(
          margin:
              EdgeInsets.only(left: MediaQuery.of(context).size.height * 0.01),
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.height * 0.02),
          height: 55,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
                color: Colors.grey, width: 2.0, style: BorderStyle.solid),
          ),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.height * 0.001),
                width: MediaQuery.of(context).size.width * 0.7,
                child: TextFormField(
                  controller: _searchController,
                  onChanged: (value) {
                    _performSearch(value);
                    print(value);
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter a keyword",
                  ),
                ),
              ),
              _searchController.text.isEmpty
                  ? const Icon(
                      Icons.search,
                      size: 28,
                      color: Colors.grey,
                    )
                  : GestureDetector(
                      onTap: () {
                        _searchController.clear();
                      },
                      child: const Icon(
                        Icons.clear,
                        size: 28,
                        color: Colors.grey,
                      ),
                    ),
            ],
          ),
        ),
        actions: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.03,
          )
        ],
      ),
      body: _searchController.text.isEmpty && _searchHistory.isNotEmpty
          ? _buildSearchHistory()
          : _buildSearchResults(),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildSearchHistory() {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemCount: _searchHistory.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(
                _searchHistory[index],
                style: const TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VocabDetailPage(
                            vocabulary: _vocabularyList[index])));
              },
            ),
          ),
        ),
        Expanded(
            child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            _clearSearchHistory();
          },
          child: const Text(
            'Clear all history',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ))
      ],
    );
  }

  Widget _buildSearchResults() {
    if (_vocabularyListTemp.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Container(
          alignment: AlignmentDirectional.topCenter,
          child: const Text(
            "No data found",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    } else {
      return ListView.builder(
          itemCount: _vocabularyListTemp.length,
          itemBuilder: (context, index) => InkWell(
                onTap: () {
                  _addSearchHistory(_vocabularyListTemp[index].eng);
                  nextScreen(context,
                      VocabDetailPage(vocabulary: _vocabularyListTemp[index]));
                },
                child: ListTile(
                  title: Text(
                    _vocabularyListTemp[index].eng,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ));
    }
  }
}
