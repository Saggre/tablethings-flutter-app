import 'package:credit_card_slider/card_background.dart';
import 'package:credit_card_slider/card_company.dart';
import 'package:credit_card_slider/card_network_type.dart';
import 'package:credit_card_slider/credit_card_widget.dart';
import 'package:credit_card_slider/validity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tablethings/blocs/cart/cart_bloc.dart';
import 'package:tablethings/blocs/cart/cart_bloc_states.dart';

class CheckoutScreen extends StatelessWidget {
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
              CreditCard(
                cardBackground: SolidColorCardBackground(Colors.purple),
                cardNetworkType: CardNetworkType.visaBasic,
                cardHolderName: 'Joni Pusenius',
                cardNumber: '1234 **** **** ****',
                company: CardCompany.sbi,
                validity: Validity(
                  validThruMonth: 1,
                  validThruYear: 21,
                  validFromMonth: 1,
                  validFromYear: 16,
                ),
              ),
            ],
          );
        }

        return Text('Error');
      },
    );
  }
}
