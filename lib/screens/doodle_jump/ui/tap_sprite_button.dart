import 'package:flame/events.dart';
import 'package:flame/input.dart';

class TapSpriteButton extends SpriteButtonComponent {
  final Function()? onPressedDown;
  final Function()? onPressedUp;
  final Function()? onPressedCancel;

  TapSpriteButton(
      {this.onPressedDown,
      this.onPressedUp,
      this.onPressedCancel,
      super.button,
      super.buttonDown,
      super.size,
      super.position,
      super.priority,
      super.onPressed})
      : super();

  @override
  void onTapDown(TapDownEvent _) {
    super.onTapDown(_);
    if (onPressedDown != null) {
      onPressedDown!();
    }
  }

  @override
  void onTapUp(_) {
    super.onTapUp(_);
    if (onPressedUp != null) {
      onPressedUp!();
    }
  }

  @override
  void onTapCancel(_) {
    super.onTapCancel(_);
    if (onPressedCancel != null) {
      onPressedCancel!();
    }
  }
}
