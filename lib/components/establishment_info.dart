import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tablething/models/establishment/establishment.dart';
import 'package:tablething/util/text_factory.dart';

class EstablishmentInfo extends StatelessWidget {
  final Establishment establishment;
  final Widget child;
  final bool showTitle;
  final bool showRating;
  final bool showDescription;

  const EstablishmentInfo({
    Key key,
    @required this.establishment,
    this.child,
    this.showDescription = true,
    this.showRating = true,
    this.showTitle = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: () {
            List<Widget> builder = List();

            if (showTitle) {
              builder.add(_getTitle());
            }

            if (showDescription) {
              builder.add(_getDescription(context));
            }

            if (showRating) {
              builder.add(_getRating());
            }

            if (child != null) {
              builder.add(child);
            }

            return builder;
          }()),
    );
  }

  Widget _getDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: RichText(
        text: TextSpan(
          style: TextFactory.pStyle,
          text: establishment.description,
        ),
      ),
    );
  }

  Widget _getRating() {
    // TODO get rating
    double rating = 4.4;
    int reviews = 256;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          rating.toString(),
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        Padding(padding: EdgeInsets.only(left: 5.0)),
        RatingBar(
          ignoreGestures: true,
          initialRating: rating,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: 25,
          itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amberAccent,
          ),
          unratedColor: Colors.grey[600],
          onRatingUpdate: (rating) {
            print(rating);
          },
        ),
        Padding(padding: EdgeInsets.only(left: 10.0)),
        Text(
          reviews.toString(),
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
        )
      ],
    );
  }

  /// Business hours
  Widget _getHours() {
    TextStyle textStyle = TextStyle(
      color: Colors.grey[500],
      fontSize: 15,
      fontWeight: FontWeight.w400,
    );

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: <Widget>[
          // TODO replace with textfactory
          Text(establishment.description, style: textStyle),
          Text(establishment.priceDisplay, style: textStyle),
          Text('Aukioloajat', style: textStyle),
        ],
      ),
    );
  }

  Widget _getTitle() {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextFactory.h1(establishment.name),
        ],
      ),
    );
  }
}
