import 'package:flutter/material.dart';
import 'package:voice_note_kit/player/player_enums/player_enums.dart'; // Import for PlayIconShapeType (enum)
import 'package:voice_note_kit/player/utils/get_shape.dart'; // Import for the utility function to get the shape

/// A custom player control button that toggles between play and pause states.
class PlayerControls extends StatelessWidget {
  final double size; // Size of the player control button
  final Color iconColor; // Color of the icon (play/pause)
  final Color backgroundColor; // Background color of the control button
  final PlayIconShapeType
      shapeType; // The shape type for the control button (determines its shape)
  final bool
      isPlaying; // Boolean flag to indicate whether the audio is currently playing
  final VoidCallback
      onPlayPause; // Callback function that toggles between play and pause
  final TextDirection
      textDirection; // Text direction to handle different languages (LTR or RTL)

  const PlayerControls({
    super.key,
    required this.size,
    required this.iconColor,
    required this.backgroundColor,
    required this.shapeType,
    required this.isPlaying,
    required this.onPlayPause,
    required this.textDirection,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      // AnimatedContainer that will smoothly transition its size and shape changes
      duration: const Duration(milliseconds: 200), // Duration for the animation
      width: size, // Width of the control button
      height: size, // Height of the control button
      decoration: ShapeDecoration(
        color: backgroundColor, // Set the background color
        shape: getShape(
            shapeType), // Get the shape based on the provided shape type
      ),
      child: IconButton(
        // IconButton widget that handles the play/pause action
        icon: RotatedBox(
          // Rotates the icon based on the text direction (LTR or RTL)
          quarterTurns: textDirection == TextDirection.ltr ? 0 : 2,
          child: Icon(
            // Display either the play or pause icon based on the `isPlaying` state
            isPlaying ? Icons.pause : Icons.play_arrow,
            color: iconColor, // Color of the icon
            size: size / 2.3, // Icon size based on the button size
          ),
        ),
        onPressed:
            onPlayPause, // Invoke the callback to toggle between play/pause
      ),
    );
  }
}
