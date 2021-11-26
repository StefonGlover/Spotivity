// ignore_for_file: avoid_print, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:get/get.dart';
import 'package:spotivity/controllers/player_controller.dart';

class PlayerContent extends StatefulWidget {
  final Animation playerMargin;

  const PlayerContent(this.playerMargin, {Key? key}) : super(key: key);

  @override
  PlayerContentState createState() => PlayerContentState();
}

class PlayerContentState extends State<PlayerContent>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation closePlayer;
  PlayerController playerController = Get.find<PlayerController>();

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..addListener(() {
        setState(() {});
      });
    closePlayer =
        Tween<double>(begin: 1.0, end: 0.0).animate(animationController);
    playerController.setAnimationController(animationController);
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
        offset: const Offset(0, 740),
        child: Container(
            height: Get.height * .1,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Opacity(
                    opacity: widget.playerMargin.value,
                    child: Container(
                      width: Get.width / 2,
                      height: Get.height * 0.06,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30))),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 40 + (widget.playerMargin.value * 15 as double),
                      height: 40 + (widget.playerMargin.value * 15 as double),
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: Obx(() => IconButton(
                          icon: Icon(
                            playerController.playing.value
                                ? Entypo.pause
                                : Entypo.play,
                            size:
                                20 + (widget.playerMargin.value * 5 as double),
                            color: Colors.white,
                          ),
                          onPressed: () => playerController.playing.value
                              ? playerController.pause()
                              : playerController.play())),
                    ),
                  ],
                )
              ],
            )));
  }

  double getMargin() {
    return (Get.height * 0.9) +
        (Get.height * 0.2) * closePlayer.value -
        (widget.playerMargin.value * 30);
  }
}
