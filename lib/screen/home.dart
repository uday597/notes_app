import 'package:flutter/material.dart';
import 'package:notes/provider/notesprovider.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Notesprovider>(context, listen: false).loadNotes();
    });
  }

  TextEditingController textcontroller = TextEditingController();

  final List<Color> noteColors = [
    Color(0xFFFFF9C4),
    Color(0xFFFFCDD2),
    Color(0xFFC8E6C9),
    Color(0xFFBBDEFB),
    Color(0xFFFFE0B2),
  ];

  Color getRandomColor() {
    final random = Random();
    return noteColors[random.nextInt(noteColors.length)];
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Notesprovider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey[100],
        padding: const EdgeInsets.all(12),
        child: provider.notes.isEmpty
            ? const Center(
                child: Text(
                  "No notes yet 📝",
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              )
            : SingleChildScrollView(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: List.generate(provider.notes.length, (index) {
                    final note = provider.notes[index];
                    final color = getRandomColor();

                    return ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 160),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: const Offset(2, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              note['description'],
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    final controller = TextEditingController(
                                      text: note['description'],
                                    );
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          title: Row(
                                            children: const [
                                              Icon(
                                                Icons.edit,
                                                color: Colors.orange,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                'Edit Note',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          content: TextField(
                                            controller: controller,
                                            maxLines: 4,
                                            decoration: InputDecoration(
                                              hintText: "Update your note...",
                                              filled: true,
                                              fillColor: Colors.grey[100],
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 12,
                                                    horizontal: 16,
                                                  ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                "Cancel",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.orange,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                              onPressed: () {
                                                if (controller
                                                    .text
                                                    .isNotEmpty) {
                                                  provider.updateNote(
                                                    note['id'],
                                                    controller.text,
                                                  );
                                                }
                                                controller.clear();
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                "Update",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.edit, size: 20),
                                ),
                                IconButton(
                                  onPressed: () {
                                    provider.deleteNote(note['id']);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Row(
                  children: const [
                    Icon(Icons.note_add, color: Colors.teal),
                    SizedBox(width: 8),
                    Text(
                      'Add New Note',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                content: TextField(
                  controller: textcontroller,
                  maxLines: 4,
                  decoration: InputDecoration(
                    label: const Text('Enter something'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      textcontroller.clear();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (textcontroller.text.isNotEmpty) {
                        provider.addNote(textcontroller.text);
                      }
                      textcontroller.clear();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Add",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
