import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter_bird/game/config.dart';

class Horizon extends PositionComponent {
  double screenWidth;
  double screenHeight;
  Horizon({required this.screenWidth, required this.screenHeight});

  @override
  Future<void>? onLoad() async {
    Sprite bgSprite = await Sprite.load(
      "sprite.png",
      srcSize: Vector2(
          SpriteDimensions.horizontWidth, SpriteDimensions.horizontHeight),
      srcPosition: Vector2(0.0, 0.0),
    );
    var background = SpriteComponent(
        sprite: bgSprite, size: Vector2(screenWidth, screenHeight));
    add(background);
    return super.onLoad();
  }
}
