import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotivity/controllers/spotify_controller.dart';

class ArtistBanner extends StatelessWidget {
  final Animation marginTop;
  final Animation openMusic;
  final SpotifyController controller;

  ArtistBanner(this.marginTop, this.openMusic, {Key? key})
      : controller = Get.find<SpotifyController>(),
        super(key: key);

  get artist => controller.artistOpened.value;
  get music => controller.musicPlaying.value;

  @override
  Widget build(BuildContext context) {
    if (artist.images == null) return Container();
    return Transform.translate(
      offset: Offset(0, -(marginTop.value * Get.height / 2)),
      child: Container(
          alignment: Alignment.bottomCenter,
          width: Get.width * 0.7 + ((Get.width * 0.06) * openMusic.value),
          height: Get.height / 3 + (Get.height / 4 * openMusic.value),
          margin: EdgeInsets.only(
              left: Get.width * 0.15 - (Get.width * 0.03) * openMusic.value),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(150),
                  bottomRight: Radius.circular(150)),
              boxShadow: const <BoxShadow>[
                BoxShadow(color: Colors.black, blurRadius: 5)
              ],
              color: Colors.white,
              image: DecorationImage(
                  image: artist.images.isEmpty
                      ? const AssetImage("images/vinyl.png") as ImageProvider
                      : NetworkImage(artist.images.first.url),
                  fit: BoxFit.fitHeight)),
          child: Container(
            width: Get.width * 0.4,
            margin: const EdgeInsets.only(bottom: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (openMusic.value >= 0.1)
                  Opacity(
                      opacity: openMusic.value,
                      child: (music.name == null)
                          ? Container()
                          : Text(music.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white,
                                  shadows: <Shadow>[
                                    Shadow(
                                        offset: Offset(1.0, 1.0),
                                        blurRadius: 3.0,
                                        color: Colors.black)
                                  ],
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  decorationColor: Colors.black))),
                Text(artist.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        shadows: const <Shadow>[
                          Shadow(
                              offset: Offset(1.0, 1.0),
                              blurRadius: 3.0,
                              color: Colors.black)
                        ],
                        fontSize: 20 - (openMusic.value * 5) as double,
                        fontWeight: openMusic.value >= 0.1
                            ? FontWeight.normal
                            : FontWeight.bold,
                        decorationColor: Colors.black))
              ],
            ),
          )),
    );
  }
}
