import 'package:flutter/material.dart';

class NoteDelete extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(
        'are you sure you want to delete this note',
      ),
      actions: [
        TextButton(
          child: Text(
            'yes',
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
        TextButton(
          child: Text(
            'No',
          ),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        
      ],
    );
  }
}
