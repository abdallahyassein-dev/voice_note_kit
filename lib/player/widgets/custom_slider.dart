import 'package:flutter/material.dart';

/// CustomSlider is a custom widget that allows users to interact with a slider
/// to adjust progress. It also provides customization for the colors and
/// behavior of the slider.
class CustomSlider extends StatelessWidget {
  final double progress; // Current progress value (range between 0.0 and 1.0)
  final Color progressBarColor; // The color of the active progress bar
  final Color
      progressBarBackgroundColor; // The color of the inactive progress bar
  final Function(double value)
      seekTo; // Function to seek to a specific progress value

  const CustomSlider({
    super.key,
    required this.progress,
    required this.progressBarColor,
    required this.progressBarBackgroundColor,
    required this.seekTo,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20, // The height of the slider
      child: SliderTheme(
        // Customize the appearance of the Slider widget
        data: SliderTheme.of(context).copyWith(
          activeTrackColor: progressBarColor, // Color for the active track
          inactiveTrackColor:
              progressBarBackgroundColor, // Color for the inactive track
          thumbColor: progressBarColor, // Color for the thumb (slider button)
          trackHeight: 6, // Height of the track (progress bar)
          thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 8), // Round thumb with specific radius
          overlayShape:
              SliderComponentShape.noOverlay, // Removes the overlay glow effect
          trackShape:
              const _CustomTrackShape(), // Custom track shape to remove side padding
        ),
        child: Slider(
          value: progress, // Current value of the slider (progress)
          onChanged:
              seekTo, // Callback function when the slider value is changed
        ),
      ),
    );
  }
}

/// Custom track shape class to remove side padding around the slider track.
class _CustomTrackShape extends RoundedRectSliderTrackShape {
  const _CustomTrackShape();

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    // Custom dimensions for the track
    final double trackHeight = sliderTheme.trackHeight ?? 6;
    final double trackLeft = offset.dx; // The horizontal offset of the track
    final double trackTop = offset.dy +
        (parentBox.size.height - trackHeight) /
            2; // Vertical alignment of the track
    final double trackWidth =
        parentBox.size.width; // The width of the track (takes up full width)

    // Return a Rect that represents the slider's track, without side padding
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
