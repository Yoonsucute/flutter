import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/song_model.dart';
import '../providers/audio_provider.dart';
import '../widgets/mini_player.dart';
import '../widgets/song_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> pickSongs(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: true,
    );
    if (!context.mounted) return;
    if (result == null) return;

    final songs = result.files.where((file) => file.path != null).map((file) {
      final path = file.path!;
      final name = file.name;

      return SongModel(
        id: path,
        title: name.replaceAll('.mp3', '').replaceAll('.m4a', ''),
        artist: 'Unknown Artist',
        filePath: path,
        duration: Duration.zero,
      );
    }).toList();

    context.read<AudioProvider>().setSongs(songs);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AudioProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF191414),
      appBar: AppBar(
        backgroundColor: const Color(0xFF191414),
        elevation: 0,
        title: const Text(
          'My Music',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => pickSongs(context),
            icon: const Icon(Icons.folder_open),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: provider.songs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.music_note,
                          color: Colors.grey,
                          size: 80,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No Music Found',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () => pickSongs(context),
                          icon: const Icon(Icons.folder_open),
                          label: const Text('Choose Music Files'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: provider.songs.length,
                    itemBuilder: (context, index) {
                      final song = provider.songs[index];

                      return SongTile(
                        song: song,
                        onTap: () {
                          provider.playSong(index);
                        },
                      );
                    },
                  ),
          ),
          const MiniPlayer(),
        ],
      ),
    );
  }
}