// whatsapp_player_style.dart

import 'package:flutter/material.dart';
import 'package:voice_note_kit/player/audio_player_widget.dart';
import 'package:voice_note_kit/player/player_enums/player_enums.dart';
import 'package:voice_note_kit/player/utils/format_duration.dart';
import 'package:voice_note_kit/player/widgets/custom_speed_button.dart';
import 'package:voice_note_kit/player/widgets/wave_slider.dart';

/// A widget that represents the fifth player style.
class StyleFiveWidget extends StatelessWidget {
  /// Constructor for the StyleFiveWidget
  final AudioPlayerWidget widget;

  /// is playing or not
  final bool isPlaying;

  /// progress
  final double progress;

  /// position
  final Duration position;

  /// duration
  final Duration duration;

  /// show progress bar
  final bool showProgressBar;

  /// show timer
  final bool showTimer;

  /// play audio
  final Function playAudio;

  /// pause audio
  final Function pauseAudio;

  /// seek to
  final Function(double) seekTo;

  /// waveform
  final List<double> waveformData;

  /// size

  final bool showSpeedControl; // New property
  /// background color
  final List<double> playbackSpeeds; // New property
  /// current speed
  final double currentSpeed;

  /// size

  final Function(double) setSpeed;

  /// Constructor for the [StyleFiveWidget]

  const StyleFiveWidget({
    super.key,
    required this.widget,
    required this.isPlaying,
    required this.progress,
    required this.position,
    required this.duration,
    required this.showProgressBar,
    required this.showTimer,
    required this.playAudio,
    required this.pauseAudio,
    required this.seekTo,
    required this.showSpeedControl,
    required this.playbackSpeeds,
    required this.currentSpeed,
    required this.setSpeed,
    required this.waveformData,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.textDirection,
      child: Container(
        width: widget.width,
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                if (isPlaying) {
                  pauseAudio();
                } else {
                  playAudio();
                }
              },
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: widget.shapeType == PlayIconShapeType.circular
                      ? BoxShape.circle
                      : widget.shapeType == PlayIconShapeType.roundedRectangle
                          ? BoxShape.rectangle
                          : BoxShape.rectangle,
                  borderRadius:
                      widget.shapeType == PlayIconShapeType.roundedRectangle
                          ? BorderRadius.circular(8.0)
                          : null,
                  color: widget.iconColor.withAlpha((0.2 * 255).round()),
                ),
                child: RotatedBox(
                  quarterTurns:
                      widget.textDirection == TextDirection.ltr ? 0 : 2,
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: widget.iconColor,
                    size: widget.size * 0.6,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showTimer)
                    Text(
                      formatDuration(position),
                      style: widget.timerTextStyle ??
                          TextStyle(
                            color: widget.iconColor,
                            fontSize: 14,
                          ),
                    ),
                  if (showProgressBar)
                    WaveformSlider(
                      waveform: waveformData,
                      textDirection: widget.textDirection,
                      progress: progress,
                      inactiveColor: widget.progressBarBackgroundColor
                          .withAlpha((0.1 * 255).round()),
                      activeColor: widget.progressBarBackgroundColor,
                      onSeek: seekTo,
                    ),
                ],
              ),
            ),
            if (showTimer) ...[
              const SizedBox(width: 8.0),
              Text(
                formatDuration(duration),
                style: widget.timerTextStyle ??
                    TextStyle(
                      color: widget.iconColor,
                      fontSize: 14,
                    ),
              ),
            ],
            if (showSpeedControl) ...[
              const SizedBox(width: 8.0),
              SpeedButton(
                currentSpeed: currentSpeed,
                playbackSpeeds: playbackSpeeds,
                setSpeed: setSpeed,
                iconColor: widget.iconColor,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
