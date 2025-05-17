import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:voice_note_kit/player/player_enums/player_enums.dart';
import 'package:voice_note_kit/player/styles/style_3_widget.dart';
import 'package:voice_note_kit/player/styles/style_2_widget.dart';
import 'package:voice_note_kit/player/styles/style_1_widget.dart';
import 'package:voice_note_kit/player/styles/style_4_widget.dart';
import 'package:voice_note_kit/player/styles/style_5_widget.dart';
import 'package:voice_note_kit/player/utils/audio_player_controller.dart';

import 'package:voice_note_kit/player/utils/dummy_initial_waves.dart';
import 'package:voice_note_kit/player/utils/generate_waves_from_audio.dart';

import 'utils/blob_configuration/blob_configurations.dart';

class AudioPlayerWidget extends StatefulWidget {
  /// The controller for the audio player.
  final VoiceNotePlayerController? controller;

  /// The path to the audio file (can be a URL, local path, or asset).
  final String? audioPath;

  /// The source type of the audio (URL, asset, or file).
  final AudioType audioType;

  /// The size of the play/pause icon button.
  final double size;

  /// The background color of the play/pause button.
  final Color backgroundColor;

  /// The color of the play/pause icon.
  final Color iconColor;

  /// The text style for the timer display (if shown).
  final TextStyle? timerTextStyle;

  /// The shape of the play/pause button (e.g., circular or square).
  final PlayIconShapeType shapeType;

  /// The visual style to use for the player (determines layout and controls).
  final PlayerStyle playerStyle;

  /// The height of the progress bar (if shown).
  final double progressBarHeight;

  /// The color of the active progress bar.
  final Color progressBarColor;

  /// The background color of the progress bar.
  final Color progressBarBackgroundColor;

  /// The overall width of the player widget.
  final double width;

  /// Whether to show the progress bar.
  final bool showProgressBar;

  /// Whether to show the current time/duration timer.
  final bool showTimer;

  /// Whether to show the playback speed control.
  final bool showSpeedControl;

  /// A list of selectable playback speeds (e.g., [0.5, 1.0, 1.5, 2.0]).
  final List<double>? audioSpeeds;

  /// Callback function triggered when an error occurs.
  final Function(String message)? onError;

  /// Callback function triggered when the user seeks through the audio.
  final Function(double value)? onSeek;

  /// Callback function triggered when playback starts or stops.
  final Function(bool isPlaying)? onPlay;

  /// Callback function triggered when the playback speed changes.
  final Function(double speed)? onSpeedChange;

  /// Callback function triggered when the audio is paused.
  final Function()? onPause;

  /// The text direction for layout (e.g., left-to-right or right-to-left).
  final TextDirection textDirection;

  /// Whether to automatically load the audio when the widget is initialized.
  final bool autoLoad;

  /// Whether to automatically start playing the audio when loaded.
  final bool autoPlay;

