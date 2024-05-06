import 'package:apptoeic/student/fragment/Home/ScanText/ScanPage.dart';
import 'package:apptoeic/utils/constColor.dart';
import 'package:apptoeic/utils/next_screen.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translator/translator.dart';

class LanguageTranslationPage extends StatefulWidget {
  const LanguageTranslationPage({super.key});

  @override
  State<LanguageTranslationPage> createState() =>
      _LanguageTranslationPageState();
}

class _LanguageTranslationPageState extends State<LanguageTranslationPage> {
  var languages = ['English', 'Vietnamese'];
  var originLanguage = 'From';
  var destinationLanguage = 'To';
  var output = '';
  TextEditingController languageController = TextEditingController();

  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void translate(String src, String dest, String input) async {
    print('object');
    GoogleTranslator translator = GoogleTranslator();
    var translation = await translator.translate(input, from: src, to: dest);
    setState(() {
      output = translation.text.toString();
    });
    print(output);
    if (src == '--' || dest == '--') {
      output = 'Fail to translate';
    }
  }

  String getLanguageCode(String language) {
    if (language == 'English') {
      return 'en';
    } else {
      return 'vi';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Language Translator',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: darkblue,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton(
                    focusColor: darkblue,
                    iconDisabledColor: darkblue,
                    iconEnabledColor: darkblue,
                    hint: Text(
                      originLanguage,
                      style: const TextStyle(color: darkblue),
                    ),
                    dropdownColor: Colors.white,
                    icon: const Icon(Icons.key),
                    items: languages.map((String dropdownStringItem) {
                      return DropdownMenuItem(
                        value: dropdownStringItem,
                        child: Text(dropdownStringItem),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        originLanguage = value!;
                        print(originLanguage);
                      });
                    },
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  const Icon(
                    Icons.arrow_right_alt_outlined,
                    color: darkblue,
                    size: 40,
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  DropdownButton(
                    focusColor: darkblue,
                    iconDisabledColor: darkblue,
                    iconEnabledColor: darkblue,
                    hint: Text(
                      destinationLanguage,
                      style: const TextStyle(color: darkblue),
                    ),
                    dropdownColor: Colors.white,
                    icon: const Icon(Icons.key),
                    items: languages.map((String dropdownStringItem) {
                      return DropdownMenuItem(
                        value: dropdownStringItem,
                        child: Text(dropdownStringItem),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        destinationLanguage = value!;
                        print(destinationLanguage);
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  //expands: true,
                  maxLines: null,
                  cursorColor: darkblue,
                  style: const TextStyle(
                    color: darkblue,
                  ),
                  onChanged: (value) {
                    translate(getLanguageCode(originLanguage),
                        getLanguageCode(destinationLanguage), value);
                  },
                  decoration: const InputDecoration(
                    labelText: 'Please enter your text..',
                    labelStyle: TextStyle(
                      fontSize: 15,
                      color: darkblue,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: darkblue, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: darkblue)),
                    errorStyle: TextStyle(color: Colors.red, fontSize: 15),
                  ),
                  controller: languageController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter text to translate';
                    }
                    return null;
                  },
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AvatarGlow(
                    animate: _isListening,
                    glowColor: darkblue,
                    duration: const Duration(milliseconds: 2000),
                    repeat: true,
                    child: FloatingActionButton(
                      backgroundColor: darkblue,
                      onPressed: _listen,
                      child: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  FloatingActionButton(
                    heroTag: 'scan button', // Sử dụng tag duy nhất cho Hero

                    backgroundColor: darkblue,
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ScanPage()),
                      );

                      if (result != null && result is String) {
                        languageController.text = result.toString();
                        print('ok ${result.toString()}');
                        translate(
                            getLanguageCode(originLanguage),
                            getLanguageCode(destinationLanguage),
                            result.toString());
                      }
                    },
                    child: const Icon(
                      Icons.camera,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  output,
                  style: const TextStyle(color: darkblue, fontSize: 18),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      print('ok');
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          listenFor: const Duration(seconds: 90),
          onResult: (val) => setState(() {
            languageController.text = val.recognizedWords;
            translate(getLanguageCode(originLanguage),
                getLanguageCode(destinationLanguage), val.recognizedWords);
          }),
          localeId: getLanguageCode(originLanguage),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}
