import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tablething/blocs/bloc.dart';
import 'package:tablething/components/colored_safe_area.dart';
import 'package:tablething/models/persistent_data.dart';
import 'package:tablething/theme/theme.dart';
import 'package:flutter/material.dart';

class PaymentMethodScreen extends StatefulWidget {
  PaymentMethodScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PaymentMethodScreenState();
  }
}

class PaymentMethodScreenState extends State<PaymentMethodScreen> {
  @override
  void initState() {
    super.initState();

    () async {
      await Future.delayed(Duration.zero);

      /// TODO check if logged in
      BlocProvider.of<PaymentMethodBloc>(context).add(
        GetPaymentMethods(BlocProvider.of<AuthBloc>(context).currentUser),
      );
    }();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredSafeArea(
      color: mainThemeColor,
      child: Scaffold(
        body: BlocBuilder<PaymentMethodBloc, BlocState>(builder: (context, state) {
          if (state is PaymentMethodsOverview) {
            return ListView(
              children: () {
                List<Widget> builder = List();

                state.paymentMethods.forEach((paymentMethod) {
                  builder.add(Container(
                    child: Text(paymentMethod.card.last4),
                  ));
                });

                return builder;
              }(),
            );
          }

          return Container(
            color: Colors.pink,
          );
        }),
      ),
    );
  }
}
