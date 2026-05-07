import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'models/song_model.dart';
import 'providers/audio_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AudioProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Offline Music Player',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF191414),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1DB954),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> pickMusicFiles(BuildContext context) async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.any,
    allowMultiple: true,
  );

  if (result == null || result.files.isEmpty) {
    print('Không chọn file nào');
    return;
  }

  final songs = result.files
      .where((file) {
        final name = file.name.toLowerCase();
        return file.path != null &&
            (name.endsWith('.mp3') ||
                name.endsWith('.m4a') ||
                name.endsWith('.wav') ||
                name.endsWith('.aac') ||
                name.endsWith('.flac') ||
                name.endsWith('.ogg'));
      })
      .map((file) {
        print('Đã chọn: ${file.name} - ${file.path}');

        return SongModel(
          id: file.path!,
          title: file.name,
          artist: 'Unknown Artist',
          album: 'Unknown Album',
          filePath: file.path!,
          duration: Duration.zero,
        );
      })
      .toList();

  if (!context.mounted) return;

  if (songs.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('File chọn không phải file nhạc hợp lệ')),
    );
    return;
  }

  await context.read<AudioProvider>().setSongs(songs);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Đã thêm ${songs.length} bài hát')),
  );
}

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AudioProvider>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: provider.songs.isEmpty
                  ? _buildEmptyState(context)
                  : _buildSongList(context, provider),
            ),
            const MiniPlayer(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'My Music',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            onPressed: () => pickMusicFiles(context),
            icon: const Icon(Icons.folder_open, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PlaylistScreen()),
              );
            },
            icon: const Icon(Icons.playlist_play, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
            icon: const Icon(Icons.settings, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.music_note, size: 90, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No Music Found',
            style: TextStyle(fontSize: 22, color: Colors.white),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => pickMusicFiles(context),
            icon: const Icon(Icons.folder_open),
            label: const Text('Choose Music Files'),
          ),
        ],
      ),
    );
  }

  Widget _buildSongList(BuildContext context, AudioProvider provider) {
    return ListView.builder(
      itemCount: provider.songs.length,
      itemBuilder: (context, index) {
        final song = provider.songs[index];

        return ListTile(
          leading: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFF282828),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.music_note, color: Colors.grey),
          ),
          title: Text(
            song.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            song.artist,
            style: const TextStyle(color: Colors.grey),
          ),
          trailing: const Icon(Icons.play_arrow, color: Colors.white),
          onTap: () => provider.playSong(index),
        );
      },
    );
  }
}

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AudioProvider>();
    final song = provider.currentSong;

    if (song == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NowPlayingScreen()),
        );
      },
      child: Container(
        height: 82,
        color: const Color(0xFF282828),
        child: Column(
          children: [
            StreamBuilder<Duration>(
              stream: provider.player.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                final duration = provider.player.duration ?? Duration.zero;
                final value = duration.inMilliseconds == 0
                    ? 0.0
                    : position.inMilliseconds / duration.inMilliseconds;

                return LinearProgressIndicator(
                  value: value.clamp(0.0, 1.0),
                  minHeight: 3,
                  backgroundColor: Colors.grey[800],
                  color: const Color(0xFF1DB954),
                );
              },
            ),
            Expanded(
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  const Icon(Icons.music_note, color: Colors.white, size: 40),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      song.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    onPressed: provider.previous,
                    icon: const Icon(Icons.skip_previous, color: Colors.white),
                  ),
                  StreamBuilder<PlayerState>(
                    stream: provider.player.playerStateStream,
                    builder: (context, snapshot) {
                      final isPlaying = provider.player.playing;
                      return IconButton(
                        onPressed: provider.playPause,
                        icon: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                  IconButton(
                    onPressed: provider.next,
                    icon: const Icon(Icons.skip_next, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NowPlayingScreen extends StatelessWidget {
  const NowPlayingScreen({super.key});

  String formatDuration(Duration d) {
    final min = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final sec = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$min:$sec';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AudioProvider>();
    final song = provider.currentSong;

    if (song == null) {
      return const Scaffold(
        body: Center(child: Text('No song playing')),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.keyboard_arrow_down, size: 34),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Now Playing',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const Spacer(),
              Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  color: const Color(0xFF282828),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.music_note, size: 120, color: Colors.grey),
              ),
              const SizedBox(height: 36),
              Text(
                song.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                song.artist,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 30),
              StreamBuilder<Duration>(
                stream: provider.player.positionStream,
                builder: (context, snapshot) {
                  final position = snapshot.data ?? Duration.zero;
                  final duration = provider.player.duration ?? Duration.zero;

                  return Column(
                    children: [
                      Slider(
                        min: 0,
                        max: duration.inMilliseconds.toDouble() <= 0
                            ? 1
                            : duration.inMilliseconds.toDouble(),
                        value: position.inMilliseconds
                            .toDouble()
                            .clamp(0, duration.inMilliseconds.toDouble() <= 0
                                ? 1
                                : duration.inMilliseconds.toDouble()),
                        onChanged: (value) {
                          provider.seek(Duration(milliseconds: value.toInt()));
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(formatDuration(position)),
                          Text(formatDuration(duration)),
                        ],
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                    onPressed: provider.previous,
                    icon: const Icon(Icons.skip_previous, size: 42),
                  ),
                  StreamBuilder<PlayerState>(
                    stream: provider.player.playerStateStream,
                    builder: (context, snapshot) {
                      final isPlaying = provider.player.playing;
                      return CircleAvatar(
                        radius: 35,
                        backgroundColor: const Color(0xFF1DB954),
                        child: IconButton(
                          onPressed: provider.playPause,
                          icon: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 38,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    onPressed: provider.next,
                    icon: const Icon(Icons.skip_next, size: 42),
                  ),
                  IconButton(
                    onPressed: provider.toggleRepeat,
                    icon: Icon(
                      provider.loopMode == LoopMode.one
                          ? Icons.repeat_one
                          : Icons.repeat,
                      color: provider.loopMode == LoopMode.off
                          ? Colors.grey
                          : const Color(0xFF1DB954),
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final songs = context.watch<AudioProvider>().songs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Playlist'),
        backgroundColor: const Color(0xFF191414),
      ),
      body: songs.isEmpty
          ? const Center(child: Text('No playlist yet'))
          : ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                return ListTile(
                  leading: const Icon(Icons.music_note),
                  title: Text(song.title),
                  subtitle: Text(song.artist),
                  onTap: () {
                    context.read<AudioProvider>().playSong(index);
                  },
                );
              },
            ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AudioProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF191414),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Shuffle'),
            value: provider.shuffle,
            onChanged: (_) => provider.toggleShuffle(),
          ),
          ListTile(
            title: const Text('Repeat Mode'),
            subtitle: Text(provider.loopMode.name),
            trailing: const Icon(Icons.repeat),
            onTap: provider.toggleRepeat,
          ),
          ListTile(
            title: const Text('About'),
            subtitle: const Text('Simple Offline Music Player - LAB6'),
            trailing: const Icon(Icons.info_outline),
          ),
        ],
      ),
    );
  }
}