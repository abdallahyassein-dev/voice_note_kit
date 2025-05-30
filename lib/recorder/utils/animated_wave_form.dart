import 'dart:math';
import 'package:flutter/material.dart';

/// A waveform animation widget that visualizes audio input.
///
/// This widget displays animated vertical bars that vary in height
/// to simulate audio recording visualization.
class AnimatedWaveform extends StatefulWidget {
  /// Whether the waveform is in recording mode.
  final bool isRecording;

  /// The number of bars displayed in the waveform.
  final int barCount;

  /// The maximum height of each bar.
  final double maxBarHeight;

  /// The speed of the bar height animation.
  final Duration speed;

  /// The color of the bars when recording is active.
  final Color? recordingColor;

  /// The color of the bars when idle.
  final Color? idleColor;

  /// Creates an [AnimatedWaveform] widget.
  ///
  /// - [isRecording] controls whether animation is active.
  /// - [barCount] sets how many bars are shown.
  /// - [maxBarHeight] defines the tallest possible bar.
  /// - [speed] determines how fast the bars animate.
  /// - [recordingColor] and [idleColor] control color states.
  const AnimatedWaveform({
    super.key,
    required this.isRecording,
    this.barCount = 20,
    this.maxBarHeight = 40,
    this.speed = const Duration(seconds: 2),
    this.recordingColor = Colors.blueAccent,
    this.idleColor = Colors.grey,
  });

  @override
  State<AnimatedWaveform> createState() => _AnimatedWaveformState();
}

class _AnimatedWaveformState extends State<AnimatedWaveform>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _barAnimations;
  final Random _random = Random();
  late List<double> _targetHeights;

  @override
  void initState() {
    super.initState();
    _targetHeights = List<double>.filled(widget.barCount, 0.0);
    _controllers = List.generate(widget.barCount, (_) {
      return AnimationController(
        vsync: this,
        duration: widget.speed,
      );
    });

    _barAnimations = List.generate(widget.barCount, (index) {
      return Tween<double>(begin: 2.0, end: 2.0).animate(
        CurvedAnimation(parent: _controllers[index], curve: Curves.easeInOut),
      );
    });

    if (widget.isRecording) _startWaveLoop();
  }

  void _startWaveLoop() {
    Future.doWhile(() async {
      if (!mounted || !widget.isRecording) return false;

      _animateNewHeights();
      await Future.delayed(widget.speed);
      return true;
    });
  }

  void _animateNewHeights() {
    for (int i = 0; i < widget.barCount; i++) {
      final newHeight = _random.nextDouble() * widget.maxBarHeight;
      _targetHeights[i] = newHeight;

      _controllers[i].stop();
      _barAnimations[i] = Tween<double>(
        begin: _barAnimations[i].value,
        end: newHeight,
      ).animate(
        CurvedAnimation(parent: _controllers[i], curve: Curves.easeInOut),
      );
      _controllers[i].forward(from: 0);
    }

    setState(() {});
  }

  @override
  void didUpdateWidget(covariant AnimatedWaveform oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isRecording && !_controllers.first.isAnimating) {
      _startWaveLoop();
    }

    if (oldWidget.speed != widget.speed) {
      for (var controller in _controllers) {
        controller.duration = widget.speed;
      }
    }

    if (!widget.isRecording) {
      for (int i = 0; i < widget.barCount; i++) {
        _controllers[i].stop();
        _barAnimations[i] = Tween<double>(
          begin: _barAnimations[i].value,
          end: 2.0,
        ).animate(
          CurvedAnimation(parent: _controllers[i], curve: Curves.easeOut),
        );
        _controllers[i].forward(from: 0);
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final barColor =
        widget.isRecording ? widget.recordingColor : widget.idleColor;

    return SizedBox(
      height: widget.maxBarHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          final barWidth = totalWidth / (widget.barCount * 1.5);

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(widget.barCount, (index) {
              return AnimatedBuilder(
                animation: _barAnimations[index],
                builder: (_, __) {
                  return Container(
                    width: barWidth,
                    height: _barAnimations[index].value,
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                },
              );
            }),
          );
        },
      ),
    );
  }
}
