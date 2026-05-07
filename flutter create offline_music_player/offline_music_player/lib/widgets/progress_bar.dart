import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final Duration position;
  final Duration duration;
  final Function(Duration) onSeek;

  const ProgressBar({
    super.key,
    required this.position,
    required this.duration,
    required this.onSeek,
  });

  String format(Duration duration) {
    String two(int n) => n.toString().padLeft(2, '0');
    final minutes = two(duration.inMinutes.remainder(60));
    final seconds = two(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final max = duration.inMilliseconds.toDouble();
    final value = position.inMilliseconds.clamp(0, duration.inMilliseconds);

    return Column(
      children: [
        Slider(
          value: max == 0 ? 0 : value.toDouble(),
          min: 0,
          max: max == 0 ? 1 : max,
          activeColor: const Color(0xFF1DB954),
          inactiveColor: Colors.grey,
          onChanged: (v) {
            onSeek(Duration(milliseconds: v.toInt()));
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(format(position), style: const TextStyle(color: Colors.grey)),
              Text(format(duration), style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }
}