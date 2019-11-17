import 'package:flutter/widgets.dart';

class CircularImage extends StatelessWidget {
  final String imageUrl;
  final double size;

  const CircularImage({Key key, @required this.imageUrl, this.size = 100}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: new Container(
          width: size,
          height: size,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(fit: BoxFit.cover, image: new NetworkImage(imageUrl)),
          )),
    );
  }
}
