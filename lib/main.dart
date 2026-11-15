import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Frog> frogs = [Frog((5, 5), 2, Colors.orange, 0)];
  List<Bug> bugs = [Bug((0, 0), -2, Colors.blue)];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ...frogs
            .cast<Entity>()
            .followedBy(bugs)
            .map((e) => EntityWidget.from(e)),
        ...frogs.map((e) => TongueWidget(frog: e)),
      ],
    );
  }
}

class TongueWidget extends StatelessWidget {
  const TongueWidget({super.key, required this.frog});

  final Frog frog;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: frog.position.$2 * 64 - frog.tongueWidth * 64,
      left: frog.position.$1 * 64,
      child: Transform.rotate(
        angle: frog.angle,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 4,
              height: frog.tongueWidth * 64,
              color: Colors.red,
            ),
            const SizedBox(
              width: 64,
              height: 64,
            ),
            SizedBox(
              width: 4,
              height: frog.tongueWidth * 64,
            ),
          ],
        ),
      ),
    );
  }
}

class EntityWidget extends StatelessWidget {
  const EntityWidget(
      {super.key,
      required this.position,
      required this.asset,
      required this.angle,
      required this.color});

  final (double, double) position;
  final String asset;
  final double angle;
  final Color color;

  factory EntityWidget.from(Entity entity) {
    return EntityWidget(
      position: entity.position,
      asset: entity is Frog ? 'frog.png' : 'bug.png',
      angle: entity.angle,
      color: entity.color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.$1 * 64,
      top: position.$2 * 64,
      child: AnimatedRotation(
        turns: angle / (2 * math.pi),
        duration: const Duration(seconds: 1),
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(color, BlendMode.hue),
          child: Container(
            color: Colors.white,
            child: Image.asset(
              asset,
              scale: 1 / 4,
              filterQuality: FilterQuality.none,
            ),
          ),
        ),
      ),
    );
  }
}
