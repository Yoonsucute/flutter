import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../providers/audio_provider.dart';

class PlayerControls extends StatelessWidget {
  final AudioProvider provider;

  const PlayerControls({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    IconData repeatIcon = Icons.repeat;
    Color repeatColor = Colors.grey;

    if (provider.loopMode == LoopMode.all) {
      repeatIcon = Icons.repeat;
      repeatColor = const Color(0xFF1DB954);
    } else if (provider.loopMode == LoopMode.one) {
      repeatIcon = Icons.repeat_one;
      repeatColor = const Color(0xFF1DB954);
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: provider.toggleShuffle,
              icon: Icon(
                Icons.shuffle,
                color: provider.shuffle
                    ? const Color(0xFF1DB954)
                    : Colors.grey,
              ),
            ),
            IconButton(
              onPressed: provider.toggleRepeat,
              icon: Icon(
                repeatIcon,
                color: repeatColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: provider.previous,
              icon: const Icon(
                Icons.skip_previous,
                color: Colors.white,
                size: 40,
              ),
            ),
            StreamBuilder<bool>(
              stream: provider.playingStream,
              builder: (context, snapshot) {
                final isPlaying = snapshot.data ?? false;

                return CircleAvatar(
                  radius: 36,
                  backgroundColor: const Color(0xFF1DB954),
                  child: IconButton(
                    onPressed: provider.playPause,
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                );
              },
            ),
            IconButton(
              onPressed: provider.next,
              icon: const Icon(
                Icons.skip_next,
                color: Colors.white,
                size: 40,
              ),
            ),
          ],
        ),
      ],
    );
  }
}