import 'dart:async';
import 'package:apptoeic/utils/constColor.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:string_similarity/string_similarity.dart';

class SpeechScreen extends StatefulWidget {
  SpeechScreen({required this.vocabulary});

  final vocabulary;

  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;

  String _text = '';
  String _speakingText = 'Your pronunciation';
  double similarityRate = 1;
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _text = widget.vocabulary.eng;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    audioPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: darkblue,
        centerTitle: true,
        title:
            Text('Accuracy: ${(similarityRate * 100.0).toStringAsFixed(1)}%'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.sizeOf(context).height * 0.05),
        child: AvatarGlow(
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
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _text,
            style: TextStyle(
              fontSize: 32.0,
              color: Theme.of(context).colorScheme.outline,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.05,
          ),
          Text(
            widget.vocabulary.spell,
            style: TextStyle(
              fontSize: 28.0,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.05,
          ),
          Text(
            _speakingText,
            style: TextStyle(
              fontSize: 30.0,
              color: similarityRate == 1
                  ? mainColor
                  : (similarityRate > 90
                      ? Colors.orange
                      : (similarityRate > 70 ? Colors.yellow : Colors.red)),
              fontWeight: FontWeight.w400,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.volume_up),
            iconSize: 36,
            onPressed: () async {
              await audioPlayer.play(UrlSource(widget.vocabulary.audio!));
            },
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.15,
          ),
        ],
      )),
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
            _speakingText = val.recognizedWords;
            if (_speakingText.split(' ').length > 2) {
              similarityRate = 0;
            } else {
              similarityRate = StringSimilarity.compareTwoStrings(
                  widget.vocabulary.eng.toLowerCase(),
                  val.recognizedWords.toLowerCase());
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}
