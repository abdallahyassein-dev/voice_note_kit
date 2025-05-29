import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import 'package:voice_note_kit/recorder/styles/voice_classic_style.dart';
import 'package:voice_note_kit/recorder/styles/voice_compact_style.dart';
import 'package:voice_note_kit/recorder/utils/utils_for_mobile.dart';
import 'package:voice_note_kit/recorder/utils/utils_for_web.dart';
import 'audio_recorder.dart';
import 'sound_player.dart';
import 'voice_enums/voice_enums.dart';

// Main widget for voice recording functionality
class VoiceRecorderWidget extends StatefulWidget {
  // Callbacks and customizable widgets for the voice recorder widget
  final Function(File file)? onRecorded;
  final Function(String url)? onRecordedWeb;
  final Function(String error)? onError;
  final Function()? onStartRecording;
  final Function()? actionWhenCancel;
  final Function()? onMaxDurationReached;

  // Widgets to customize start and stop recording icons
  final Widget? startRecordingWidget;
  final Widget? stopRecordingWidget;

  // Texts and style options for UI elements
  final String permissionNotGrantedMessage;
  final String recordCancelledMessage;
  final String cancelDoneText;
  final String dragToLeftText;

  final double iconSize;
  final TextStyle? timerTextStyle;
  final TextStyle? dragToLeftTextStyle;

  final double timerFontSize;
  final Color backgroundColor;
  final Color cancelHintColor;
  final Color iconColor;

  final bool showSwipeLeftToCancel;
  final bool showTimerText;

  final bool enableHapticFeedback;

  final Duration? maxRecordDuration;

  // Optionally provided sound assets for starting and stopping recording
  final String? startSoundAsset;
  final String? stopSoundAsset;

  // optional to style show voice record
  final VoiceUIStyle? style;
  final Color? containerColor;      // New: optional background color
  final Color? borderColor;         // New: optional border color
  final Color? idleWavesColor ;
  final Color? recordingWavesColor ;
  final double? borderRadius;
  final Duration? wavesSpeed;        // New: optional border color

  const VoiceRecorderWidget({
    super.key,
    this.onRecorded,
    this.onRecordedWeb,
    this.onError,
    this.onStartRecording,
    this.actionWhenCancel,
    this.onMaxDurationReached,
    this.startRecordingWidget,
    this.stopRecordingWidget,
    this.maxRecordDuration,
    this.timerFontSize = 16,
    this.showSwipeLeftToCancel = true,
    this.showTimerText = true,
    this.enableHapticFeedback = true,
    this.backgroundColor = Colors.blueAccent,
    this.cancelHintColor = Colors.redAccent,
    this.iconColor = Colors.white,
    this.timerTextStyle,
    this.dragToLeftTextStyle,
    this.cancelDoneText = 'Cancel Done',
    this.permissionNotGrantedMessage = 'Permission not granted',
    this.recordCancelledMessage = 'Record cancelled',
    this.dragToLeftText = '← Drag to left to cancel',
    this.iconSize = 56,
    this.startSoundAsset,
    this.stopSoundAsset,
    this.style = VoiceUIStyle.classic,
    this.containerColor,
    this.borderColor,
    this.borderRadius ,
    this.idleWavesColor = Colors.grey ,
    this.recordingWavesColor = Colors.blueAccent ,
    this.wavesSpeed ,
  }): assert(
        style == VoiceUIStyle.compact ||
            (containerColor == null && borderColor == null && borderRadius == null && idleWavesColor == null && recordingWavesColor == null && wavesSpeed == null),
        'Container styling ('
            'container Color / '
            'border Color / '
            'border Radius /'
            'idle waves color /'
            'recording waves color /'
            'waves speed /'
            ') can only be used with VoiceUIStyle.compact',
        );

  @override
  State<VoiceRecorderWidget> createState() => _VoiceRecorderWidgetState();
}

class _VoiceRecorderWidgetState extends State<VoiceRecorderWidget> {
  final _recorder = AudioRecorderClass(); // Audio recorder instance
  bool _isRecording = false; // Whether the recorder is currently recording
  bool _isCancelled = false; // Whether the recording was cancelled
  String? _filePath; // File path for saving the recording
  double dragDistance = 0.0; // Distance the user drags to cancel
  Offset? _startOffset; // Start position of the drag gesture
  Timer? _timer; // Timer to track recording duration
  int _seconds = 0; // Recording duration in seconds
  Color _backgroundColor =
      Colors.blueAccent; // Background color during recording
  bool _showCancelHint = false; // Flag to show hint for cancelling recording

