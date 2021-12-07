import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:note_restapi/models/api_response.dart';
import 'package:note_restapi/models/note_for_listing.dart';
import 'package:note_restapi/services/note_service.dart';
import 'package:note_restapi/views/note_delete.dart';
import 'package:note_restapi/views/note_modify.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  NoteService get service => GetIt.I<NoteService>();

  APIResponse<List<NoteForListing>> _apiResponse;
  bool _isLoading = false;

  String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  void initState() {
    _fetchNote();
    super.initState();
  }

  _fetchNote() async {
    setState(() {
      _isLoading = true;
    });

    _apiResponse = await service.getNoteList();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'List of notes',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => NoteModify()))
              .then((_) {
            _fetchNote();
          });
        },
        child: _isLoading
            ? CircularProgressIndicator(
                backgroundColor: Colors.white,
                strokeWidth: 2,
              )
            : Icon(
                Icons.add,
              ),
      ),
      body: Builder(
        builder: (_) {
          if (_isLoading) {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          }

          if (_apiResponse.error) {
            return Center(
              child: Text(_apiResponse.errorMessage),
            );
          }

          return ListView.separated(
            itemBuilder: (_, index) {
              return Dismissible(
                key: ValueKey(_apiResponse.data[index].noteID),
                direction: DismissDirection.startToEnd,
                onDismissed: (direction) {},
                confirmDismiss: (direction) async {
                  final result = await showDialog(
                      context: context, builder: (_) => NoteDelete());

                  if (result) {
                    final deleteResult = await service
                        .deleteNote(_apiResponse.data[index].noteID);

                    var message;
                    if (deleteResult != null && deleteResult.data == true) {
                      message = 'The note was deleted successfully';
                    } else {
                      message =
                          deleteResult?.errorMessage ?? 'An error occured';
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(message),
                        duration: new Duration(milliseconds: 2000),
                      ),
                    );

                    return deleteResult?.data ?? false;
                  }
                  print(result);
                  return result;
                },
                background: Container(
                  color: Colors.red,
                  padding: EdgeInsets.only(
                    left: 20,
                  ),
                  child: Align(
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                ),
                child: ListTile(
                  title: Text(
                    _apiResponse.data[index].noteTitle,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    'last edited on ${formatDateTime(_apiResponse.data[index].latestEditDateTime ?? _apiResponse.data[index].createDateTime)}',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (_) => NoteModify(
                                  noteID: _apiResponse.data[index].noteID,
                                )))
                        .then((data) => _fetchNote());
                  },
                ),
              );
            },
            separatorBuilder: (_, __) => Divider(
              height: 1,
              color: Colors.blue,
            ),
            itemCount: _apiResponse.data.length,
          );
        },
      ),
    );
  }
}
