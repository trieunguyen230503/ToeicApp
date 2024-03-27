import 'dart:ui';

import 'package:flutter/material.dart';

Text TextAppbar(content) {
  return Text(content,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ));
}

Text TextTest(content) {
  return Text(content,
      style: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ));
}
