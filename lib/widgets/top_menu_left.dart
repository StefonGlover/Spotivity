import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotivity/controllers/spotify_controller.dart';
import 'package:spotivity/enums/to.dart';

class TopMenuLeft extends StatelessWidget {
  final Animation marginLeft;

  const TopMenuLeft(this.marginLeft, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(-40 * marginLeft.value as double, 10),
      child: IconButton(
          onPressed: () {
            Get.find<SpotifyController>().stateController(To.back);
          },
          icon: const Icon(Icons.chevron_left, color: Colors.black, size: 33)),
    );
  }
}
