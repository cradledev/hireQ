import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageGradientOverlay extends StatefulWidget {
  const ImageGradientOverlay({Key key, this.imageUrl}) : super(key: key);
  final String imageUrl;

  @override
  ImageGradientOverlayState createState() => ImageGradientOverlayState();
}

class ImageGradientOverlayState extends State<ImageGradientOverlay> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: CachedNetworkImage(
            imageUrl: widget.imageUrl,
            progressIndicatorBuilder: (context, url, downloadProgress) {
              return Center(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                      value: downloadProgress.progress),
                ),
              );
            },
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.cover,
          ),
          // child: Image.network(
          //   widget.imageUrl,
          //   fit: BoxFit.cover,
          // ),
        ),
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(10, 16, 63, 0.0),
                    Color.fromRGBO(57, 35, 81, 0.3),
                    Color.fromRGBO(57, 35, 81, 0.6),
                    Color.fromRGBO(57, 35, 81, 0.9)
                  ],
                  stops: [0.0, 0.2, 0.6867, 0.9913],
                ),
                borderRadius: BorderRadius.all(Radius.circular(12))),
          ),
        ),
      ],
    );
  }
}
