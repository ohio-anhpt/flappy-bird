// ignore: import_of_legacy_library_into_null_safe
import 'package:flame/flame.dart' show Flame;
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bird/game/game.dart';
import 'package:flutter_bird/game/game_page.dart';
import 'package:flutter_bird/login/login.dart';

void main() async {
  // initial settings
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  Singleton.instance.screenSize = const Size(600, 1024);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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

class Singleton {
  late Size screenSize;
  Singleton._privateConstructor();
  static final Singleton instance = Singleton._privateConstructor();
}
