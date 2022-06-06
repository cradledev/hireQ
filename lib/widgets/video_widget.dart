import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import 'package:flick_video_player/flick_video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String url;
  final bool play;

  const VideoPlayerWidget({Key key, this.url, this.play}) : super(key: key);
  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  FlickManager flickManager;
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url);
    flickManager = FlickManager(
      videoPlayerController: _controller,
      autoPlay: false
    );
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() {});
    });

    if (widget.play) {
      flickManager.flickVideoManager.videoPlayerController.play();
      flickManager.flickVideoManager.videoPlayerController.setLooping(true);
      // _controller.play();
      // _controller.setLooping(true);
    }
  }

  @override
  void didUpdateWidget(VideoPlayerWidget oldWidget) {
    if (oldWidget.play != widget.play) {
      if (widget.play) {
        flickManager.flickVideoManager.videoPlayerController.play();
        flickManager.flickVideoManager.videoPlayerController.setLooping(true);
        // _controller.play();
        // _controller.setLooping(true);
      } else {
        flickManager.flickVideoManager.videoPlayerController.pause();
        // _controller.pause();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // _controller.dispose();
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // return ClipRRect(
          //     borderRadius: BorderRadius.circular(5),
          //     child: VideoPlayer(_controller));
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: FlickVideoPlayer(
              flickManager: flickManager,
              preferredDeviceOrientation: const [
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown
              ],
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator.adaptive(
                // strokeWidth: 4,
                // color: Colors.white,
                ),
          );
        }
      },
    );
  }
}
