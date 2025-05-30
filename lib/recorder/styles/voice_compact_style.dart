import 'package:flutter/material.dart';

import '../../player/utils/format_duration.dart';
import '../utils/animated_wave_form.dart';

/// A compact voice recording widget that shows a record/stop button,
/// animated waveform, timer, and optional cancel hints.
///
/// This widget is highly customizable and is intended to be used in
/// voice recording features.
///
/// Example usage:
/// ```dart
/// VoiceCompactStyle(
///   isRecording: true,
///   showCancelHint: true,
///   showSwipeLeftToCancel: true,
///   dragToLeftText: 'Swipe left to cancel',
///   dragToLeftTextStyle: TextStyle(color: Colors.red),
///   showTimerText: true,
///   isCancelled: false,
///   cancelDoneText: 'Cancelled',
///   timerTextStyle: TextStyle(color: Colors.white),
///   seconds: 30,
///   cancelHintColor: Colors.red,
///   timerFontSize: 14,
///   iconSize: 50,
///   backgroundColorSecond: Colors.grey,
///   backgroundColorFirst: Colors.red,
///   stopRecordingWidget: Icon(Icons.stop),
///   startRecordingWidget: Icon(Icons.mic),
///   iconColor: Colors.white,
///   containerColor: Colors.black12,
///   borderColor: Colors.grey,
///   borderRadius: 12,
///   idleWavesColor: Colors.grey,
///   recordingWavesColor: Colors.red,
///   speed: Duration(milliseconds: 200),
/// )
/// ```
class VoiceCompactStyle extends StatelessWidget {
  /// Creates a [VoiceCompactStyle] widget.
  const VoiceCompactStyle({
    super.key,
    required this.isRecording,
    required this.showCancelHint,
    required this.showSwipeLeftToCancel,
    required this.dragToLeftText,
    required this.dragToLeftTextStyle,
    required this.showTimerText,
    required this.isCancelled,
    required this.cancelDoneText,
    required this.timerTextStyle,
    required this.seconds,
    required this.cancelHintColor,
    required this.timerFontSize,
    required this.iconSize,
    required this.backgroundColorSecond,
    required this.backgroundColorFirst,
    required this.stopRecordingWidget,
    required this.startRecordingWidget,
    required this.iconColor,
    required this.containerColor,
    required this.borderColor,
    required this.borderRadius,
    required this.idleWavesColor,
    required this.recordingWavesColor,
    required this.speed,
  });

  /// Whether recording is in progress.
  final bool isRecording;

  /// Whether to show the cancel hint below the UI.
  final bool showCancelHint;

  /// Whether to show the "swipe left to cancel" instruction.
  final bool showSwipeLeftToCancel;

  /// Text to show for the swipe left to cancel hint.
  final String dragToLeftText;

  /// Custom style for [dragToLeftText].
  final TextStyle? dragToLeftTextStyle;

  /// Whether to show the recording timer.
  final bool showTimerText;

  /// Indicates if the recording was cancelled.
  final bool isCancelled;

  /// Text to show if recording was cancelled.
  final String cancelDoneText;

  /// Custom text style for the timer.
  final TextStyle? timerTextStyle;

  /// The number of seconds recorded.
  final int seconds;

  /// Color used for the cancel hint and timer.
  final Color cancelHintColor;

  /// Font size for the timer.
  final double timerFontSize;

  /// Size of the recording icon button.
  final double iconSize;

  /// Background color when not recording.
  final Color backgroundColorSecond;

  /// Background color when recording.
  final Color backgroundColorFirst;

  /// Custom widget to show when recording (e.g., a stop button).
  final Widget? stopRecordingWidget;

  /// Custom widget to show when not recording (e.g., a mic icon).
  final Widget? startRecordingWidget;

  /// Icon color for the mic/stop icon.
  final Color iconColor;

  /// Background color of the container.
  final Color? containerColor;

  /// Border color of the container.
  final Color? borderColor;

  /// Color of the waveform bars when idle.
  final Color? idleWavesColor;

  /// Color of the waveform bars when recording.
  final Color? recordingWavesColor;

  /// Radius of the container's border.
  final double? borderRadius;

  /// Speed of waveform animation.
  final Duration? speed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 8,
          ),
          decoration: BoxDecoration(
            color: containerColor ?? Colors.transparent,
            border: Border.all(
              color: borderColor ?? Colors.grey[200]!,
            ),
            borderRadius: BorderRadius.circular(borderRadius ?? 10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Recording button
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  color: isRecording
                      ? backgroundColorFirst
                      : backgroundColorSecond,
                  shape: BoxShape.circle,
                  boxShadow: isRecording
                      ? [
                          BoxShadow(
                            color:
                                cancelHintColor.withAlpha((0.4 * 255).round()),
                            blurRadius: 8,
                          )
                        ]
                      : [],
                ),
                child: isRecording && stopRecordingWidget != null
                    ? stopRecordingWidget
                    : !isRecording && startRecordingWidget != null
                        ? startRecordingWidget
                        : Icon(
                            isRecording ? Icons.stop : Icons.mic_none,
                            color: iconColor,
                            size: iconSize / 2.3,
                          ),
              ),
              const SizedBox(width: 8),
              // Animated waveform
              Expanded(
                child: AnimatedWaveform(
                  isRecording: isRecording,
                  barCount: 30,
                  maxBarHeight: 40,
                  idleColor: idleWavesColor,
                  recordingColor: recordingWavesColor,
                  speed: speed!,
                ),
              ),
              const SizedBox(width: 8),
              // Timer text
              if (showTimerText)
                Text(
                  isRecording
                      ? (isCancelled
                          ? cancelDoneText
                          : formatDurationSeconds(seconds))
                      : '00.00',
                  style: timerTextStyle ??
                      TextStyle(
                        color: cancelHintColor,
                        fontSize: timerFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Swipe left to cancel hint
        if (isRecording && showCancelHint && showSwipeLeftToCancel)
          Text(
            dragToLeftText,
            style: dragToLeftTextStyle ??
                const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
          ),
      ],
    );
  }
}
