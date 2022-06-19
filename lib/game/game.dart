import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter_bird/game/bird.dart';
import 'package:flutter_bird/game/bottom.dart';
import 'package:flutter_bird/game/config.dart';
import 'package:flutter_bird/game/gameover.dart';
import 'package:flutter_bird/game/horizont.dart';
import 'package:flutter_bird/game/scorer.dart';
import 'package:flutter_bird/game/tube.dart';
import 'package:flutter_bird/main.dart';

enum GameStatus { playing, waiting, gameOver }

enum BirdFlyingStatus { up, down, none }

enum BirdStatus { waiting, flying }

class FlutterBirdGame extends FlameGame {
  var bird = Bird(sizeWidth: Singleton.instance.screenSize.width);
  var bottom = Bottom(sizeWidth: Singleton.instance.screenSize.width);
  GameOver? gameOver;

  var score = Scorer(
      screenSize: Size(Singleton.instance.screenSize.width,
          Singleton.instance.screenSize.height));
  var firstBottomTube = Tube(type: TubeType.bottom);
  late Tube firstTopTube;
  var secondBottomTube = Tube(type: TubeType.bottom);
  late Tube secondTopTube;
  var thirdBottomTube = Tube(type: TubeType.bottom);
  late Tube thirdTopTube;
  late List<Tube> allTubes;

  double xTubeOffset = 264;

  late GameStatus status;

  @override
  Future<void>? onLoad() async {
    var background = Horizon(screenWidth: size[0], screenHeight: size[1]);
    firstTopTube = Tube(type: TubeType.top, bottomTube: firstBottomTube);
    secondTopTube = Tube(type: TubeType.top, bottomTube: secondBottomTube);
    thirdTopTube = Tube(type: TubeType.top, bottomTube: thirdBottomTube);
    await add(background);
    allTubes = [
      firstBottomTube,
      firstTopTube,
      secondBottomTube,
      secondTopTube,
      thirdBottomTube,
      thirdTopTube
    ];
    await addAll(allTubes);
    await add(bottom);
    await add(bird);

    await add(score);
    initPositions();
    status = GameStatus.waiting;
    return super.onLoad();
  }

  void initPositions() {
    double xTubeStart = size[0] * 1.5;
    bird.setPosition(ComponentPositions.birdX, ComponentPositions.birdY);
    var groundY = size[1] - ComponentDimensions.bottomHeight;
    bottom.setPosition(0, groundY);
    bird.setGroundY(groundY);
    firstBottomTube.setPosition(xTubeStart, 400);
    firstTopTube.setPosition(xTubeStart, -250);
    secondBottomTube.setPosition(xTubeStart + xTubeOffset, 400);
    secondTopTube.setPosition(xTubeStart + xTubeOffset, -250);
    thirdBottomTube.setPosition(xTubeStart + xTubeOffset * 2, 400);
    thirdTopTube.setPosition(xTubeStart + xTubeOffset * 2, -250);
  }

  @override
  void update(double dt) {
    if (status != GameStatus.gameOver) {
      bottom.move();
    }

    if (status == GameStatus.playing) {
      var birdRect = bird.mainSprite.toRect();

      if (check2ItemsCollision(birdRect, bottom.rect)) {
        gameOverAction();
      }

      if (check2ItemsCollision(birdRect, firstBottomTube.ground.toRect())) {
        gameOverAction();
      }

      if (check2ItemsCollision(birdRect, firstTopTube.ground.toRect())) {
        gameOverAction();
      }

      if (check2ItemsCollision(birdRect, secondBottomTube.ground.toRect())) {
        gameOverAction();
      }

      if (check2ItemsCollision(birdRect, secondTopTube.ground.toRect())) {
        gameOverAction();
      }

      if (check2ItemsCollision(birdRect, thirdBottomTube.ground.toRect())) {
        gameOverAction();
      }

      if (check2ItemsCollision(birdRect, thirdTopTube.ground.toRect())) {
        gameOverAction();
      }

      if (checkIfBirdCrossedTube(firstTopTube) ||
          checkIfBirdCrossedTube(secondTopTube) ||
          checkIfBirdCrossedTube(thirdTopTube)) {
        score.increase();
      }
    }

    return super.update(dt);
  }

  Future<void> gameOverAction() async {
    if (status != GameStatus.gameOver) {
      FlameAudio.play('hit.wav');
      FlameAudio.play('die.wav');
      status = GameStatus.gameOver;
      bird.die();
      gameOver = GameOver();
      add(gameOver!)?.then((value) {
        gameOver!.y = (Singleton.instance.screenSize.height) / 3;
        gameOver!.x = (Singleton.instance.screenSize.width) / 4;
      });
      bottom.stop();
      for (var element in allTubes) {
        element.stop();
      }
    }
  }

  bool checkIfBirdCrossedTube(Tube tube) {
    if (!tube.crossedBird) {
      var tubeRect = tube.ground.toRect();
      var xCenterOfTube = tubeRect.left + tubeRect.width / 2;
      var xCenterOfBird =
          ComponentPositions.birdX + ComponentDimensions.birdWidth / 2;
      if (xCenterOfTube < xCenterOfBird && status == GameStatus.playing) {
        tube.crossedBird = true;
        return true;
      }
    }
    return false;
  }

  void onTap() {
    switch (status) {
      case GameStatus.waiting:
        status = GameStatus.playing;
        if (gameOver != null) {
          remove(gameOver!);
          gameOver = null;
        }
        bird.reset();
        bird.jump();
        bottom.move();
        for (var element in allTubes) {
          element.move();
        }
        break;
      case GameStatus.gameOver:
        status = GameStatus.waiting;
        if (gameOver != null) {
          remove(gameOver!);
          gameOver = null;
        }
        bird.reset();
        score.reset();
        bottom.stop();
        for (var element in allTubes) {
          element.stop();
        }
        initPositions();
        break;
      case GameStatus.playing:
        bird.jump();
        break;
      default:
    }
  }

  bool check2ItemsCollision(Rect item1, Rect item2) {
    var intersectedRect = item1.intersect(item2);
    return intersectedRect.width > 0 && intersectedRect.height > 0;
  }
}
