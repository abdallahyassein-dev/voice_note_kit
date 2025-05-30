import 'package:flutter/material.dart';

/// Controller for the audio player
class VoiceNotePlayerController extends ChangeNotifier {
  /// Internal player callbacks _playCallback
  VoidCallback? _playCallback;

  /// Internal player callbacks _pauseCallback
  VoidCallback? _pauseCallback;

  /// Internal player callbacks _seekCallback
  void Function(double)? _seekCallback;

  /// Internal player callbacks _setSpeedCallback
  void Function(double)? _setSpeedCallback;

  /// Binding internal player methods to this controller
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

  /// Internal player methods

  /// Calls the internal player callbacks play
  void play() => _playCallback?.call();

  /// Calls the internal player callbacks pause
  void pause() => _pauseCallback?.call();

  /// Calls the internal player callbacks seekTo
  void seekTo(double progress) => _seekCallback?.call(progress);

  /// Calls the internal player callbacks setSpeed
  void setSpeed(double speed) => _setSpeedCallback?.call(speed);
}
