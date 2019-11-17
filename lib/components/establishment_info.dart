import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tablething/services/establishment.dart';
import 'package:tablething/theme/theme.dart';

import 'circular_image.dart';

class EstablishmentInfo extends StatelessWidget {
  final Establishment establishment;

  const EstablishmentInfo({
    Key key,
    this.establishment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: <Widget>[
        Stack(
          children: [
            _getCoverImage(),
            Column(
              children: <Widget>[
                CircularImage(
                  imageUrl: establishment.thumbUrl,
                  size: 100,
                ),
                Text(
                  establishment.name,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            )
          ],
        ),
      ]),
    );
  }

  Widget _getCoverImage() {
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
          begin: Alignment.center,
          end: Alignment.bottomCenter,
          colors: [Colors.black, Colors.transparent],
        ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
      },
      blendMode: BlendMode.dstIn,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                establishment.imageUrl,
              ),
              fit: BoxFit.cover),
        ),
      ),
    );
  }
}
