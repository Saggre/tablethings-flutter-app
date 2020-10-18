import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tablethings/blocs/auth/auth_bloc.dart';
import 'package:tablethings/blocs/auth/auth_bloc_states.dart';
import 'package:tablethings/blocs/auth/auth_levels.dart';
import 'package:tablethings/blocs/cart/cart_bloc.dart';
import 'package:tablethings/blocs/cart/cart_bloc_states.dart';
import 'package:tablethings/blocs/navigation/navigation_bloc.dart';
import 'package:tablethings/blocs/navigation/navigation_bloc_events.dart';
import 'package:tablethings/blocs/qr_scan/qr_scan_bloc.dart';
import 'package:tablethings/blocs/qr_scan/qr_scan_bloc_states.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartBlocState>(
      builder: (context, state) {
        if (state is CartItems) {
          return Column(
            children: [
              Expanded(
                child: ListView(children: () {
                  var list = List<Widget>();
                  state.items.forEach((item, count) {
                    list.add(Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(item.name),
                          Text(count.toString()),
                        ],
                      ),
                    ));
                  });

                  return list;
                }()),
              ),
              BlocBuilder<AuthBloc, AuthBlocState>(
                builder: (context, state) {
                  return RaisedButton(
                    onPressed: () {
                      if (state.authLevel >= AuthLevel.normalAuth) {
                        BlocProvider.of<NavigationBloc>(context).add(ViewCheckout());
                        return;
                      }

                      BlocProvider.of<NavigationBloc>(context).add(ViewLoginAuth(AuthLevel.normalAuth, ViewCheckout()));
                    },
                    child: Text('Checkout'),
                  );
                },
              )
            ],
          );
        }

        return Text('Error');
      },
    );
  }
}
