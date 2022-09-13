import 'package:flutter/material.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeCard extends StatefulWidget {
  YoutubeCard({Key key, this.videoLink, this.index}) : super(key: key);
  final String videoLink;
  final int index;
  @override
  _YoutubeCardState createState() => _YoutubeCardState();
}

class _YoutubeCardState extends State<YoutubeCard>
    with AutomaticKeepAliveClientMixin {
  YoutubePlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = new YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoLink),
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        loop: true,
        disableDragSeek: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxwidth = MediaQuery.of(context).size.width;
    final themeManager = getThemeManager(context).isDarkMode;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Positioned(
        //   bottom: -22,
        //   right: maxwidth * 0.09,
        //   child: Material(
        //     shadowColor: Colors.white,
        //     elevation: 5,
        //     child: Container(
        //         width: 70,
        //         height: 25,
        //         color: themeManager ? Colors.black : Colors.white,
        //         alignment: Alignment.center,
        //         child: FlatButton(
        //           onPressed: () {
        //             launch(widget.videoLink);
        //           },
        //           color: themeManager ? Colors.black : Colors.white,
        //           child: Text(
        //             "Visit",
        //             style: TextStyle(
        //                 color: !themeManager ? Colors.black : Colors.white,
        //                 fontWeight: FontWeight.w500),
        //           ),
        //         )),
        //   ),
        // ),
        VisibilityDetector(
          key: Key("unique key ${widget.index}"),
          onVisibilityChanged: (VisibilityInfo info) {
            // debugPrint("${info.visibleFraction} of my widget is visible");
            if (info.visibleFraction <= 0.5) {
              // print("Herer ${widget.index}");
              // print(_controller.value.isPlaying);
              if (_controller.value.isPlaying) {
                _controller.pause();
              }
            }
            // else {
            //   _controller.play();
            // }
          },
          child: Container(
            height: 184,
            width: MediaQuery.of(context).orientation == Orientation.portrait
                ? maxwidth / 1.1
                : maxwidth * 0.6,
            decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.circular(28),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30)),
              child: YoutubePlayer(
                controller: _controller,
                // width: 150,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.amber,
                progressColors: ProgressBarColors(
                  playedColor: Colors.amber,
                  handleColor: Colors.amberAccent,
                ),
                onReady: () {
                  _controller.addListener(() {});
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

// bottomActions: [
//   Expanded(
//     child: Container(
//       padding: const EdgeInsets.symmetric(
//           horizontal: 10, vertical: 2),
//       color: Colors.black26,
//       margin: EdgeInsets.only(bottom: 10),
//       child: ProgressBar(
//         colors: ProgressBarColors(
//             playedColor: Colors.amber,
//             handleColor: Colors.amberAccent,
//             bufferedColor: Colors.grey[800],
//             backgroundColor: Colors.grey[200]),
//       ),
//     ),
//   )
// ],
