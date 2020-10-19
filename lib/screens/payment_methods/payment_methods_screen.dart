import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tablethings/blocs/auth/auth_bloc.dart';
import 'package:tablethings/blocs/auth/auth_bloc_events.dart';
import 'package:tablethings/blocs/auth/auth_bloc_states.dart';
import 'package:tablethings/blocs/navigation/navigation_bloc.dart';
import 'package:tablethings/blocs/navigation/navigation_bloc_events.dart';
import 'package:tablethings/blocs/navigation/navigation_bloc_states.dart';

import 'components/card_form.dart';

class PaymentMethodsScreen extends StatelessWidget {
  PaymentMethodsScreen();

  final formKey = GlobalKey<FormState>();
  final card = Card();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthBlocState>(
      builder: (context, authState) {
        return BlocBuilder<NavigationBloc, NavigationBlocState>(
          builder: (context, navState) {
            if (navState is BrowsePaymentMethodsView) {
              return Column(
                children: [
                  RaisedButton(
                    onPressed: () {
                      BlocProvider.of<NavigationBloc>(context).add(ViewAddPaymentMethod());
                    },
                    child: Text('Add card'),
                  )
                ],
              );
            } else if (navState is AddPaymentMethodView) {
              return Column(
                children: [
                  CreditCardForm(
                    key: formKey,
                  ),
                  RaisedButton(
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        formKey.currentState.save();
                        //BlocProvider.of<AuthBloc>(context).add(AddPaymentMethod(card));
                        BlocProvider.of<NavigationBloc>(context).add(ViewBrowsePaymentMethods());
                      }
                    },
                    child: Text('Add card'),
                  )
                ],
              );
            }

            return Text('Error');
          },
        );
      },
    );
  }
}
