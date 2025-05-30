// whatsapp_player_style.dart

import 'package:flutter/material.dart';
import 'package:voice_note_kit/player/audio_player_widget.dart';
import 'package:voice_note_kit/player/utils/format_duration.dart';
import 'package:voice_note_kit/player/widgets/custom_slider.dart';
import 'package:voice_note_kit/player/widgets/custom_speed_button.dart';
import 'package:voice_note_kit/player/widgets/player_controller_widget.dart';

/// A widget that represents the second player style.
class StyleTwoWidget extends StatelessWidget {
  /// The main widget for the audio player.
  final AudioPlayerWidget widget;

  /// Indicates whether the audio is currently playing.
  final bool isPlaying;

  /// The progress of the audio playback.
  final double progress;

  /// The current position of the audio playback.
  final Duration position;

  /// The total duration of the audio.
  final Duration duration;

  /// The callback function to play the audio.
  final Function playAudio;

  /// The callback function to pause the audio.
  final Function pauseAudio;

  /// Indicates whether to show the progress bar.
  final bool showProgressBar;

  /// Indicates whether to show the timer.
  final bool showTimer;

  /// The callback function to seek to a specific position in the audio.
  final Function(double) seekTo;

  /// The callback function to seek to a specific position in the audio.
  final bool showSpeedControl; // New property
  /// The callback function to seek to a specific position in the audio.
  final List<double> playbackSpeeds; // New property
  /// The callback function to seek to a specific position in the audio.
  final double currentSpeed;

  /// The callback function to seek to a specific position in the audio.
  final Function(double) setSpeed;

  /// Create a new instance of [StyleTwoWidget].
  const StyleTwoWidget(
      {super.key,
      required this.widget,
      required this.isPlaying,
      required this.progress,
      required this.position,
      required this.duration,
      required this.playAudio,
      required this.pauseAudio,
      required this.seekTo,
      this.showTimer = true,
      this.showProgressBar = true,
      required this.showSpeedControl,
      required this.playbackSpeeds,
      required this.currentSpeed,
      required this.setSpeed});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.textDirection,
      child: SizedBox(
        width: widget.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
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
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.showProgressBar
                      ? CustomSlider(
                          progress: progress,
                          progressBarColor: widget.progressBarColor,
                          progressBarBackgroundColor:
                              widget.progressBarBackgroundColor,
                          seekTo: seekTo,
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(height: 8),
                  widget.showTimer
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
                  if (showSpeedControl) ...[
                    const SizedBox(width: 8.0),
                    if (showSpeedControl)
                      SpeedButton(
                        backgroundColor: widget.backgroundColor
                            .withAlpha((0.2 * 255).round()),
                        currentSpeed: currentSpeed,
                        playbackSpeeds: playbackSpeeds,
                        setSpeed: setSpeed,
                        iconColor: widget.iconColor,
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
