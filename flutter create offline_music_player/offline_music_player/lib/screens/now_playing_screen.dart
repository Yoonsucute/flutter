import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/audio_provider.dart';
import '../widgets/player_controls.dart';
import '../widgets/progress_bar.dart';

class NowPlayingScreen extends StatelessWidget {
  const NowPlayingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioProvider>(
      builder: (context, provider, child) {
        final song = provider.currentSong;

        if (song == null) {
          return const Scaffold(
            backgroundColor: Color(0xFF191414),
            body: Center(
              child: Text(
                'No song playing',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFF191414),
          appBar: AppBar(
            backgroundColor: const Color(0xFF191414),
            elevation: 0,
            title: const Text('Now Playing'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    color: const Color(0xFF282828),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.music_note,
                    color: Colors.white,
                    size: 120,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  song.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  song.artist,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 30),
                StreamBuilder<Duration>(
                  stream: provider.positionStream,
                  builder: (context, snapshot) {
                    final position = snapshot.data ?? Duration.zero;
                    final duration = provider.player.duration ?? Duration.zero;

                    return ProgressBar(
                      position: position,
                      duration: duration,
                      onSeek: provider.seek,
                    );
                  },
                ),
                const SizedBox(height: 20),
                PlayerControls(provider: provider),
              ],
            ),
          ),
        );
      },
    );
  }
}