import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:tablething/blocs/bloc.dart';
import 'package:tablething/components/buttons/dual_button.dart';
import 'package:tablething/components/colored_safe_area.dart';
import 'package:tablething/localization/translate.dart';
import 'package:tablething/models/persistent_data.dart';
import 'package:tablething/screens/payment_method/components/card_widget.dart';
import 'package:tablething/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:tablething/util/text_factory.dart';

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
        body: Stack(
          alignment: Alignment.bottomLeft,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
              decoration: BoxDecoration(
                color: mainThemeColor,
              ),
              child: BlocBuilder<PaymentMethodBloc, BlocState>(builder: (context, state) {
                if (state is PaymentMethodsOverview) {
                  return ListView(
                    children: <Widget>[
                      Container(
                        height: (MediaQuery.of(context).size.width - 40.0) * 0.63 + 100.0,
                        child: Swiper(
                          itemBuilder: (BuildContext context, int index) {
                            return CardWidget(
                              card: state.paymentMethods[index].card,
                              padding: EdgeInsets.only(bottom: 50.0, top: 50.0, left: 20.0, right: 20.0),
                            );
                          },
                          itemCount: state.paymentMethods.length,
                          control: SwiperControl(
                            color: darkThemeColor,
                          ),
                        ),
                      ),
                      Container(
                        height: 64,
                      ),
                    ],
                  );
                }

                return Container(
                  color: Colors.pink,
                );
              }),
            ),
            DualButton(
              properties: DualButtonProperties(
                separatorDirection: DualButtonSeparatorDirection.rightHand,
              ),
              leftButtonProperties: SingleButtonProperties(
                text: t('Back'),
                textStyle: TextFactory.buttonStyle,
                colors: [
                  darkThemeColorGradient,
                  darkThemeColor,
                ],
                iconData: Icons.arrow_back,
                borderRadius: BorderRadius.circular(32.0),
                iconPosition: ButtonIconPosition.beforeText,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
