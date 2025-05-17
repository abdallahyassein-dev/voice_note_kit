import 'package:flutter/material.dart';

/// A custom waveform slider that visualizes a waveform and allows seeking through it by tapping or dragging.
/// The slider is represented as a series of bars, and the user can interact with it to update the progress.
class WaveformSlider extends StatelessWidget {
  final List<double>
      waveform; // A list representing waveform heights, usually between 0.0 and 1.0
  final double progress; // Current progress value from 0.0 to 1.0
  final Color
      activeColor; // Color for the active (progressed) part of the waveform
  final Color
      inactiveColor; // Color for the inactive (unprogressed) part of the waveform
  final Function(double)
      onSeek; // Callback to handle the seeking action (updating the progress)
  final TextDirection
      textDirection; // Text direction, needed for RTL layout handling

  const WaveformSlider({
    super.key,
    required this.waveform,
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
    required this.onSeek,
    this.textDirection =
        TextDirection.ltr, // Default text direction is Left-to-Right
  });

  // Handle seeking when tapping or dragging on the slider.
  void _handleSeek(BuildContext context, Offset globalPosition) {
    final box = context.findRenderObject() as RenderBox;
    final localPosition = box.globalToLocal(
        globalPosition); // Convert global position to local position
    final width = box.size.width; // Get the width of the slider

    double newProgress = localPosition.dx.clamp(0.0, width) /
        width; // Normalize the position to a progress value

    // Reverse progress for RTL layout (right-to-left)
    if (textDirection == TextDirection.rtl) {
      newProgress = 1.0 - newProgress;
    }

    // Update the progress using the provided callback
    onSeek(newProgress);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior
          .opaque, // Allow touch events even if no UI is directly beneath
      // Call _handleSeek when the user taps or drags on the slider
      onTapDown: (details) => _handleSeek(context, details.globalPosition),
      onHorizontalDragStart: (details) =>
          _handleSeek(context, details.globalPosition),
      onHorizontalDragUpdate: (details) =>
          _handleSeek(context, details.globalPosition),
      child: CustomPaint(
        size: const Size(
            double.infinity, 40), // Fixed height for the waveform slider
        painter: _WaveformPainter(
          waveform: waveform, // Pass the waveform data
          progress: progress, // Pass the current progress
          activeColor: activeColor, // Pass the active color
          inactiveColor: inactiveColor, // Pass the inactive color
          isRtl: textDirection ==
              TextDirection.rtl, // Pass whether it's RTL or not
        ),
      ),
    );
  }
}

/// Custom painter that draws the waveform bars based on the given waveform data.
/// It will also draw a progress indicator by coloring the bars based on the current progress.
class _WaveformPainter extends CustomPainter {
  final List<double> waveform; // The waveform data
  final double progress; // Current progress (0.0 to 1.0)
  final Color activeColor; // Color for active bars (progressed portion)
  final Color inactiveColor; // Color for inactive bars (unprogressed portion)
  final bool isRtl; // Flag indicating whether the layout is RTL (Right-to-Left)

  _WaveformPainter({
    required this.waveform,
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
    required this.isRtl,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..isAntiAlias = true // Enable anti-aliasing for smoother edges
      ..strokeCap = StrokeCap.butt; // No rounded edges for the bars

    const barSpacing = 1.0; // Space between bars
    const barWidth = 2.0; // Width of each bar
    final totalBars = (size.width / (barWidth + barSpacing))
        .floor(); // Calculate how many bars fit in the available width

    // Draw each bar in the waveform
    for (int i = 0; i < totalBars; i++) {
      final index = (i / totalBars * waveform.length)
          .floor(); // Map the index to the waveform array
      final heightFactor = waveform[index.clamp(
          0, waveform.length - 1)]; // Get the height factor for this bar
      final barHeight =
          heightFactor * size.height; // Calculate the height of the bar

      final x =
          i * (barWidth + barSpacing); // Calculate the X position of the bar
      final effectiveX = isRtl ? size.width - x : x; // Adjust X for RTL layout

      // Normalize the X position to a progress value between 0.0 and 1.0
      final normalizedProgressX =
          isRtl ? (1.0 - (effectiveX / size.width)) : (effectiveX / size.width);

      // Set the color of the bar based on the progress
      paint.color =
          normalizedProgressX <= progress ? activeColor : inactiveColor;

      // Draw the bar at the calculated position and size
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(effectiveX,
              size.height / 2), // Place the bar in the center vertically
          width: barWidth, // Set the width of the bar
          height:
              barHeight, // Set the height of the bar based on the waveform data
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) {
    // Only repaint if the progress, waveform, or RTL state has changed
    return oldDelegate.progress != progress ||
        oldDelegate.waveform != waveform ||
        oldDelegate.isRtl != isRtl;
  }
}