  // Dispose resources when the widget is destroyed
  @override
  void dispose() {
    _recorder.dispose(); // Dispose recorder
    _timer?.cancel(); // Cancel timer
    super.dispose();
  }

  // Start recording logic
  Future<void> _startRecording() async {
    try {
      final hasPermission =
          await _checkPermissions(); // Check microphone permission
      if (!hasPermission) {
        widget.onError!(widget
            .permissionNotGrantedMessage); // Show error if permission not granted
        return;
      }

      widget.onStartRecording?.call(); // Trigger callback for start recording

      if (widget.enableHapticFeedback) {
        HapticFeedback
            .mediumImpact(); // Trigger haptic feedback when recording starts
      }

      if (kIsWeb) {
        // Web-specific behavior: start recording without specifying path
        _filePath = getTempFileForWeb();
        await _recorder.start(const RecordConfig(), path: _filePath!);
      } else {
        // Mobile: save to file using path_provider

        _filePath = await getTempFilePath();
        await _recorder.start(const RecordConfig(), path: _filePath!);
      }

      // Play sound if provided when recording starts
      if (widget.startSoundAsset != null) {
        _playAssetSound(widget.startSoundAsset!);
      }

      // Start recording
      await _recorder.start(const RecordConfig(), path: _filePath!);
      _startTimer(); // Start the recording timer

      setState(() {
        _isRecording = true; // Update UI to show recording state
        _isCancelled = false;
        dragDistance = 0;
        _backgroundColor =
            widget.cancelHintColor; // Change background color when recording
        _showCancelHint = true; // Show cancel hint
      });
    } catch (e) {
      widget.onError?.call(e.toString()); // Handle errors
    }
  }

  // Stop recording logic
  Future<void> _stopRecording() async {
    try {
      _timer?.cancel(); // Stop the timer when recording is stopped

      // Play sound if provided when recording stops
      if (widget.stopSoundAsset != null) {
        _playAssetSound(widget.stopSoundAsset!);
      }

      // Stop the recorder
      String filePath = await _recorder.stop();

      setState(() {
        _isRecording = false; // Update UI to show recording stopped
      });

      // Trigger onRecorded callback with the saved file if recording is successful
      if (!_isCancelled &&
          _filePath != null &&
          widget.onRecorded != null &&
          kIsWeb) {
        widget.onRecordedWeb!(filePath);
      } else if (!_isCancelled &&
          _filePath != null &&
          widget.onRecorded != null) {
        widget.onRecorded!(File(_filePath!));
      }
    } catch (e) {
      widget.onError?.call(e.toString()); // Handle errors
    }
  }