  const AudioPlayerWidget({
    super.key,
    this.controller,
    this.autoLoad = true,
    this.autoPlay = false,
    this.textDirection = TextDirection.ltr,
    required this.audioPath,
    this.audioType = AudioType.directFile,
    this.audioSpeeds,
    this.size = 56,
    this.width = 400,
    this.backgroundColor = Colors.blueAccent,
    this.iconColor = Colors.white,
    this.timerTextStyle,
    this.shapeType = PlayIconShapeType.circular,
    this.playerStyle = PlayerStyle.style1,
    this.progressBarHeight = 3.0,
    this.progressBarColor = Colors.blueAccent,
    this.progressBarBackgroundColor = Colors.grey,
    this.showProgressBar = true,
    this.showTimer = true,
    this.showSpeedControl = true,
    this.onError,
    this.onPause,
    this.onPlay,
    this.onSeek,
    this.onSpeedChange,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  double _progress = 0.0;
  double _currentSpeed = 1.0;

  List<double> _waveform = [];

  @override
  void initState() {
    super.initState();

    _audioPlayer = AudioPlayer();

    widget.controller?.bind(
      play: _playAudio,
      pause: _pauseAudio,
      seek: _seekTo,
      setSpeed: _setSpeed,
    );

    if (widget.autoLoad) {
      initializeFiles();
    }

    if (widget.autoPlay) {
      _playAudio();
    }
    if (widget.playerStyle == PlayerStyle.style5) {
      if (kIsWeb) {
        return;
      }
      _waveform = [];
      generateWaveform(widget.audioType, widget.audioPath).then((value) {
        setState(() {
          _waveform = value;
        });
      });
    }
    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _position = position;
        _progress = _duration.inSeconds > 0
            ? _position.inSeconds / _duration.inSeconds
            : 0.0;
      });
    });

    _audioPlayer.durationStream.listen((duration) {
      setState(() {
        _duration = duration ?? Duration.zero;
      });
    });

    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  initializeFiles() async {
    if (_audioPlayer.audioSource == null) {
      if (widget.audioType == AudioType.assets) {
        await _audioPlayer.setAsset(widget.audioPath!);
      } else if (widget.audioType == AudioType.directFile) {
        await _audioPlayer.setFilePath(widget.audioPath!);
      } else if (widget.audioType == AudioType.url) {
        await _audioPlayer.setUrl(widget.audioPath!);
      }
      await _audioPlayer.setSpeed(_currentSpeed);
      setState(() {});
    }
  }

  Future<void> _playAudio() async {
    try {
      // Reload only if source is null OR playback has completed
      if (_audioPlayer.audioSource == null ||
          _audioPlayer.playerState.processingState ==
              ProcessingState.completed) {
        if (widget.audioType == AudioType.assets) {
          await _audioPlayer.setAsset(widget.audioPath!);
        } else if (widget.audioType == AudioType.directFile) {
          await _audioPlayer.setFilePath(widget.audioPath!);
        } else if (widget.audioType == AudioType.url) {
          await _audioPlayer.setUrl(widget.audioPath!);
        } else if (widget.audioType == AudioType.blobforWeb) {
          final audioUrl = await getBlobUrl(widget.audioPath!);

          await _audioPlayer.setUrl(audioUrl);
        }
        await _audioPlayer.setSpeed(_currentSpeed);
      }

      _audioPlayer.play();
      setState(() {
        _isPlaying = true;
      });

      if (widget.onPlay != null) {
        widget.onPlay!(_isPlaying);
      }
    } catch (e) {
      if (widget.onError != null) {
        widget.onError!("$e");
      }
    }
  }

  Future<void> _pauseAudio() async {
    await _audioPlayer.pause();
    if (widget.onPause != null) {
      widget.onPause!();
    }

    setState(() {
      _isPlaying = false;
    });
    if (widget.onPlay != null) {
      widget.onPlay!(_isPlaying);
    }
  }

  Future<void> _seekTo(double value) async {
    if (value > 1) {
      value = 1;
    }
    if (value < 0) {
      value = 0;
    }
    final position = Duration(seconds: (value * _duration.inSeconds).toInt());
    if (widget.onSeek != null) {
      widget.onSeek!(value);
    }
    await _audioPlayer.seek(position);
  }

  Future<void> _setSpeed(double speed) async {
    await _audioPlayer.setSpeed(speed);
    if (widget.onSpeedChange != null) {
      widget.onSpeedChange!(speed);
    }
    setState(() {
      _currentSpeed = speed;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.playerStyle) {
      case PlayerStyle.style1:
        return StyleOneWidget(
          widget: widget,
          isPlaying: _isPlaying,
          progress: _progress,
          position: _position,
          duration: _duration,
          showProgressBar: widget.showProgressBar,
          showTimer: widget.showTimer,
          currentSpeed: _currentSpeed,
          showSpeedControl: widget.showSpeedControl,
          playbackSpeeds: widget.audioSpeeds ?? const [0.5, 1.0, 1.5, 2.0],
          setSpeed: _setSpeed,
          playAudio: _playAudio,
          pauseAudio: _pauseAudio,
          seekTo: _seekTo,
        );
      case PlayerStyle.style2:
        return StyleTwoWidget(
          widget: widget,
          isPlaying: _isPlaying,
          progress: _progress,
          position: _position,
          duration: _duration,
          showProgressBar: widget.showProgressBar,
          showTimer: widget.showTimer,
          currentSpeed: _currentSpeed,
          showSpeedControl: widget.showSpeedControl,
          playbackSpeeds: widget.audioSpeeds ?? const [0.5, 1.0, 1.5, 2.0],
          setSpeed: _setSpeed,
          playAudio: _playAudio,
          pauseAudio: _pauseAudio,
          seekTo: _seekTo,
        );
      case PlayerStyle.style3:
        return StyleThreeWidget(
          widget: widget,
          isPlaying: _isPlaying,
          progress: _progress,
          position: _position,
          duration: _duration,
          playAudio: _playAudio,
          pauseAudio: _pauseAudio,
          seekTo: _seekTo,
        );
      case PlayerStyle.style4:
        return StyleFourWidget(
          widget: widget,
          isPlaying: _isPlaying,
          progress: _progress,
          position: _position,
          duration: _duration,
          currentSpeed: _currentSpeed,
          showSpeedControl: widget.showSpeedControl,
          playbackSpeeds: widget.audioSpeeds ?? const [0.5, 1.0, 1.5, 2.0],
          setSpeed: _setSpeed,
          playAudio: _playAudio,
          pauseAudio: _pauseAudio,
          seekTo: _seekTo,
        );
      case PlayerStyle.style5:
        return StyleFiveWidget(
          waveformData: kIsWeb || _waveform.isEmpty ? dummyWaves : _waveform,
          widget: widget,
          isPlaying: _isPlaying,
          progress: _progress,
          position: _position,
          duration: _duration,
          showProgressBar: widget.showProgressBar,
          showTimer: widget.showTimer,
          currentSpeed: _currentSpeed,
          showSpeedControl: widget.showSpeedControl,
          playbackSpeeds: widget.audioSpeeds ?? const [0.5, 1.0, 1.5, 2.0],
          setSpeed: _setSpeed,
          playAudio: _playAudio,
          pauseAudio: _pauseAudio,
          seekTo: _seekTo,
        );
    }
  }
}
