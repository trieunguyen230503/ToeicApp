import 'package:apptoeic/student/fragment/Test/TestType.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      if (orientation == Orientation.portrait) {
        return SingleChildScrollView(
          child: Container(
            color: Theme.of(context).colorScheme.background,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.02,
                ),
                const TestType(
                  level: 1,
                  orientaion: 1,
                ),
                const TestType(
                  level: 2,
                  orientaion: 1,
                ),
                const TestType(
                  level: 3,
                  orientaion: 1,
                )
              ],
            ),
          ),
        );
      } else {
        return SingleChildScrollView(
          child: Container(
            color: Theme.of(context).colorScheme.background,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.02,
                ),
                const TestType(
                  level: 1,
                  orientaion: 2,
                ),
                const TestType(
                  level: 2,
                  orientaion: 2,
                ),
                const TestType(
                  level: 3,
                  orientaion: 2,
                )
              ],
            ),
          ),
        );
      }
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
