import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:note_restapi/services/note_service.dart';
import 'package:note_restapi/views/note_list.dart';

void setupLocator() {
  GetIt.I.registerLazySingleton(() => NoteService());
}

void main() {
  setupLocator();
  runApp(
    MaterialApp(
      home: NoteList(),
    ),
  );
}
