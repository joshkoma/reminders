import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminders/global_bloc.dart';
import 'package:reminders/models/new_entry_bloc.dart';
import 'package:reminders/screens/reminders.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override


  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalBloc? globalBloc;
  // This widget is the root of your application.
    void initState() {
    globalBloc = GlobalBloc();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Provider<GlobalBloc>.value(
        value: globalBloc!,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(),
          home: const reminders(),
        ));
  }
}
