// default_player_style.dart

import 'package:flutter/material.dart';
import 'package:voice_note_kit/player/audio_player_widget.dart';
import 'package:voice_note_kit/player/utils/format_duration.dart';
import 'package:voice_note_kit/player/widgets/player_controller_widget.dart';
import 'package:voice_note_kit/player/widgets/progress_bar_widget.dart';

/// A widget that represents the third player style.
class StyleThreeWidget extends StatelessWidget {
  /// A widget that represents the third player style.
  final AudioPlayerWidget widget;

  /// A flag indicating whether the audio is currently playing.
  final bool isPlaying;

  /// The current progress of the audio playback.
  final double progress;

  /// The current position of the audio playback.
  final Duration position;

  /// The total duration of the audio.
  final Duration duration;

  /// A function to play the audio.
  final Function playAudio;

  /// A function to pause the audio.
  final Function pauseAudio;

  /// A function to seek to a specific position in the audio.
  final Function(double) seekTo;

  /// Creates a new instance of the [StyleThreeWidget] class.
  const StyleThreeWidget({
    super.key,
    required this.widget,
    required this.isPlaying,
    required this.progress,
    required this.position,
    required this.duration,
    required this.playAudio,
    required this.pauseAudio,
    required this.seekTo,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.textDirection,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.showProgressBar
              ? Text(
                  '${formatDuration(position)} / ${formatDuration(duration)}',
                  style: widget.timerTextStyle ??
                      const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                )
              : const SizedBox.shrink(),
          const SizedBox(height: 8),
          PlayerControls(
            textDirection: widget.textDirection,
            size: widget.size,
            iconColor: widget.iconColor,
            backgroundColor: widget.backgroundColor,
            shapeType: widget.shapeType,
            isPlaying: isPlaying,
            onPlayPause: () {
              if (isPlaying) {
                pauseAudio();
              } else {
                playAudio();
              }
            },
          ),
          const SizedBox(height: 8),
          widget.showProgressBar
              ? SizedBox(
                  width: widget.size,
                  child: ProgressBar(
                    progressBarHeight: widget.progressBarHeight,
                    progressBarBackgroundColor:
                        widget.progressBarBackgroundColor,
                    progressBarColor: widget.progressBarColor,
                    progress: progress,
                    seekTo: seekTo,
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
