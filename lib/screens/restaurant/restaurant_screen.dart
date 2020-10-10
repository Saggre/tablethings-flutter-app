import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tablethings/blocs/cart/cart_bloc.dart';
import 'package:tablethings/blocs/cart/cart_bloc_events.dart';
import 'package:tablethings/blocs/session/session_bloc.dart';
import 'package:tablethings/blocs/session/session_bloc_states.dart';
import 'package:tablethings/models/tablethings/restaurant/menu/menu.dart';
import 'package:tablethings/models/tablethings/restaurant/restaurant.dart';

class RestaurantScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionBlocState>(
      builder: (context, state) {
        if (state is PhysicallyPresent) {
          Restaurant restaurant = state.restaurant;
          Menu menu = state.menu;

          return Column(
            children: [
              Image.network(
                restaurant.thumbnail,
              ),
              Text(restaurant.name),
              Text(restaurant.description),
              Expanded(
                child: ListView(children: () {
                  var list = List<Widget>();

                  menu.sections.forEach((section) {
                    list.add(Container(
                      height: 50,
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          //Text(section.name),
                          //Text(section.description),
                        ],
                      ),
                    ));

                    section.items.forEach((item) {
                      list.add(Container(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(item.name),
                            Flexible(child: Text(item.description)),
                            Text(item.price.toString()),
                            RaisedButton(
                              key: Key(item.id),
                              onPressed: () {
                                BlocProvider.of<CartBloc>(context).add(AddItem(item));
                              },
                              child: Text('Add to cart', style: TextStyle(fontSize: 20)),
                            ),
                          ],
                        ),
                      ));
                    });
                  });

                  return list;
                }()),
              )
            ],
          );
        }

        return Text('Not present'); // TODO not present
      },
    );
  }
}
