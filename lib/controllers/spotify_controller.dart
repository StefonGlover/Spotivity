// ignore_for_file: prefer_const_declarations, avoid_print, invalid_return_type_for_catch_error, invalid_use_of_protected_member, duplicate_ignore, avoid_function_literals_in_foreach_calls, unnecessary_null_comparison, prefer_typing_uninitialized_variables

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spotify/spotify.dart';
import 'package:get/get.dart';
import 'package:spotivity/controllers/player_controller.dart';
import 'package:spotivity/enums/animation_state.dart';
import 'package:spotivity/enums/to.dart';
import 'package:spotivity/models/artist_model.dart';
import 'package:spotivity/views/home_view.dart';

class SpotifyController extends GetxController {
  late SpotifyApi spotify;
  final HomePageState applicationState;
  late Uri authUri;
  late var grant;
  late String responseUri;
  late String redirectUri;
  AnimationState state = AnimationState.searchClear;

  var artistList = <ArtistModel>[].obs;
  var artistOpened = Artist().obs;
  var topSongs = <Track>[].obs;
  var musicPlaying = Track().obs;

  SpotifyController(this.applicationState) {
    final credentials = SpotifyApiCredentials(
        dotenv.env['CLIENT_ID'], dotenv.env['CLIENT_SECRET']);
    final grant = SpotifyApi.authorizationCodeGrant(credentials);
    final redirectUri = 'https://example.com/auth';
    final scopes = ['user-read-email', 'user-library-read'];
    authUri = grant.getAuthorizationUrl(
      Uri.parse(redirectUri),
      scopes: scopes,
    );
    spotify = SpotifyApi(credentials);
  }

  String getDuration(Duration duration) {
    int min = duration.inMinutes;
    int sec = duration.inSeconds - (60 * duration.inMinutes);
    return "$min:${sec.toString().length == 1 ? '0$sec' : sec}";
  }

  void searchArtist(String artist) async {
    if (artist.isEmpty) {
      stateController(To.back);
      return;
    }
    var search = await spotify.search
        .get(artist, types: [SearchType.artist])
        .first(6)
        .catchError((err) => print((err as SpotifyException).message));
    artistList.value.clear();
    if (search == null) {
      artistList = <ArtistModel>[].obs;
    }
    search.forEach((pages) {
      pages.items!.forEach((item) {
        if (item is Artist) {
          // ignore: invalid_use_of_protected_member
          artistList.value.add(ArtistModel(
              item.id as String,
              item.name as String,
              item.href as String,
              item.type as String,
              item.uri as String,
              _transformImagesInList(item.images)));
        }
      });
    });

    update();
    if (state == AnimationState.searchClear) {
      stateController(To.go);
    } else {
      applicationState.setState(() {});
    }
  }

  void openArtist(String artistId) async {
    var search = await spotify.artists
        .get(artistId)
        .catchError((err) => print((err as SpotifyException).message));
    // ignore: unnecessary_null_comparison
    if (search == null) {
      return;
    }
    artistOpened.value = search;
    update();
    topMusicsOfArtist(artistId);
    if (state == AnimationState.searched) {
      stateController(To.go);
    } else {
      applicationState.setState(() {});
    }
  }

  void topMusicsOfArtist(String artistId) async {
    var search = await spotify.artists.getTopTracks(artistId, "us");
    topSongs.clear();
    search.forEach((track) {
      topSongs.add(track);
    });
    update();
  }

  void playMusic(Track track) async {
    print(track.isPlayable);
    print(track.previewUrl);
    if (track.previewUrl != null) {
      musicPlaying.call(track);
      Get.find<PlayerController>().play(url: track.previewUrl);
    }
    if (state == AnimationState.openArtist) {
      stateController(To.go);
    } else {
      applicationState.setState(() {});
    }
  }

  void stateController(To to) {
    switch (state) {
      case AnimationState.searchClear:
        if (to == To.go) {
          state = AnimationState.searchClear_searched;
          applicationState.animationController.forward();
        }
        break;
      case AnimationState.searched:
        if (to == To.go) {
          state = AnimationState.searched_openArtist;
          applicationState.animationController.forward();
        } else {
          state = AnimationState.searched_searchClear;
          applicationState.animationController.reverse();
        }
        break;
      case AnimationState.openArtist:
        if (to == To.go) {
          state = AnimationState.openArtist_openMusic;
          applicationState.animationController.forward();
        } else {
          state = AnimationState.openArtist_searched;
          applicationState.animationController.reverse();
        }
        break;
      case AnimationState.openMusic:
        if (to == To.back) {
          state = AnimationState.openMusic_openArtist;
          applicationState.animationController.reverse();
        }
        break;
      default:
        return;
    }
  }

  List<String> _transformImagesInList(images) {
    List<String> aux = <String>[];
    images.forEach((image) {
      aux.add(image.url);
    });
    return aux;
  }
}
