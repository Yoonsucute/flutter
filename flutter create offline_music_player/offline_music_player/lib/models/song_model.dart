class SongModel {
  final String id;
  final String title;
  final String artist;
  final String? album;
  final String filePath;
  final Duration duration;

  SongModel({
    required this.id,
    required this.title,
    required this.artist,
    this.album,
    required this.filePath,
    required this.duration,
  });
}