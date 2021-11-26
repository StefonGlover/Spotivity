import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotivity/controllers/spotify_controller.dart';
import 'package:spotify/spotify.dart';

class TrackList extends StatelessWidget {
  final List<Track> tracks;

  const TrackList(this.tracks, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (tracks.isEmpty) return Container();
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: Get.height * 0.4,
      child: ListView(
        children: tracks.map((e) => trackTile(e)).toList(),
      ),
    );
  }

  Widget trackTile(Track track) {
    Duration duration = Duration(milliseconds: track.durationMs as int);
    return InkWell(
      onTap: () {
        (track.previewUrl != null)
            ? Get.find<SpotifyController>().playMusic(track)
            : Get.defaultDialog(
                title: 'Sorry', middleText: 'Preview not available');
      },
      child: SizedBox(
        height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Text(
              track.name as String,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.black),
            )),
            SizedBox(
                width: 40,
                child:
                    Text(Get.find<SpotifyController>().getDuration(duration)))
          ],
        ),
      ),
    );
  }
}
