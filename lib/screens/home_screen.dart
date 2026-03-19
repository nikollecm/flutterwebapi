import 'package:flutter/material.dart';
import 'package:flutterwebapi/models/entry.dart';
import 'package:uuid/uuid.dart';

class DiaryApp extends StatefulWidget {
  const DiaryApp({super.key});

  @override
  State<DiaryApp> createState() => _DiaryAppState();
}

class _DiaryAppState extends State<DiaryApp> {
  var uuid = Uuid();

  void test() {
    final entry = Entry(
      id: uuid.v4(),
      title: 'title goes here',
      desc: 'description goes here',
      date: 'date 2025-05-31 goes here',
    );
    print(entry.title);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold());
  }
}
