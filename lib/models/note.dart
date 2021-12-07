class Note {
  String noteID;
  String noteTitle;
  String noteContent;
  DateTime createDateTime;
  DateTime latestEditDateTime;

  Note({
    this.noteID,
    this.createDateTime,
    this.noteContent,
    this.latestEditDateTime,
    this.noteTitle,
  });

  factory Note.fromJson(Map<String, dynamic> item) {
    return Note(
      noteID: item['noteID'],
      noteTitle: item['noteTitle'],
      noteContent: item['noteContent'],
      createDateTime: DateTime.parse(item['createDateTime']),
      latestEditDateTime: item['latestEditDateTime'] != null
          ? DateTime.parse(item['latestEditDateTime'])
          : null,
    );
  }
}
