import 'package:flutter/material.dart';

/// A button that allows the user to adjust the playback speed
/// by tapping it to cycle through different predefined speeds.
class SpeedButton extends StatelessWidget {
  final double currentSpeed; // Current playback speed (e.g., 1.0x, 1.5x, etc.)
  final List<double>
      playbackSpeeds; // List of available playback speeds (e.g., [1.0, 1.5, 2.0])
  final Function(double speed)
      setSpeed; // Callback function to set the selected speed
  final Color iconColor; // Color of the text and icon displayed on the button
  final Color? backgroundColor; // Optional background color for the button

  const SpeedButton({
    super.key,
    required this.currentSpeed,
    required this.playbackSpeeds,
    required this.setSpeed,
    required this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // GestureDetector allows the user to tap the button and trigger an action
      onTap: () {
        // Find the index of the current speed in the playbackSpeeds list
        int currentIndex = playbackSpeeds.indexOf(currentSpeed);

        // Determine the next index (looping back to the start when the end is reached)
        int nextIndex = (currentIndex + 1) % playbackSpeeds.length;

        // Get the next playback speed
        double nextSpeed = playbackSpeeds[nextIndex];

        // Set the new playback speed using the provided callback
        setSpeed(nextSpeed);
      },
      child: Container(
        // Container to wrap the button, providing styling and interaction effects
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0), // Rounded corners
          color: backgroundColor ??
              iconColor.withAlpha((0.2 * 255)
                  .round()), // Background color, defaulting to a translucent version of iconColor
        ),
        child: Text(
          // Display the current playback speed (e.g., '1.0x', '1.5x')
          '${currentSpeed}x',
          style: TextStyle(
              color: iconColor,
              fontSize: 14), // Text style with icon color and font size
        ),
      ),
    );
  }
}
