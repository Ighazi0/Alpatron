import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/get_initial.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await GetInitial().initialApp();

  runApp(const MyApp());
}
