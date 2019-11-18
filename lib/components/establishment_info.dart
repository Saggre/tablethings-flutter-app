import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
        _getCoverImage(),
        _getRatingBar(3.5),
        _getDescription(establishment),
        Padding(
          padding: EdgeInsets.only(top: 20),
        )
      ]),
    );
  }

  Widget _getDescription(Establishment establishment) {
    TextStyle textStyle = TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.w300,
    );

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: <Widget>[
          Text(establishment.description, style: textStyle),
          Text(establishment.priceDisplay, style: textStyle),
          Text('Aukioloajat', style: textStyle),
        ],
      ),
    );
  }

  Widget _getTitle() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        CircularImage(
          imageUrl: establishment.thumbUrl,
          size: 64,
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
        ),
        Text(
          establishment.name,
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  Widget _getRatingBar(double rating) {
    return RatingBar(
      initialRating: rating,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: 32,
      itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.orange,
      ),
      unratedColor: Colors.grey[600],
      onRatingUpdate: (rating) {
        print(rating);
      },
    );
  }

  Widget _getCoverImage() {
    return Container(
      child: Container(
          child: _getTitle(),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Colors.transparent,
              Colors.white,
            ],
            begin: FractionalOffset.lerp(FractionalOffset.topCenter, FractionalOffset.bottomCenter, 0.25),
            end: FractionalOffset.bottomCenter,
          ))),
      height: 180,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(
              establishment.imageUrl,
            ),
            fit: BoxFit.cover),
      ),
    );
  }
}
