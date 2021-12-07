import 'dart:convert';

import 'package:note_restapi/models/api_response.dart';
import 'package:note_restapi/models/create_note.dart';
import 'package:note_restapi/models/note.dart';
import 'package:note_restapi/models/note_for_listing.dart';
import 'package:http/http.dart' as http;

class NoteService {
  static const API = 'https://tq-notes-api-jkrgrdggbq-el.a.run.app';
  static const headers = {
    'apiKey': '6f462d18-2423-4c32-a4e9-7f43bd5f039f',
    'Content-Type': 'application/json',
  };

  Future<APIResponse<List<NoteForListing>>> getNoteList() {
    return http
        .get(
      Uri.parse(
        API + '/notes',
      ),
      headers: headers,
    )
        .then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final notes = <NoteForListing>[];
        for (var item in jsonData) {
          NoteForListing.fromJson(item);
          notes.add(
            NoteForListing.fromJson(item),
          );
        }
        return APIResponse<List<NoteForListing>>(data: notes);
      }
      return APIResponse<List<NoteForListing>>(
        error: true,
        errorMessage: 'an error occured',
      );
    }).catchError((_) => APIResponse<List<NoteForListing>>(
            error: true, errorMessage: 'an error occured'));
  }

  Future<APIResponse<Note>> getNote(String noteID) {
    return http
        .get(Uri.parse(API + '/notes/' + noteID), headers: headers)
        .then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);

        return APIResponse<Note>(data: Note.fromJson(jsonData));
      }

      return APIResponse<Note>(
        error: true,
        errorMessage: 'an error occured',
      );
    }).catchError(
      (_) => APIResponse<Note>(
        error: true,
        errorMessage: 'an error occured',
      ),
    );
  }

  Future<APIResponse<bool>> createNote(NoteManipulation item) {
    return http
        .post(
            Uri.parse(
              API + '/notes',
            ),
            headers: headers,
            body: json.encode(item.toJson()))
        .then((data) {
      if (data.statusCode == 201) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(
        error: true,
        errorMessage: 'an error occured',
      );
    }).catchError((_) =>
            APIResponse<bool>(error: true, errorMessage: 'an error occured'));
  }

  Future<APIResponse<bool>> updateNote(String noteID, NoteManipulation item) {
    return http
        .put(
      Uri.parse(
        API + '/notes/' + noteID,
      ),
      headers: headers,
      body: json.encode(
        item.toJson(),
      ),
    )
        .then((data) {
      if (data.statusCode == 204) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(
        error: true,
        errorMessage: 'an error occured',
      );
    }).catchError((_) =>
            APIResponse<bool>(error: true, errorMessage: 'an error occured'));
  }

  Future<APIResponse<bool>> deleteNote(String noteID) {
    return http
        .delete(
      Uri.parse(API + '/notes/' + noteID),
      headers: headers,
    )
        .then((data) {
      if (data.statusCode == 204) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(
        error: true,
        errorMessage: 'an error occured',
      );
    }).catchError((_) =>
            APIResponse<bool>(error: true, errorMessage: 'an error occured'));
  }
}
