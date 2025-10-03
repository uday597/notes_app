import 'package:flutter/material.dart';
import 'package:notes/database/notes_db.dart';

class Notesprovider extends ChangeNotifier {
  final NotesDB _notesDB = NotesDB();

  List<Map<String, dynamic>> _notes = [];

  List<Map<String, dynamic>> get notes => _notes;

  Future<void> loadNotes() async {
    _notes = await _notesDB.getdata();
    notifyListeners();
  }

  Future<void> addNote(String note) async {
    await _notesDB.adddata(note);
    await loadNotes();
  }

  Future<void> updateNote(int id, String note) async {
    await _notesDB.updateData(id, note);
    await loadNotes();
  }

  Future<void> deleteNote(int id) async {
    await _notesDB.deleteData(id);
    await loadNotes();
  }
}
