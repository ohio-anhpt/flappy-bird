import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter_bird/game/config.dart';

enum BottomStatus { waiting, moving }

class Bottom extends PositionComponent {
  late SpriteComponent firstGround;
  late SpriteComponent secondGround;
  double sizeWidth;
  BottomStatus status = BottomStatus.waiting;

  late Rect _rect;
  Rect get rect => _rect;

  Bottom({required this.sizeWidth});

  @override
  Future<void>? onLoad() async {
    Sprite sprite = await Sprite.load(
      "sprite.png",
      srcSize:
          Vector2(SpriteDimensions.bottomWidth, SpriteDimensions.bottomHeight),
      srcPosition: Vector2(SpritesPostions.bottomX, SpritesPostions.bottomY),
    );
    firstGround = SpriteComponent(
      sprite: sprite,
      size: Vector2(sizeWidth, SpriteDimensions.bottomHeight * 2.5),
    );
    secondGround = SpriteComponent(
      sprite: sprite,
      size: Vector2(sizeWidth, SpriteDimensions.bottomHeight * 2.5),
    );
    add(firstGround);
    add(secondGround);
    return super.onLoad();
  }

  void setPosition(double x, double y) {
    firstGround.x = x;
    firstGround.y = y;
    secondGround.x = firstGround.width;
    secondGround.y = y;
    _rect = Rect.fromLTWH(x, y, sizeWidth, ComponentDimensions.bottomHeight);
  }

  @override
  void update(double dt) {
    if (status == BottomStatus.moving) {
      firstGround.x -= dt * Speed.GroundSpeed;
      secondGround.x -= dt * Speed.GroundSpeed;

      if (firstGround.x + firstGround.width <= 0) {
        firstGround.x = secondGround.x + secondGround.width;
      }

      if (secondGround.x + secondGround.width <= 0) {
        secondGround.x = firstGround.x + firstGround.width;
      }
    }
  }

  void move() {
    status = BottomStatus.moving;
  }

  void stop() {
    status = BottomStatus.waiting;
  }
}
