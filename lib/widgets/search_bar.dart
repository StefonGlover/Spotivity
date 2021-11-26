import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotivity/controllers/spotify_controller.dart';

class SearchBar extends StatelessWidget {
  final Animation animation;
  final Animation searchBarHorizontalSize;
  final TextEditingController _textController;

  const SearchBar(
      this.animation, this.searchBarHorizontalSize, this._textController,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.88;
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: (animation.value + 0.01) * height,
            horizontal: (searchBarHorizontalSize.value * 100) + 10),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: TextField(
          controller: _textController,
          decoration: const InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.only(bottom: 11, top: 4),
              icon: Icon(Icons.person_search_sharp, color: Colors.black),
              labelText: "Artist",
              labelStyle: TextStyle(color: Colors.black)),
          style: const TextStyle(color: Colors.black),
          onSubmitted: (value) =>
              Get.find<SpotifyController>().searchArtist(value),
        ),
      ),
    );
  }
}