  // Cancel the recording logic
  void _cancelRecording() {
    try {
      _isCancelled = true; // Mark the recording as cancelled
      _timer?.cancel(); // Stop the timer
      _recorder.stop(); // Stop the recorder
      if (widget.enableHapticFeedback) {
        HapticFeedback.mediumImpact(); // Trigger haptic feedback on cancel
      }
      setState(() {
        _isRecording = false; // Update UI to show recording is cancelled
        _backgroundColor = widget.backgroundColor; // Reset background color
        _showCancelHint = false; // Hide cancel hint
      });
      if (widget.actionWhenCancel != null) {
        widget
            .actionWhenCancel!(); // Trigger custom action when recording is cancelled
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  widget.recordCancelledMessage)), // Show cancellation message
        );
      }
    } catch (e) {
      widget.onError?.call(e.toString()); // Handle errors
    }
  }

  // Start the timer for the recording duration
  void _startTimer() {
    _seconds = 0; // Reset timer to 0
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _seconds++); // Increment timer every second
      // Stop recording if max duration is reached
      if (widget.maxRecordDuration != null &&
          _seconds >= widget.maxRecordDuration!.inSeconds) {
        _stopRecording();
        widget.onMaxDurationReached
            ?.call(); // Trigger callback when max duration is reached
      }
    });
  }

  // Check for microphone permission
  Future<bool> _checkPermissions() async {
    if (Platform.isMacOS) {
      return true;
    }
    final mic = await Permission.microphone.request();
    return mic ==
        PermissionStatus.granted; // Return true if permission is granted
  }

  // Play the sound asset (e.g., when starting or stopping recording)
  Future<void> _playAssetSound(String assetPath) async {
    try {
      await playSound(assetPath); // Play the sound
    } catch (e) {
      widget.onError?.call(e.toString()); // Handle errors
    }
  }

  // Build the UI for the voice recorder widget
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Start recording when long press starts
      onLongPressStart: (details) {
        _startOffset = details.globalPosition;
        _startRecording();
        setState(() {
          _showCancelHint = true; // Show the cancel hint
        });
      },
      // Update drag distance and cancel recording if dragged far enough
      onLongPressMoveUpdate: (details) {
        if (widget.showSwipeLeftToCancel &&
            _isRecording &&
            _startOffset != null) {
          double distance = details.globalPosition.dx - _startOffset!.dx;

          setState(() {
            dragDistance = distance; // Update drag distance
            double percent = (distance.abs() / 100)
                .clamp(0, 1); // Calculate cancellation percentage
            _backgroundColor = Color.lerp(
                widget.cancelHintColor,
                widget.backgroundColor,
                1 - percent)!; // Update background color
          });

          // Cancel recording if dragged far enough
          // make cancel by remove right (>100) or left (< -70)
          if ((distance < -70 ||distance > 100 ) && !_isCancelled) {
            _cancelRecording();
          }
        }
      },
      // Stop recording if long press ends
      onLongPressEnd: (_) {
        if (!_isCancelled) {
          _stopRecording();
        }
        setState(() {
          _showCancelHint = false; // Hide the cancel hint
          _backgroundColor = widget.backgroundColor; // Reset background color
        });
      },
      child : widget.style == VoiceUIStyle.classic
     ? VoiceClassicStyle(
          isRecording: _isRecording,
          showCancelHint: _showCancelHint,
          showSwipeLeftToCancel: widget.showSwipeLeftToCancel,
          dragToLeftText: widget.dragToLeftText,
          dragToLeftTextStyle : widget.dragToLeftTextStyle ,
          showTimerText: widget.showTimerText,
          isCancelled: _isCancelled,
          cancelDoneText: widget.cancelDoneText,
          timerTextStyle : widget.timerTextStyle ,
          iconSize: widget.iconSize,
        seconds: _seconds,
        cancelHintColor: widget.cancelHintColor,
        timerFontSize: widget.timerFontSize,
        backgroundColorSecond: widget.backgroundColor,
        backgroundColorFirst: _backgroundColor,
        stopRecordingWidget: widget.stopRecordingWidget,
        startRecordingWidget: widget.startRecordingWidget,
        iconColor: widget.iconColor ,
      ) :
      VoiceCompactStyle(
        isRecording: _isRecording,
        showCancelHint: _showCancelHint,
        showSwipeLeftToCancel: widget.showSwipeLeftToCancel,
        dragToLeftText: widget.dragToLeftText,
        dragToLeftTextStyle : widget.dragToLeftTextStyle ,
        showTimerText: widget.showTimerText,
        isCancelled: _isCancelled,
        cancelDoneText: widget.cancelDoneText,
        timerTextStyle : widget.timerTextStyle ,
        iconSize: widget.iconSize,
        seconds: _seconds,
        cancelHintColor: widget.cancelHintColor,
        timerFontSize: widget.timerFontSize,
        backgroundColorSecond: widget.backgroundColor,
        backgroundColorFirst: _backgroundColor,
        stopRecordingWidget: widget.stopRecordingWidget,
        startRecordingWidget: widget.startRecordingWidget,
        iconColor: widget.iconColor,
        containerColor: widget.containerColor,
        borderColor: widget.borderColor ,
        borderRadius: widget.borderRadius,
        idleWavesColor: widget.idleWavesColor,
        recordingWavesColor: widget.recordingWavesColor,
        speed: widget.wavesSpeed ?? const Duration(milliseconds: 300),
      ) ,
    );
  }
}
