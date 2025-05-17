import 'package:flutter/material.dart';

class VoiceNotePlayerController extends ChangeNotifier {
  VoidCallback? _playCallback;
  VoidCallback? _pauseCallback;
  void Function(double)? _seekCallback;
  void Function(double)? _setSpeedCallback;

  // Binding internal player methods to this controller
  void bind({
    VoidCallback? play,
    VoidCallback? pause,
    void Function(double)? seek,
    void Function(double)? setSpeed,
  }) {
    _playCallback = play;
    _pauseCallback = pause;
    _seekCallback = seek;
    _setSpeedCallback = setSpeed;
  }

  void play() => _playCallback?.call();
  void pause() => _pauseCallback?.call();
  void seekTo(double progress) => _seekCallback?.call(progress);
  void setSpeed(double speed) => _setSpeedCallback?.call(speed);
}
