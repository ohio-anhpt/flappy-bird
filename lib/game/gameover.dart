import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter_bird/game/config.dart';

class GameOver extends PositionComponent {


  @override
  Future<void>? onLoad() async {
    Sprite bgSprite = await Sprite.load(
      "sprite.png",
      srcSize: Vector2(
          SpriteDimensions.gameOverWidth, SpriteDimensions.gameOverHeight),
      srcPosition:
          Vector2(SpritesPostions.gameOverX, SpritesPostions.gameOverY),
    );
    var background = SpriteComponent(
      sprite: bgSprite,
    );
    add(background);
    return super.onLoad();
  }
}
