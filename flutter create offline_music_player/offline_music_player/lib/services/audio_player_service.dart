import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class PlaybackStateModel {
  final Duration position;
  final Duration duration;
  final bool isPlaying;

  PlaybackStateModel({
    required this.position,
    required this.duration,
    required this.isPlaying,
  });

  double get progress {
    if (duration.inMilliseconds == 0) return 0;
    return position.inMilliseconds / duration.inMilliseconds;
  }
}

class AudioPlayerService {
  final AudioPlayer _player = AudioPlayer();

  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<bool> get playingStream => _player.playingStream;

  bool get isPlaying => _player.playing;
  Duration get currentPosition => _player.position;

  Stream<PlaybackStateModel> get playbackStateStream {
    return Rx.combineLatest3<Duration, Duration?, bool, PlaybackStateModel>(
      positionStream,
      durationStream,
      playingStream,
      (position, duration, isPlaying) {
        return PlaybackStateModel(
          position: position,
          duration: duration ?? Duration.zero,
          isPlaying: isPlaying,
        );
      },
    );
  }

  Future<Duration?> loadAudio(String path) async {
    return await _player.setFilePath(path);
  }

  Future<void> play() async {
    await _player.play();
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  Future<void> setLoopMode(LoopMode mode) async {
    await _player.setLoopMode(mode);
  }

  void dispose() {
    _player.dispose();
  }
}