import 'dart:math';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song_model.dart';

class AudioProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();

  List<SongModel> songs = [];
  int currentIndex = -1;

  bool shuffle = false;
  LoopMode loopMode = LoopMode.off;

  AudioPlayer get player => _player;

  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<PlayerState> get playerStateStream =>
      _player.playerStateStream;
  Stream<bool> get playingStream => _player.playingStream;

  bool get isShuffle => shuffle;

  SongModel? get currentSong {
    if (currentIndex < 0 || currentIndex >= songs.length) {
      return null;
    }
    return songs[currentIndex];
  }

  Future<void> setSongs(List<SongModel> list) async {
  songs.addAll(list);

  final uniqueSongs = <String, SongModel>{};

  for (final song in songs) {
    uniqueSongs[song.filePath] = song;
  }

  songs = uniqueSongs.values.toList();

  notifyListeners();
}

  Future<void> playSong(int index) async {
    if (index < 0 || index >= songs.length) return;

    currentIndex = index;

    await _player.setFilePath(songs[index].filePath);
    await _player.play();

    notifyListeners();
  }

  Future<void> playPause() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }

    notifyListeners();
  }

  Future<void> next() async {
    if (songs.isEmpty) return;

    if (shuffle) {
      currentIndex = Random().nextInt(songs.length);
    } else {
      currentIndex = (currentIndex + 1) % songs.length;
    }

    await playSong(currentIndex);
  }

  Future<void> previous() async {
    if (songs.isEmpty) return;

    currentIndex--;

    if (currentIndex < 0) {
      currentIndex = songs.length - 1;
    }

    await playSong(currentIndex);
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  void toggleShuffle() {
    shuffle = !shuffle;
    notifyListeners();
  }

  Future<void> toggleRepeat() async {
    if (loopMode == LoopMode.off) {
      loopMode = LoopMode.all;
    } else if (loopMode == LoopMode.all) {
      loopMode = LoopMode.one;
    } else {
      loopMode = LoopMode.off;
    }

    await _player.setLoopMode(loopMode);

    notifyListeners();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}