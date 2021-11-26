import 'package:flutter/material.dart';
import 'package:spotivity/controllers/player_controller.dart';
import 'package:spotivity/controllers/spotify_controller.dart';
import 'package:spotivity/enums/animation_state.dart';
import 'package:spotivity/widgets/artist_list.dart';
import 'package:spotivity/widgets/artist_banner.dart';
import 'package:spotivity/widgets/artist_content.dart';
import 'package:spotivity/widgets/player_content.dart';
import 'package:spotivity/widgets/top_menu_left.dart';
import 'package:spotivity/widgets/search_bar.dart';

class StaggerAnimation extends StatelessWidget {
  final AnimationController controller;
  final SpotifyController spotifyController;
  final PlayerController playerController;
  final Animation<double> searchBar;
  final Animation<double> searchBarHorizontalSize;
  final Animation<double> artistListFadeIn;
  final Animation<double> artistListFadeOut;
  final Animation<double> openArtist;
  final Animation<double> artistContentFadeIn;
  final Animation<double> artistContentFadeOut;
  final Animation<double> openMusic;
  final TextEditingController textEditingController;

  StaggerAnimation(
      {required this.controller,
      required this.spotifyController,
      required this.playerController,
      required this.textEditingController,
      Key? key})
      : searchBar = Tween<double>(begin: 0.01, end: 0).animate(CurvedAnimation(
            parent: controller,
            curve: const Interval(0.0, 0.25, curve: Curves.linear))),
        artistListFadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: controller,
                curve: const Interval(0.0, 0.25, curve: Curves.linear))),
        searchBarHorizontalSize = Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: controller,
                curve: const Interval(0.3, 0.5, curve: Curves.linear))),
        artistListFadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
            CurvedAnimation(
                parent: controller,
                curve: const Interval(0.3, 0.5, curve: Curves.linear))),
        openArtist = Tween<double>(begin: 1.0, end: 0.0).animate(
            CurvedAnimation(
                parent: controller,
                curve: const Interval(0.3, 0.5, curve: Curves.linear))),
        artistContentFadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: controller,
                curve: const Interval(0.3, 0.6, curve: Curves.linear))),
        artistContentFadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
            CurvedAnimation(
                parent: controller,
                curve: const Interval(0.65, 0.8, curve: Curves.linear))),
        openMusic = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: controller,
            curve: const Interval(0.65, 1, curve: Curves.linear))),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: buildAnimation,
      animation: controller,
    );
  }

  Widget buildAnimation(BuildContext context, Widget? child) {
    animationController();
    return Stack(
      children: [
        ArtistList(artistListFadeIn, artistListFadeOut),
        SearchBar(
          searchBar,
          searchBarHorizontalSize,
          textEditingController,
        ),
        TopMenuLeft(artistListFadeOut),
        ArtistContent(artistContentFadeIn, artistContentFadeOut),
        Stack(
          children: [
            ArtistBanner(openArtist, openMusic),
          ],
        ),
        PlayerContent(openMusic),
      ],
    );
  }

  void animationController() {
    switch (spotifyController.state) {
      case AnimationState.searchClear_searched:
        if (searchBar.value == 0) {
          controller.stop();
          spotifyController.state = AnimationState.searched;
        }
        break;
      case AnimationState.searched_searchClear:
        if (searchBar.value == 0.5) {
          textEditingController.clear();
          spotifyController.state = AnimationState.searchClear;
        }
        break;
      case AnimationState.searched_openArtist:
        if (openArtist.value == 0) {
          controller.stop();
          spotifyController.state = AnimationState.openArtist;
        }
        break;
      case AnimationState.openArtist_searched:
        if (openArtist.value == 1) {
          controller.stop();
          spotifyController.state = AnimationState.searched;
        }
        break;
      case AnimationState.openArtist_openMusic:
        if (openMusic.value == 1) {
          spotifyController.state = AnimationState.openMusic;
        }
        break;
      case AnimationState.openMusic_openArtist:
        if (openMusic.value == 0) {
          controller.stop();
          spotifyController.state = AnimationState.openArtist;
          Future.delayed(const Duration(seconds: 5),
              () => playerController.stateController());
        }
        break;
      default:
        return;
    }
  }
}
