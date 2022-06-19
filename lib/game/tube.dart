import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter_bird/game/config.dart';
import 'package:flutter_bird/main.dart';

enum TubeType { top, bottom }
enum TubeStatus { stop, moving }

class Tube extends PositionComponent {
  late SpriteComponent ground;
  Tube? bottomTube;
  TubeType type;
  bool _hasBeenOnScreen = false;
  final double _holeRange = 150;
  double get _topTubeOffset => Singleton.instance.screenSize.height * 0.15;
  double get _bottomTubeOffset => Singleton.instance.screenSize.height * 0.5;

  bool get isOnScreen =>
      ground.x + ComponentDimensions.tubeWidth > 0 &&
      ground.x < Singleton.instance.screenSize.width;

  bool crossedBird = false;
  TubeStatus status = TubeStatus.stop;

  Tube({required this.type, this.bottomTube});

  @override
  Future<void>? onLoad() async {
    Sprite tubeSprite = await Sprite.load(
      "sprite.png",
      srcSize: Vector2(SpriteDimensions.tubeWidth, SpriteDimensions.tubeHeight),
      srcPosition: Vector2(SpritesPostions.tubeX, SpritesPostions.tubeY),
    );

    ground = SpriteComponent(
        sprite: tubeSprite,
        size: Vector2(SpritesPostions.tubeX, SpritesPostions.tubeY * 2));

    switch (type) {
      case TubeType.top:
        ground.angle = 3.14159; // radians
        break;
      default:
    }

    add(ground);
    return super.onLoad();
  }

  @override
  Rect toRect() {
    var baseRect = super.toRect();
    if (type == TubeType.bottom) {
      return baseRect;
    } else {
      return Rect.fromLTWH(
          baseRect.left - ComponentDimensions.tubeWidth,
          baseRect.top - ComponentDimensions.tubeHeight,
          baseRect.width,
          baseRect.height);
    }
  }

  void setPosition(double x, double y) {
    _hasBeenOnScreen = false;
    crossedBird = false;
    ground.x = x + (type == TubeType.top ? ComponentDimensions.tubeWidth : 0);
    setY();
  }

  @override
  void update(double dt) {
    if (status == TubeStatus.moving) {
      if (!_hasBeenOnScreen && isOnScreen) {
        _hasBeenOnScreen = true;
      }
      if (_hasBeenOnScreen && !isOnScreen) {
        ground.x = Singleton.instance.screenSize.width * 1.2;
        setY();
        crossedBird = false;
        _hasBeenOnScreen = false;
      }
      ground.x -= dt * Speed.GroundSpeed;
    }
  }

  void stop() {
    status = TubeStatus.stop;
  }

  void move() {
    status = TubeStatus.moving;
  }

  void setY() {
    var ratio = double.parse(Random().nextDouble().toStringAsFixed(2));
    var length = _bottomTubeOffset - _topTubeOffset;
    var newY = length * ratio + _topTubeOffset;
    ground.y = newY;
    if (bottomTube != null) {
      bottomTube?.ground.y = newY + _holeRange;
    }
  }
}
