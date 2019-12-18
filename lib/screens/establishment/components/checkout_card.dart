import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:tablething/blocs/bloc.dart';
import 'package:tablething/components/card_widget.dart';
import 'package:tablething/components/edit_card_popup.dart';
import 'package:tablething/components/establishment_info.dart';
import 'package:tablething/components/popup_widget.dart';
import 'package:tablething/components/transparent_route.dart';
import 'package:tablething/localization/translate.dart';
import 'package:tablething/models/establishment/establishment.dart';
import 'package:tablething/services/stripe/payment_method.dart';
import 'package:tablething/services/tablething/order/order.dart';
import 'package:tablething/services/tablething/user.dart';
import 'package:tablething/theme/colors.dart';
import 'package:tablething/util/text_factory.dart';
import 'card_base.dart';

class CheckoutCard extends StatelessWidget {
  final Establishment establishment;
  final Order order;
  final User user;
  final String tableId;

  const CheckoutCard({Key key, this.establishment, this.order, this.user, this.tableId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardBase(
      child: Column(children: () {
        List<Widget> builder = [
          Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 25.0, bottom: 15.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    EstablishmentInfo(
                      establishment: establishment,
                      showDescription: false,
                      showRating: false,
                    ),
                  ],
                ),
                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      t('Checkout'),
                      style: TextFactory.h2Style,
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15.0),
                ),
                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      t('Order total'),
                      style: TextFactory.h4Style,
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // TODO Subtotal
                    Text(
                      establishment.formatCurrency(order.subtotal),
                      style: TextFactory.h3Style.copyWith(color: darkThemeColorGradient),
                    ),
                    Text(
                      t('Table: ') + tableId, // TODO takeaway
                      style: TextFactory.h3Style.copyWith(color: Colors.grey[500]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            // Credit card dimensions
            color: offWhiteColor,
            child: Container(
              padding: EdgeInsets.only(top: 25.0),
              decoration: BoxDecoration(
                color: Color(0xFFFEFEFE),
                borderRadius: BorderRadius.circular(32.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5.0,
                  ),
                ],
              ),
              child: BlocBuilder<PaymentMethodBloc, ProgressBlocState>(builder: (context, state) {
                return Column(
                  children: <Widget>[
                    Text(
                      t('Select a payment method'),
                      style: TextFactory.h3Style,
                    ),
                    Container(
                      height: (MediaQuery.of(context).size.width - 20.0) * 0.63 + 20.0,
                      child: FutureBuilder(
                        future: user.paymentMethods,
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Container(
                                color: Colors.transparent,
                                alignment: Alignment.center,
                                child: SpinKitPulse(
                                  color: mainThemeColor,
                                  size: 128,
                                ),
                              );
                            default:
                              if (snapshot.hasError)
                                // TODO error popup
                                return Container(color: Colors.red);
                              else {
                                List<dynamic> paymentMethods = List();
                                paymentMethods.addAll(snapshot.data);
                                paymentMethods.add(true);

                                return Swiper(
                                  onIndexChanged: (index) {
                                    if (paymentMethods[index] is PaymentMethod) {
                                      BlocProvider.of<OrderBloc>(context).add(ChangePaymentMethod(paymentMethods[index]));
                                    }
                                  },
                                  onTap: (index) {
                                    if (!(paymentMethods[index] is PaymentMethod)) {
                                      // New card
                                      BlocProvider.of<PaymentMethodBloc>(context).add(InitCard());

                                      Navigator.of(context).push(
                                        TransparentRoute(
                                          builder: (BuildContext context) => PopupWidget(
                                            child: EditCardPopup(
                                              onCloseTapped: () => Navigator.of(context).pop(),
                                            ),
                                            onCloseTapped: () => Navigator.of(context).pop(),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  itemBuilder: (BuildContext context, int index) {
                                    if (paymentMethods[index] is PaymentMethod) {
                                      return CardWidget(
                                        card: paymentMethods[index].card,
                                        padding: const EdgeInsets.only(bottom: 10.0, top: 10.0, left: 10.0, right: 10.0),
                                      );
                                    } else {
                                      // Add new card
                                      return Container(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: (Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius: BorderRadius.circular(12.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 5.0,
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.add,
                                                  color: Colors.grey[600],
                                                  size: 48.0,
                                                ),
                                                Text(
                                                  t('Tap to add a new \npayment method'),
                                                  style: TextFactory.h4Style.copyWith(color: Colors.grey[600]),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          )),
                                        ),
                                      );
                                    }
                                  },
                                  itemCount: paymentMethods.length,
                                  control: SwiperControl(
                                    color: mainThemeColor,
                                    padding: EdgeInsets.all(15.0),
                                    size: 20.0,
                                  ),
                                );
                              }
                          }
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ];

        builder.add(Container(
          height: 128.0,
        ));

        return builder;
      }()),
    );
  }
}
