import 'package:flutter/material.dart';

/// A custom progress bar widget that allows users to seek through content (like audio or video).
/// It supports dragging to change the progress and smoothly animates the progress bar.
class ProgressBar extends StatelessWidget {
  final double progressBarHeight; // Height of the progress bar
  final Color
      progressBarBackgroundColor; // Background color of the progress bar
  final Color
      progressBarColor; // Color of the progress indicating part of the bar
  final double progress; // Current progress value (between 0.0 and 1.0)
  final Function(double)
      seekTo; // Callback to handle seeking to the new progress position

  const ProgressBar({
    super.key,
    required this.progressBarHeight,
    required this.progressBarBackgroundColor,
    required this.progressBarColor,
    required this.progress,
    required this.seekTo,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Detect horizontal dragging to change the progress value
      onHorizontalDragUpdate: (details) {
        // Calculate the new progress by adding the change in horizontal drag
        double newProgress =
            (progress + details.primaryDelta! / context.size!.width).clamp(0.0,
                1.0); // Ensure the progress stays within the range [0.0, 1.0]

        // Invoke the seekTo callback to update the progress
        seekTo(newProgress);
      },
      onHorizontalDragEnd: (details) {
        // When the drag ends, seek to the current progress (this may be redundant but ensures the final position is set)
        seekTo(progress);
      },
      child: AnimatedContainer(
        // Container that animates changes to its height and color
        duration: const Duration(
            milliseconds: 200), // Duration for the smooth animation
        height: progressBarHeight, // Set the height of the progress bar
        color:
            progressBarBackgroundColor, // Set the background color of the progress bar
        child: LinearProgressIndicator(
          // Linear progress indicator to visually show progress
          value: progress, // Bind the current progress value
          backgroundColor: Colors
              .transparent, // Make the background transparent to show the progress bar properly
          valueColor: AlwaysStoppedAnimation<Color>(
              progressBarColor), // Set the color of the progress indicator
        ),
      ),
    );
  }
}
