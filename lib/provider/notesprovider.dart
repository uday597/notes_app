import 'package:flutter/material.dart';

class Notesprovider extends ChangeNotifier {
  List<String> _notes = [];
  List<String> get notes => _notes;
  void addnotes(String note) {
    _notes.add(note);
    notifyListeners();
  }

  void removenotes(int index) {
    _notes.removeAt(index);
    notifyListeners();
  }

  void updatenotes(int index, String note) {
    _notes[index] = note;
    notifyListeners();
  }
}
