import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import '../providers/note_provider.dart';
import '../widgets/note_card.dart';
import 'note_editor_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<NoteProvider>(
        context,
        listen: false,
      ).loadNotes();
    });
  }

  void _openEditor({Note? note}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NoteEditorScreen(note: note),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Notes'),
      ),
      body: Consumer<NoteProvider>(
        builder: (context, provider, child) {

          if (provider.notes.isEmpty) {
            return const Center(
              child: Text('No notes yet'),
            );
          }

          return ListView.builder(
            itemCount: provider.notes.length,
            itemBuilder: (context, index) {

              final note = provider.notes[index];

              return NoteCard(
                note: note,
                onTap: () {
                  _openEditor(note: note);
                },
                onDelete: () async {

                  final confirm =
                      await showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title:
                          const Text('Delete'),
                      content: const Text(
                        'Delete this note?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(
                                context,
                                false);
                          },
                          child:
                              const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(
                                context,
                                true);
                          },
                          child:
                              const Text('Delete'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await provider.deleteNote(
                        note.id!);
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton:
          FloatingActionButton(
        onPressed: () {
          _openEditor();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}