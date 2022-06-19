import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter_bird/game/config.dart';

enum BirdStatus { waiting, flying, die }

class Bird extends PositionComponent {
  static const double jumpSpeed = -360;
  static const double jumpHeadUpAngleVel = -pi * 5;

  static const double rotationAcc = pi * 5;
  static const double rotationMaxAngle = pi / 2;
  static const double rotationMinAngle = -pi / 4;

  static const double gravity = 980;
  static const double maxYSpeed = 1000;

  double maxFlyHeight = -40.0;

  var sizeBird = const Size(42, 32);

  late SpriteAnimationComponent mainSprite;
  late SpriteAnimation normalFlyAnim, flyUpAnim, fallingAnim, dieAnim;

  BirdStatus status = BirdStatus.waiting;

  double yVelocity = 0.0;
  double angleVelocity = 0.0;

  double yAcc = 0.0;

  double sizeWidth;
  double groundY = 90000.0;

  Bird({required this.sizeWidth});

  @override
  Future<void>? onLoad() async {
    List<Sprite> flySprites = [
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
      ),
      await Sprite.load(
        "sprite.png",
        srcSize:
            Vector2(SpriteDimensions.birdWidth, SpriteDimensions.birdHeight),
        srcPosition:
            Vector2(SpritesPostions.birdSprite2X, SpritesPostions.birdSprite2Y),
      ),
    ];
    List<Sprite> flyFastSprites = [
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
      ),
      // await Sprite.load(
      //   "sprite.png",
      //   srcSize:
      //   Vector2(SpriteDimensions.birdWidth, SpriteDimensions.birdHeight),
      //   srcPosition:
      //   Vector2(SpritesPostions.birdSprite2X, SpritesPostions.birdSprite2Y),
      // ),
    ];
    List<Sprite> fallingSprites = [
      await Sprite.load(
        "sprite.png",
        srcSize:
            Vector2(SpriteDimensions.birdWidth, SpriteDimensions.birdHeight),
        srcPosition:
            Vector2(SpritesPostions.birdSprite1X, SpritesPostions.birdSprite1Y),
      ),
      // await Sprite.load(
      //   "sprite.png",
      //   srcSize:
      //   Vector2(SpriteDimensions.birdWidth, SpriteDimensions.birdHeight),
      //   srcPosition:
      //   Vector2(SpritesPostions.birdSprite3X, SpritesPostions.birdSprite3Y),
      // ),
    ];
    List<Sprite> dieSprites = [
      await Sprite.load(
        "sprite.png",
        srcSize:
            Vector2(SpriteDimensions.birdWidth, SpriteDimensions.birdHeight),
        srcPosition:
            Vector2(SpritesPostions.birdSprite2X, SpritesPostions.birdSprite2Y),
      ),
    ];
    normalFlyAnim = SpriteAnimation.spriteList(flySprites, stepTime: 0.2);
    flyUpAnim = SpriteAnimation.spriteList(flyFastSprites, stepTime: 0.16);
    fallingAnim = SpriteAnimation.spriteList(fallingSprites, stepTime: 0.1);
    dieAnim = SpriteAnimation.spriteList(dieSprites, stepTime: 0.2);

    mainSprite = SpriteAnimationComponent(
        animation: normalFlyAnim,
        size: Vector2(sizeBird.width, sizeBird.height),
        position: Vector2(sizeWidth / 3.5 - sizeBird.width / 2, 300));
    await add(mainSprite);
    mainSprite.anchor = Anchor.center;
    return super.onLoad();
  }

  void reset() {
    mainSprite.angle = 0;
    yVelocity = 0.0;
    angleVelocity = 0.0;
    status = BirdStatus.waiting;
  }

  void setPosition(double x, double y) {
    mainSprite.x = x;
    mainSprite.y = y;
  }

  void setGroundY(double y) {
    groundY = y;
  }

  @override
  void update(double dt) {
    if (status != BirdStatus.waiting) {
      // Calculate physic
      // V = V + A*dt
      // Y = Y + V*dt

      yVelocity += gravity * dt;
      if (yVelocity > maxYSpeed) {
        yVelocity = maxYSpeed;
      }
      mainSprite.y += yVelocity * dt;

      if (mainSprite.y < maxFlyHeight) {
        mainSprite.y = maxFlyHeight;
      }
      if (mainSprite.y > groundY) {
        mainSprite.y = groundY;
      }

      if (yVelocity > 0) {
        // Start falling down
        if (angleVelocity < 0) {
          angleVelocity = 0;
        }
        angleVelocity += rotationAcc * dt;
        if (status == BirdStatus.die) {
          if (mainSprite.animation != dieAnim) {
            mainSprite.animation = dieAnim;
          }
        } else {
          if (mainSprite.angle > 0 && mainSprite.animation != fallingAnim) {
            mainSprite.animation = fallingAnim;
          }
        }
      } else {
        if (mainSprite.animation != flyUpAnim) {
          mainSprite.animation = flyUpAnim;
        }
      }

      var currentAngle = mainSprite.angle;
      currentAngle += angleVelocity * dt;
      currentAngle = min(max(currentAngle, rotationMinAngle), rotationMaxAngle);
      mainSprite.angle = currentAngle;
    } else {
      if (mainSprite.animation != normalFlyAnim) {
        mainSprite.animation = normalFlyAnim;
      }
    }
    super.update(dt);
  }

  // double getSpeedRatio(BirdFlyingStatus flyingStatus, int counter) {
  //   if (flyingStatus == BirdFlyingStatus.up) {
  //     var backwardCounter = _movingUpSteps - counter;
  //     return backwardCounter / 5.0;
  //   }
  //   if (flyingStatus == BirdFlyingStatus.down) {
  //     var diffCounter = counter - _movingUpSteps;
  //     return diffCounter / 5.0;
  //   }
  //   return 0.0;
  // }

  void jump() {
    FlameAudio.play('wing.wav');
    if (status != BirdStatus.flying) {
      status = BirdStatus.flying;
    }
    // Instantly jump with JUMP_SPEED, head up with ANGULAR_SPEED
    yVelocity = jumpSpeed;
    angleVelocity = jumpHeadUpAngleVel;
  }

  void die() {
    if (status != BirdStatus.die) {
      status = BirdStatus.die;
    }
  }
}
