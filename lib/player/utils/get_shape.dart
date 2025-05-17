import 'package:flutter/material.dart';
import 'package:voice_note_kit/player/player_enums/player_enums.dart';

// Method To return the shape of the play icon
ShapeBorder getShape(PlayIconShapeType shapeType) {
  switch (shapeType) {
    case PlayIconShapeType.roundedRectangle:
      return RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));
    case PlayIconShapeType.square:
      return const RoundedRectangleBorder();
    case PlayIconShapeType.circular:
      return const CircleBorder();
  }
}
