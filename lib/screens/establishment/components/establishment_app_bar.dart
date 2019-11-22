import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tablething/models/establishment/establishment.dart';
import 'package:tablething/theme/colors.dart';

/// An app bar specific to the establishment screen
class EstablishmentAppBar extends StatelessWidget {
  final Establishment establishment;

  EstablishmentAppBar({
    Key key,
    @required this.establishment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: appColors[0],
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.accessible_forward),
          tooltip: 'Add new entry',
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.accessible),
          tooltip: 'Add new entry',
          onPressed: () {},
        ),
      ],
      pinned: true,
      expandedHeight: 200.0,
      flexibleSpace: FlexibleSpaceBar(
        background: Image.network(
          establishment.imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
