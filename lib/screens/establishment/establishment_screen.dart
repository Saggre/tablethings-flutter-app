import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tablething/blocs/bloc.dart';
import 'package:tablething/components/layered_button_group/layered_button_group.dart';
import 'package:tablething/models/persistent_data.dart';
import 'package:tablething/components/buttons/dual_button.dart';
import 'package:tablething/components/colored_safe_area.dart';
import 'package:tablething/components/establishment_image.dart';
import 'package:tablething/components/main_app_bar.dart';
import 'package:tablething/localization/translate.dart';
import 'package:tablething/screens/establishment/components/shopping_basket_card.dart';
import 'package:tablething/screens/establishment/components/dropdown_menu.dart';
import 'package:tablething/services/tablething/order/order_item.dart';
import 'package:tablething/theme/colors.dart';
import 'package:tablething/util/text_factory.dart';
import 'components/checkout_card.dart';
import 'components/establishment_card.dart';
import 'components/order_item_card.dart';

/// A route for a single establishment showing its info, menu, etc
class EstablishmentScreen extends StatefulWidget {
  static const routeName = '/establishmentScreen';

  EstablishmentScreen({Key key}) : super(key: key);

  @override
  EstablishmentScreenState createState() {
    return EstablishmentScreenState();
  }
}

class EstablishmentScreenState extends State<EstablishmentScreen> {
  var orderQuantityController = DropdownMenuController<int>();

  @override
  void initState() {
    super.initState();

    // Delayed to after context is initialized
    () async {
      await Future.delayed(Duration.zero);
      //final EstablishmentScreenArguments args = ModalRoute.of(context).settings.arguments;

      // TODO handle errors (if there is no establishment)
      // Get establishment
      print("Getting establishment: " + Provider.of<PersistentData>(context).selectedEstablishment.getFetchId());
      BlocProvider.of<OrderBloc>(context).add(
        GetEstablishmentEvent(Provider.of<PersistentData>(context).selectedEstablishment),
      );
    }();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredSafeArea(
      color: mainThemeColor,
      child: Scaffold(
        backgroundColor: offWhiteColor,
        body: Stack(
          children: <Widget>[
            BlocBuilder<OrderBloc, OrderBlocState>(
              builder: (context, state) {
                Widget built = Container(
                  color: Colors.red,
                );

                if (state.error) {
                  // TODO handle error
                }

                if (state is LoadingState) {
                  // TODO loading
                  return CircularProgressIndicator(value: null);
                } else if (state is EstablishmentState) {
                  print("Successfully got establishment: " + state.establishment.name);
                  built = EstablishmentCard(
                    key: ValueKey('EstablishmentCard'),
                    establishment: state.establishment,
                    menu: state.menu,
                  );
                } else if (state is OrderItemState) {
                  built = OrderItemCard(
                    key: ValueKey('OrderItemCard'),
                    establishment: state.establishment,
                    orderItem: state.orderItem,
                    controller: orderQuantityController,
                  );
                } else if (state is ShoppingBasketState) {
                  built = ShoppingBasketCard(
                    key: ValueKey('ShoppingBasketCard'),
                    establishment: state.establishment,
                    order: state.order,
                  );
                } else if (state is CheckoutState) {
                  built = CheckoutCard(
                    key: ValueKey('CheckoutCard'),
                    paymentMethod: state.paymentMethod,
                    establishment: state.establishment,
                    order: state.order,
                  );
                }

                return WillPopScope(
                  onWillPop: () async {
                    _backAction(state);
                    return false;
                  },
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                          top: 24,
                        ),
                        width: double.infinity,
                        color: darkThemeColor,
                        child: ClipRRect(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(32.0),
                            topLeft: Radius.circular(32.0),
                          ),
                          child: Stack(
                            children: <Widget>[
                              EstablishmentImage(imageUrl: state.establishment.imageUrl, height: 160.0),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 152.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: offWhiteColor,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(32.0),
                              topLeft: Radius.circular(32.0),
                            ),
                          ),
                        ),
                      ),
                      AnimatedSwitcher(
                        key: ValueKey('AnimatedSwitcher'),
                        child: built,
                        duration: Duration(milliseconds: 300),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            child: child,
                            opacity: animation,
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            _getButtons(),
            MainAppBar(),
          ],
        ),
      ),
    );
  }

  void _backAction(OrderBlocState currentState) {
    // TODO go back
    print("BACK");
    if (currentState is OrderItemState) {
      BlocProvider.of<OrderBloc>(context).add(
        ForgetOrderItemEvent(currentState.orderItem),
      );
      return;
    } else if (currentState is ShoppingBasketState) {
      BlocProvider.of<OrderBloc>(context).add(
        RequestMenuEvent(),
      );
      return;
    } else if (currentState is CheckoutState) {
      BlocProvider.of<OrderBloc>(context).add(
        RequestShoppingBasketEvent(),
      );
      return;
    }

    // TODO add check
    Navigator.pop(context);
  }

  Widget _getButtons() {
    /// On checkout button press
    void checkoutPressed(ShoppingBasketState state) {
      BlocProvider.of<OrderBloc>(context).add(
        // TODO check user is logged in
        RequestCheckoutEvent(state.order, BlocProvider.of<AuthBloc>(context).currentUser),
      );
    }

    return Flex(
      direction: Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        BlocBuilder<OrderBloc, OrderBlocState>(builder: (context, state) {
          if (state is EstablishmentState) {
            return DualButton(
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
                  _backAction(state);
                },
              ),
              rightButtonProperties: SingleButtonProperties(
                text: t('My order'),
                textStyle: TextFactory.buttonStyle,
                colors: [
                  mainThemeColor,
                ],
                borderRadius: BorderRadius.circular(32.0),
                onPressed: () {
                  BlocProvider.of<OrderBloc>(context).add(
                    RequestShoppingBasketEvent(),
                  );
                },
              ),
            );
          } else if (state is OrderItemState) {
            return DualButton(
              properties: DualButtonProperties(
                separatorDirection: DualButtonSeparatorDirection.rightHand,
              ),
              rightButtonProperties: SingleButtonProperties(
                text: t('Choose'),
                textStyle: TextFactory.buttonStyle,
                colors: [
                  mainThemeColor,
                ],
                borderRadius: BorderRadius.circular(32.0),
                onPressed: () {
                  // Add to order
                  BlocProvider.of<OrderBloc>(context).add(
                    AddOrderItemEvent(state.orderItem, OrderItemOptions(quantity: orderQuantityController.currentValue)),
                  );
                },
              ),
              leftButtonProperties: SingleButtonProperties(
                text: t('Cancel'),
                textStyle: TextFactory.buttonStyle,
                colors: [
                  darkThemeColorGradient,
                  darkThemeColor,
                ],
                iconData: Icons.arrow_back,
                borderRadius: BorderRadius.circular(32.0),
                iconPosition: ButtonIconPosition.beforeText,
                onPressed: () {
                  _backAction(state);
                },
              ),
            );
          } else if (state is ShoppingBasketState) {
            if (state.order.items.length > 0) {
              return LayeredButtonGroup(
                onTap: () {
                  checkoutPressed(state);
                },
                buttonText: t('Checkout'),
                subMenu: Stack(
                  children: <Widget>[
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
                          _backAction(state);
                        },
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: GestureDetector(
                        child: Container(
                          color: Colors.transparent,
                        ),
                        onTap: () {
                          checkoutPressed(state);
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          }

          return DualButton(
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
                _backAction(state);
              },
            ),
          );
        }),
      ],
    );
  }
}
