import 'package:apptoeic/utils/constColor.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioListening extends StatefulWidget {
  AudioListening(
      {super.key,
      required this.audioLink,
      required this.audioPlayer,
      required this.isplaying});

  final audioLink;
  final audioPlayer;
  var isplaying;

  @override
  State<AudioListening> createState() => _AudioListeningState();
}

class _AudioListeningState extends State<AudioListening> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    widget.audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.completed) {
        setState(() {
          widget.isplaying = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height * 0.08,
      //color: Colors.green,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: IconButton(
                onPressed: () {
                  if (widget.isplaying) {
                    widget.audioPlayer.pause();
                  } else {
                    widget.audioPlayer.play(UrlSource(
                        widget.audioLink));
                  }
                  setState(() {
                    widget.isplaying = !widget.isplaying;
                  });
                },
                icon: Icon(widget.isplaying ? Icons.pause : Icons.play_arrow)),
          ),
          Expanded(
            child: StreamBuilder<Duration?>(
              //nó phát ra các sự kiện khi độ dài của âm thanh thay đổi
                stream: widget.audioPlayer.onDurationChanged,
                builder: (context, snapshot) {
                  final duration = snapshot.data ?? Duration.zero;
                  return StreamBuilder<Duration>(
                    //phát ra các sự kiện khi vị trí hiện tại của âm thanh thay đổi để thay đổi slider.
                    stream: widget.audioPlayer.onPositionChanged,
                    builder: (context, positionSnapshot) {
                      final position = positionSnapshot.data ?? Duration.zero;
                      return SliderTheme(
                        data: const SliderThemeData(
                          trackHeight: 8,
                          thumbShape: RoundSliderThumbShape(
                            enabledThumbRadius: 10,
                          ),
                        ),
                        child: Slider(
                          activeColor: yellowLight,
                          inactiveColor: blueLight,
                          value: position.inMilliseconds
                              .toDouble()
                              .clamp(0.0, duration.inMilliseconds.toDouble()),
                          min: 0.0,
                          max: duration.inMilliseconds.toDouble(),
                          onChanged: (value) {
                            // được gọi để di chuyển vị trí phát của audioPlayer đến một thời điểm cụ thể.
                            widget.audioPlayer
                                .seek(Duration(milliseconds: value.toInt()));
                          },
                        ),
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
// audioPlayer.onDurationChanged và audioPlayer.onPositionChanged là hai stream khác nhau trong audioPlayer.
// Khi sử dụng StreamBuilder riêng lẻ cho mỗi stream, chúng ta có thể xử lý các sự kiện từ mỗi stream một cách độc lập.