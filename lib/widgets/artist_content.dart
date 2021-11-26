import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotivity/controllers/spotify_controller.dart';
import 'package:spotivity/widgets/track_list.dart';
import 'package:spotify/spotify.dart';

class ArtistContent extends StatelessWidget {
  final Animation fadeIn;
  final Animation fadeOut;
  final List<Track> topSongs;

  ArtistContent(this.fadeIn, this.fadeOut, {Key? key})
      : topSongs = Get.find<SpotifyController>().topSongs,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (fadeIn.value <= 0.2) {
      return IgnorePointer(child: _buildWidget(context));
    } else if (fadeOut.value <= 0.2) {
      return IgnorePointer(child: _buildWidget(context));
    } else {
      return _buildWidget(context);
    }
  }

  Widget _buildWidget(BuildContext context) {
    return Opacity(
      opacity: fadeIn.value == 1 ? fadeOut.value : fadeIn.value,
      child: Container(
        width: Get.width,
        margin: EdgeInsets.only(left: 30, right: 30, top: Get.height / 3),
        padding: const EdgeInsets.only(top: 30),
        child: ListView(
          children: [TrackList(topSongs)],
        ),
      ),
    );
  }
}
