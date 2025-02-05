import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;

  late AudioPlayer _player;
  bool _isPlaying = false;

  AudioManager._internal() {
    _player = AudioPlayer();
  }

  Future<void> playMusic(String path) async {
    if (!_isPlaying) {
      await _player.play(AssetSource(path),volume: 0.5);
      _isPlaying = true;
    }
  }

  Future<void> stopMusic() async {
    await _player.stop();
    _isPlaying = false;
  }

  void dispose() {
    _player.dispose();
  }
}
