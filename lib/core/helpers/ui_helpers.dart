import 'package:flutter/material.dart';

Widget spacerLine([double height = 0]) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: height/2),
    height: 1, width: double.infinity, color: Colors.grey[300]);
}
