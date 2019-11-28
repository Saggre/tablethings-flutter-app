import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tablething/models/establishment/establishment.dart';
import 'package:tablething/theme/colors.dart';

/// An app bar specific to the establishment screen
class EstablishmentAppBar extends StatelessWidget {
  final Establishment establishment;
  final double expandedHeight;

  EstablishmentAppBar({
    Key key,
    @required this.establishment,
    this.expandedHeight = 152,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: mainThemeColor,
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
      expandedHeight: expandedHeight,
      flexibleSpace: FlexibleSpaceBar(
        background: Image.network(
          establishment.imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
