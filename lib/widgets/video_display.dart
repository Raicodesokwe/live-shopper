import 'package:flutter/material.dart';
import 'package:liveshopper/utils/app_color.dart';
import 'package:video_player/video_player.dart';

class VideoDisplay extends StatefulWidget {
  final String videoUrl;
  const VideoDisplay({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<VideoDisplay> createState() => _VideoDisplayState();
}

class _VideoDisplayState extends State<VideoDisplay> {
  late VideoPlayerController videoPlayerController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        videoPlayerController.play();
        videoPlayerController.setVolume(1);
        videoPlayerController.setLooping(true);
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      child: VideoPlayer(videoPlayerController),
    );
  }
}
