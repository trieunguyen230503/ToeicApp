import 'package:apptoeic/student/fragment/Test/TestType.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.02,
          ),
          const TestType(
            level: 1,
          ),
          const TestType(
            level: 2,
          ),
          const TestType(
            level: 3,
          )
        ],
      ),
    );
  }
}
