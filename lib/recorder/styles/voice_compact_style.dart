import 'package:flutter/material.dart';

import '../../player/utils/format_duration.dart';

class VoiceCompactStyle extends StatelessWidget {
  const VoiceCompactStyle({super.key,
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
    required this.borderRadius
  });

  final bool isRecording ;
  final bool showCancelHint ;
  final bool showSwipeLeftToCancel ;
  final String dragToLeftText ;
  final TextStyle? dragToLeftTextStyle;
  final bool showTimerText;
  final bool isCancelled ;
  final String cancelDoneText;
  final TextStyle? timerTextStyle;
  final int seconds;
  final Color cancelHintColor;
  final double timerFontSize;
  final double iconSize;
  final Color backgroundColorSecond;
  final Color  backgroundColorFirst ;
  final Widget? stopRecordingWidget ;
  final Widget? startRecordingWidget ;
  final Color iconColor ;
  final Color? containerColor;
  final Color? borderColor ;
  final double? borderRadius;
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
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  color: isRecording
                      ? backgroundColorFirst
                      : backgroundColorSecond, // Change background color based on recording state
                  shape: BoxShape.circle, // Make the button circular
                  boxShadow: isRecording
                      ? [
                    BoxShadow(
                        color: cancelHintColor
                            .withAlpha((0.4 * 255).round()),
                        blurRadius: 8) // Add shadow when recording
                  ]
                      : [],
                ),
                // Show custom widgets for start/stop recording or default icon
                child: isRecording && stopRecordingWidget != null
                    ?stopRecordingWidget
                    : !isRecording && startRecordingWidget != null
                    ? startRecordingWidget
                    : Icon(
                  isRecording ? Icons.stop : Icons.mic_none,
                  color: iconColor,
                  size: iconSize / 2.3,
                ),
              ),
              if ( showTimerText)
                Text(
                  isRecording ?
                  isCancelled
                      ? cancelDoneText
                      : formatDurationSeconds(
                      seconds)  :   '00.00', // Format the recording duration
                  style: timerTextStyle ??
                      TextStyle(
                        color:cancelHintColor,
                        fontSize: timerFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8,) ,
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
