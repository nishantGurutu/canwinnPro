import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioPath;
  const AudioPlayerWidget({
    super.key,
    required this.audioPath,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _audioPlayer = AudioPlayer();
  //   _playAudio();
  // }

  // Future<void> _playAudio() async {
  //   await _audioPlayer.play(AssetSource(widget.audioPath));
  //   setState(() {
  //     _isPlaying = true;
  //   });
  // }

  Future<void> _stopAudio() async {
    await _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
    });
  }

  // @override
  // void dispose() {
  //   _audioPlayer.dispose();
  //   super.dispose();
  // }
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Listen for when the audio completes
    _audioPlayer.onPlayerComplete.listen((event) {
      // Restart the audio after it finishes playing
      _restartAudio();
    });

    // Start playing the audio
    _playAudio();
  }

  Future<void> _playAudio() async {
    await _audioPlayer.play(AssetSource(widget.audioPath));
  }

  void _restartAudio() async {
    // Restart the audio by playing it again
    await _audioPlayer.seek(
        Duration.zero); // Optional: You can reset the position to the beginning
    await _playAudio(); // Play the audio again
  }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.dispose(); // Clean up resources when the widget is disposed
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _isPlaying ? "Playing..." : "Stopped",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        ElevatedButton(
          onPressed: _isPlaying ? _stopAudio : _playAudio,
          child: Text(_isPlaying ? "Stop" : "Play"),
        ),
      ],
    );
  }
}
