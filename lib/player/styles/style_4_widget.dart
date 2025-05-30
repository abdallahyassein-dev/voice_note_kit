// style_5_widget.dart
import 'package:flutter/material.dart';
import 'package:voice_note_kit/player/audio_player_widget.dart';
import 'package:voice_note_kit/player/utils/format_duration.dart';
import 'package:voice_note_kit/player/widgets/custom_slider.dart';
import 'package:voice_note_kit/player/widgets/custom_speed_button.dart';

/// A widget that represents the fourth player style.
class StyleFourWidget extends StatelessWidget {
  /// Constructor for the StyleFourWidget.
  final AudioPlayerWidget widget;

  /// The current state of the audio player.
  final bool isPlaying;

  /// The progress of the audio player.
  final double progress;

  /// The current position of the audio player.
  final Duration position;

  /// The duration of the audio player.
  final Duration duration;

  /// The callback function to play the audio.
  final Function playAudio;

  /// The callback function to pause the audio.
  final Function pauseAudio;

  /// The callback function to seek to a specific position in the audio.
  final Function(double) seekTo;

  /// Whether to show the speed control.
  final bool showSpeedControl;

  /// The available playback speeds.
  final List<double> playbackSpeeds;

  /// The current playback speed.
  final double currentSpeed;

  /// The callback function to set the playback speed.
  final Function(double) setSpeed;

  /// Constructor for the [StyleFourWidget].
  const StyleFourWidget({
    super.key,
    required this.widget,
    required this.isPlaying,
    required this.progress,
    required this.position,
    required this.duration,
    required this.playAudio,
    required this.pauseAudio,
    required this.seekTo,
    required this.showSpeedControl,
    required this.playbackSpeeds,
    required this.currentSpeed,
    required this.setSpeed,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.textDirection,
      child: Container(
        width: widget.width,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // Top Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPlayPauseButton(),
                if (widget.showTimer) _buildTimerText(),
                if (showSpeedControl)
                  SpeedButton(
                    currentSpeed: currentSpeed,
                    playbackSpeeds: playbackSpeeds,
                    setSpeed: setSpeed,
                    iconColor: widget.iconColor,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // Custom Slider
            if (widget.showProgressBar)
              CustomSlider(
                progress: progress,
                progressBarColor: widget.progressBarColor,
                progressBarBackgroundColor: widget.progressBarBackgroundColor,
                seekTo: seekTo,
              ),
            if (widget.showTimer)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [_buildDurationText()],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayPauseButton() {
    return RotatedBox(
      quarterTurns: widget.textDirection == TextDirection.ltr ? 0 : 2,
      child: IconButton(
        icon: Icon(
          isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          size: widget.size,
          color: widget.iconColor,
        ),
        onPressed: () {
          if (isPlaying) {
            pauseAudio();
          } else {
            playAudio();
          }
        },
      ),
    );
  }

  Widget _buildTimerText() {
    return Text(
      formatDuration(position),
      style: widget.timerTextStyle ??
          TextStyle(color: widget.iconColor, fontSize: 16),
    );
  }

  Widget _buildDurationText() {
    return Text(
      formatDuration(duration),
      style: widget.timerTextStyle ??
          TextStyle(
              color: widget.iconColor.withAlpha((0.7 * 255).round()),
              fontSize: 14),
    );
  }
}
