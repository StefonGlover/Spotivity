import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotivity/controllers/spotify_controller.dart';
import 'package:spotivity/models/artist_model.dart';

import 'artist_tile.dart';

class ArtistList extends StatelessWidget {
  final Animation fadeIn;
  final Animation fadeOut;

  const ArtistList(this.fadeIn, this.fadeOut, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (fadeIn.value == 1) {
      if (fadeOut.value > 0.8) {
        return _buildWidget(context);
      } else {
        return IgnorePointer(child: _buildWidget(context));
      }
    } else if (fadeIn.value == 0) {
      return IgnorePointer(child: _buildWidget(context));
    } else {
      return _buildWidget(context);
    }
  }

  Widget _buildWidget(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Opacity(
        opacity: fadeIn.value == 1 ? fadeOut.value : fadeIn.value,
        child: SafeArea(
            child: Container(
          margin: EdgeInsets.only(top: height * 0.1),
          child: GetBuilder<SpotifyController>(
            id: 'artist_list',
            builder: (controller) {
              // ignore: invalid_use_of_protected_member
              List<ArtistModel> list = controller.artistList.value;
              if (list.isNotEmpty) {
                return ListView(
                  children: list
                      .map((artistModel) => ArtistTile(artistModel))
                      .toList(),
                );
              } else {
                return Container(
                  color: Colors.white,
                  child: const Center(
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.black)),
                  ),
                );
              }
            },
          ),
        )));
  }
}
