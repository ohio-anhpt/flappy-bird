import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bird/game/game.dart';

class GamePage extends StatelessWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var flutterBirdGame = FlutterBirdGame();

    return GestureDetector(
      onTapDown: (TapDownDetails evt) => flutterBirdGame.onTap(),
      child: GameWidget(
        game: flutterBirdGame,
      ),
    );
  }
}
