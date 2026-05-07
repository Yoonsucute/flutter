import 'package:flutter/material.dart';

import '../models/song_model.dart';

class SongTile extends StatelessWidget {
  final SongModel song;
  final VoidCallback onTap;

  const SongTile({
    super.key,
    required this.song,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFF282828),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.music_note,
          color: Colors.white,
        ),
      ),
      title: Text(
        song.title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        song.artist,
        style: const TextStyle(color: Colors.grey),
      ),
      trailing: const Icon(
        Icons.more_vert,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }
}