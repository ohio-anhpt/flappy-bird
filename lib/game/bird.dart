import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter_bird/game/config.dart';

enum BirdStatus { waiting, flying }

enum BirdFlyingStatus { up, down, none }

class Bird extends PositionComponent {
  int _counter = 0;
  final int _movingUpSteps = 15;
  double _heightDiff = 0.0;
  double _stepDiff = 0.0;
  double maxFlyHeight = -40.0;
  var sizeBird = const Size(40, 32);

  late SpriteAnimationComponent ground;
  BirdStatus status = BirdStatus.waiting;
  BirdFlyingStatus flyingStatus = BirdFlyingStatus.none;

  double sizeWidth;

  Bird({required this.sizeWidth});

  @override
  Future<void>? onLoad() async {
    List<Sprite> sprites = [
      await Sprite.load(
        "sprite.png",
        srcSize:
            Vector2(SpriteDimensions.birdWidth, SpriteDimensions.birdHeight),
        srcPosition:
            Vector2(SpritesPostions.birdSprite1X, SpritesPostions.birdSprite1Y),
      ),
      await Sprite.load(
        "sprite.png",
        srcSize:
            Vector2(SpriteDimensions.birdWidth, SpriteDimensions.birdHeight),
        srcPosition:
            Vector2(SpritesPostions.birdSprite2X, SpritesPostions.birdSprite2Y),
      ),
      await Sprite.load(
        "sprite.png",
        srcSize:
            Vector2(SpriteDimensions.birdWidth, SpriteDimensions.birdHeight),
        srcPosition:
            Vector2(SpritesPostions.birdSprite3X, SpritesPostions.birdSprite3Y),
      )
    ];
    var animatedBird = SpriteAnimation.spriteList(sprites, stepTime: 0.2);
    ground = SpriteAnimationComponent(
        animation: animatedBird,
        size: Vector2(sizeBird.width, sizeBird.height),
        position: Vector2(sizeWidth / 3.5 - sizeBird.width / 2, 300));
    add(ground);
    return super.onLoad();
  }

  void reset() {
    ground.angle = 0;
  }

  void setPosition(double x, double y) {
    ground.x = x;
    ground.y = y;
  }

  @override
  void update(double dt) {
    if (status == BirdStatus.flying) {
      _counter++;
      if (_counter <= _movingUpSteps) {
        flyingStatus = BirdFlyingStatus.up;
        ground.angle -= 0.03;
        ground.y -= dt * 200 * getSpeedRatio(flyingStatus, _counter);
      } else {
        flyingStatus = BirdFlyingStatus.down;

        if (_heightDiff == 0) _heightDiff = (size[0] - ground.y);
        if (_stepDiff == 0) _stepDiff = ground.angle.abs() / (_heightDiff / 10);

        ground.angle += 0.03;
        ground.y += dt * 200 * getSpeedRatio(flyingStatus, _counter);
      }
      if (ground.y < maxFlyHeight) {
        ground.y = maxFlyHeight;
      }
    }
    super.update(dt);
  }

  double getSpeedRatio(BirdFlyingStatus flyingStatus, int counter) {
    if (flyingStatus == BirdFlyingStatus.up) {
      var backwardCounter = _movingUpSteps - counter;
      return backwardCounter / 5.0;
    }
    if (flyingStatus == BirdFlyingStatus.down) {
      var diffCounter = counter - _movingUpSteps;
      return diffCounter / 5.0;
    }
    return 0.0;
  }

  void jump() {
    FlameAudio.play('wing.wav');
    status = BirdStatus.flying;
    _counter = 0;
    ground.angle = 0;
  }
}
