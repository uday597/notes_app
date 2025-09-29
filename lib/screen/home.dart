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
  TextEditingController textcontroller = TextEditingController();

  // Bright pastel colors
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
                              note,
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
                                      text: note,
                                    );
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Edit Note'),
                                          content: TextField(
                                            controller: controller,
                                            maxLines: 3,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                if (controller
                                                    .text
                                                    .isNotEmpty) {
                                                  provider.updatenotes(
                                                    index,
                                                    controller.text,
                                                  );
                                                }
                                                controller.clear();
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Update'),
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
                                    provider.removenotes(index);
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
                title: const Text('Add Note'),
                content: TextField(
                  controller: textcontroller,
                  maxLines: 3,
                  decoration: InputDecoration(
                    label: const Text('Enter something'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      if (textcontroller.text.isNotEmpty) {
                        provider.addnotes(textcontroller.text);
                      }
                      textcontroller.clear();
                      Navigator.pop(context);
                    },
                    child: const Text('ADD'),
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
