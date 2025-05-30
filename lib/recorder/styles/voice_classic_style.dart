import 'package:flutter/material.dart';
import '../../player/utils/format_duration.dart';

/// A classic style voice recording widget that provides:
/// 1. A circular recording button with animated state changes.
/// 2. Optional swipe-to-cancel hint text.
/// 3. Optional timer display or cancellation message.
///
/// Example usage:
/// ```dart
/// VoiceClassicStyle(
///   isRecording: true,
///   showCancelHint: true,
///   showSwipeLeftToCancel: true,
///   dragToLeftText: 'Swipe left to cancel',
///   showTimerText: true,
///   isCancelled: false,
///   cancelDoneText: 'Cancelled',
///   seconds: 10,
///   cancelHintColor: Colors.red,
///   timerFontSize: 16.0,
///   iconSize: 60.0,
///   backgroundColorSecond: Colors.grey.shade300,
///   backgroundColorFirst: Colors.red.shade400,
///   stopRecordingWidget: Icon(Icons.stop, color: Colors.white),
///   startRecordingWidget: Icon(Icons.mic, color: Colors.white),
///   iconColor: Colors.white,
/// )
/// ```
class VoiceClassicStyle extends StatelessWidget {
  /// Creates a [VoiceClassicStyle] widget.
  ///
  /// All parameters are required to ensure full customization.
  const VoiceClassicStyle({
    super.key,

    /// Whether recording is currently active.
    required this.isRecording,

    /// Whether to show the "swipe to cancel" hint text.
    required this.showCancelHint,

    /// Whether the user can swipe left to cancel.
    required this.showSwipeLeftToCancel,

    /// The hint text prompting the user to drag left.
    required this.dragToLeftText,

    /// Optional style for the drag hint text.
    required this.dragToLeftTextStyle,

    /// Whether to display the elapsed recording time.
    required this.showTimerText,

    /// Whether recording has been cancelled.
    required this.isCancelled,

    /// Text to display when recording is cancelled.
    required this.cancelDoneText,

    /// Optional text style for timer or cancel message.
    required this.timerTextStyle,

    /// The elapsed recording time in seconds.
    required this.seconds,

    /// Color for the cancel hint and shadow effect.
    required this.cancelHintColor,

    /// Font size for the timer text.
    required this.timerFontSize,

    /// Diameter of the recording button.
    required this.iconSize,

    /// Background color when not recording.
    required this.backgroundColorSecond,

    /// Background color when recording.
    required this.backgroundColorFirst,

    /// Optional widget to display when stopping recording.
    required this.stopRecordingWidget,

    /// Optional widget to display when starting recording.
    required this.startRecordingWidget,

    /// Color for the default mic/stop icon.
    required this.iconColor,
  });

  /// Flag indicating active recording state.
  final bool isRecording;

  /// Whether to show cancel hint text.
  final bool showCancelHint;

  /// Controls swipe-to-cancel functionality.
  final bool showSwipeLeftToCancel;

  /// Hint text shown when swipe-to-cancel is enabled.
  final String dragToLeftText;

  /// Optional style for the drag hint text.
  final TextStyle? dragToLeftTextStyle;

  /// Whether to display the timer text.
  final bool showTimerText;

  /// If true, displays [cancelDoneText] instead of timer.
  final bool isCancelled;

  /// Text shown when recording is cancelled.
  final String cancelDoneText;

  /// Optional style for timer or cancel text.
  final TextStyle? timerTextStyle;

  /// Elapsed recording duration in seconds.
  final int seconds;

  /// Color used for cancel hint and shadow.
  final Color cancelHintColor;

  /// Font size for the timer text.
  final double timerFontSize;

  /// Diameter of the recording button.
  final double iconSize;

  /// Background color when not recording.
  final Color backgroundColorSecond;

  /// Background color when recording.
  final Color backgroundColorFirst;

  /// Custom widget for stop recording state.
  final Widget? stopRecordingWidget;

  /// Custom widget for start recording state.
  final Widget? startRecordingWidget;

  /// Color of the default mic/stop icon.
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Show cancel hint text when recording and swipe left to cancel
        if (isRecording && showCancelHint && showSwipeLeftToCancel)
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              dragToLeftText,
              style: dragToLeftTextStyle ??
                  const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),

        // Show timer text when recording
        if (isRecording && showTimerText)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              isCancelled ? cancelDoneText : formatDurationSeconds(seconds),
              style: timerTextStyle ??
                  TextStyle(
                    color: cancelHintColor,
                    fontSize: timerFontSize,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),

        // Animated container for the recording button
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: iconSize,
          height: iconSize,
          decoration: BoxDecoration(
            color: isRecording ? backgroundColorFirst : backgroundColorSecond,
            shape: BoxShape.circle,
            boxShadow: isRecording
                ? [
                    BoxShadow(
                      color: cancelHintColor.withAlpha((0.4 * 255).round()),
                      blurRadius: 8,
                    ),
                  ]
                : [],
          ),
          // Show custom widgets for start/stop recording or default icon
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
      ],
    );
  }
}
