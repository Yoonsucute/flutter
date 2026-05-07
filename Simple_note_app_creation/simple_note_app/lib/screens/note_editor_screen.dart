import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import '../providers/note_provider.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? note;

  const NoteEditorScreen({super.key, this.note});

  @override
  State<NoteEditorScreen> createState() =>
      _NoteEditorScreenState();
}

class _NoteEditorScreenState
    extends State<NoteEditorScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  Future<void> saveNote() async {
    final provider =
        Provider.of<NoteProvider>(context, listen: false);

    final now = DateTime.now();

    if (widget.note == null) {
      final newNote = Note(
        title: _titleController.text,
        content: _contentController.text,
        createdAt: now,
        updatedAt: now,
      );

      await provider.addNote(newNote);
    } else {
      final updatedNote = Note(
        id: widget.note!.id,
        title: _titleController.text,
        content: _contentController.text,
        createdAt: widget.note!.createdAt,
        updatedAt: now,
      );

      await provider.updateNote(updatedNote);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.note == null
              ? 'Add Note'
              : 'Edit Note',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _contentController,
              maxLines: 8,
              decoration: const InputDecoration(
                labelText: 'Content',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveNote,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}