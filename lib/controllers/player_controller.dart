// ignore_for_file: avoid_print

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotivity/controllers/spotify_controller.dart';
import 'package:spotivity/enums/animation_state.dart';
import 'package:spotivity/views/home_view.dart';

class PlayerController extends GetxController {
  final AudioPlayer audioPlayer;
  final HomePageState mainApplication;
  late AnimationController animationController;

  var playing = false.obs;

  PlayerController(this.mainApplication) : audioPlayer = AudioPlayer();

  void setAnimationController(AnimationController controller) {
    animationController = controller;
    audioPlayer.onPlayerStateChanged.listen((state) {
      print(state);
      switch (state) {
        case PlayerState.COMPLETED:
          playing.call(false);
          break;
        case PlayerState.PAUSED:
          playing.call(false);
          Future.delayed(const Duration(seconds: 5), () => stateController());
          break;
        case PlayerState.PLAYING:
          animationController.forward();
          break;
        case PlayerState.STOPPED:
          break;
      }
    });
  }

  void stateController() {
    bool state =
        Get.find<SpotifyController>().state == AnimationState.openMusic;
    if (!playing.value && !state) animationController.reverse();
    update();
  }

  void play({String? url}) {
    if (url == null) {
      resume();
    } else {
      if (audioPlayer.state == PlayerState.PLAYING) audioPlayer.stop();
      audioPlayer.play(url);
      playing.call(true);
    }
  }

  void resume() {
    audioPlayer.resume();
    playing.call(true);
  }

  void pause() {
    audioPlayer.pause();
    playing.call(false);
  }
}
