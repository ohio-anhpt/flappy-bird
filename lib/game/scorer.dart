import 'dart:collection';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'config.dart';

class Scorer extends PositionComponent {
  int _score = 0;
  late Size screenSize;
  late HashMap<String, Sprite> _digits;
  late ScorerGround _oneDigitGround;
  late ScorerGround _twoDigitGround;
  late ScorerGround _threeDigitGround;

  Scorer({required this.screenSize});

  @override
  Future<void>? onLoad() async {
    await _initSprites("sprite.png");
    _renderDefaultView();
  }

  void increase() {
    _score++;
    _render();
    FlameAudio.play('point.wav');
  }

  void reset() {
    _score = 0;
    _render();
  }

  void _render() {
    // Adds leading zeroes to 3 digits
    var scoreStr = _score.toString().padLeft(3, '0');
    _oneDigitGround.sprite = _digits[scoreStr[2]];
    _twoDigitGround.sprite = _digits[scoreStr[1]];
    _threeDigitGround.sprite = _digits[scoreStr[0]];
  }

  loadSprite(
    String spriteImage, {
    required double width,
    required double height,
    required double x,
    required double y,
  }) async {
    Sprite sprite = await Sprite.load(
      spriteImage,
      srcSize: Vector2(width, height),
      srcPosition: Vector2(x, y),
    );
    return sprite;
  }

  _initSprites(String spriteImage) async {
    _digits = HashMap.from({
      "0": await loadSprite(
        spriteImage,
        width: SpriteDimensions.numberWidth,
        height: SpriteDimensions.numberHeight,
        x: SpritesPostions.zeroNumberX,
        y: SpritesPostions.zeroNumberY,
      ),
      "1": await loadSprite(
        spriteImage,
        width: SpriteDimensions.numberWidth,
        height: SpriteDimensions.numberHeight,
        x: SpritesPostions.firstNumberX,
        y: SpritesPostions.firstNumberY,
      ),
      "2": await loadSprite(
        spriteImage,
        width: SpriteDimensions.numberWidth,
        height: SpriteDimensions.numberHeight,
        x: SpritesPostions.secondNumberX,
        y: SpritesPostions.secondNumberY,
      ),
      "3": await loadSprite(
        spriteImage,
        width: SpriteDimensions.numberWidth,
        height: SpriteDimensions.numberHeight,
        x: SpritesPostions.thirdNumberX,
        y: SpritesPostions.thirdNumberY,
      ),
      "4": await loadSprite(
        spriteImage,
        width: SpriteDimensions.numberWidth,
        height: SpriteDimensions.numberHeight,
        x: SpritesPostions.fourthNumberX,
        y: SpritesPostions.fourthNumberY,
      ),
      "5": await loadSprite(
        spriteImage,
        width: SpriteDimensions.numberWidth,
        height: SpriteDimensions.numberHeight,
        x: SpritesPostions.fifthNumberX,
        y: SpritesPostions.fifthNumberY,
      ),
      "6": await loadSprite(
        spriteImage,
        width: SpriteDimensions.numberWidth,
        height: SpriteDimensions.numberHeight,
        x: SpritesPostions.sixthNumberX,
        y: SpritesPostions.sixthNumberY,
      ),
      "7": await loadSprite(
        spriteImage,
        width: SpriteDimensions.numberWidth,
        height: SpriteDimensions.numberHeight,
        x: SpritesPostions.seventhNumberX,
        y: SpritesPostions.seventhNumberY,
      ),
      "8": await loadSprite(
        spriteImage,
        width: SpriteDimensions.numberWidth,
        height: SpriteDimensions.numberHeight,
        x: SpritesPostions.eighthNumberX,
        y: SpritesPostions.eighthNumberY,
      ),
      "9": await loadSprite(
        spriteImage,
        width: SpriteDimensions.numberWidth,
        height: SpriteDimensions.numberHeight,
        x: SpritesPostions.ninethNumberX,
        y: SpritesPostions.ninethNumberY,
      )
    });
  }

  void _renderDefaultView() {
    double defaultY = 80;
    var twoGroundX = (screenSize.width) / 2;
    _twoDigitGround = ScorerGround(_digits["0"]!);
    _twoDigitGround.x = twoGroundX - ComponentDimensions.numberWidth / 2;
    _twoDigitGround.y = defaultY;
    _oneDigitGround = ScorerGround(_digits["0"]!);
    _oneDigitGround.x = twoGroundX;
    _oneDigitGround.y = defaultY;
    _threeDigitGround = ScorerGround(_digits["0"]!);
    _threeDigitGround.x = twoGroundX - ComponentDimensions.numberWidth;
    _threeDigitGround.y = defaultY;
    this
      ..add(_oneDigitGround)
      ..add(_twoDigitGround)
      ..add(_threeDigitGround);
  }
}

class ScorerGround extends SpriteComponent {
  ScorerGround(Sprite sprite, [int multiplier = 1]) : super(sprite: sprite);
}
