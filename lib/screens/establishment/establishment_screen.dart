import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tablething/blocs/auth/auth_bloc_states.dart';
import 'package:tablething/blocs/bloc.dart';
import 'package:tablething/components/layered_button_group/layered_button_group.dart';
import 'package:tablething/components/login_popup.dart';
import 'package:tablething/components/popup_widget.dart';
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
            BlocBuilder<OrderBloc, BlocState>(
              builder: (context, state) {
                Widget built = Container(
                  color: Colors.red,
                );

                if (state is EstablishmentState) {
                  built = EstablishmentCard(
                    key: ValueKey('EstablishmentCard'),
                    establishment: state.establishment,
                    menu: state.establishment.menu,
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
                    tableId: state.tableId,
                    order: state.order,
                  );
                } else if (state is CheckoutState) {
                  built = BlocBuilder<AuthBloc, BlocState>(builder: (context, authState) {
                    if (authState is Authenticated) {
                      return CheckoutCard(
                        key: ValueKey('CheckoutCard'),
                        establishment: state.establishment,
                        order: state.order,
                        tableId: state.tableId,
                        user: authState.user,
                      );
                    }

                    return Stack(
                      children: <Widget>[
                        ShoppingBasketCard(
                          key: ValueKey('ShoppingBasketCard'),
                          establishment: state.establishment,
                          order: state.order,
                          tableId: state.tableId,
                        ),
                        PopupWidget(
                          child: LoginPopup(
                            authState: authState,
                            description: t('You need to login to proceed \nwith your order.'),
                            onCloseTapped: () => {},
                          ),
                          onCloseTapped: () => {},
                        ),
                      ],
                    );
                  });
                }

                if (state is LoadingState) {
                  return Container(
                    color: offWhiteColor,
                    alignment: Alignment.center,
                    child: SpinKitPulse(
                      color: mainThemeColor,
                      size: 128,
                    ),
                  );
                } else if (state is OrderBlocState) {
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
                }

                // TODO return error popup
                return Container(color: Colors.red);
              },
            ),
            _getButtons(),
            MainAppBar(),
          ],
        ),
      ),
    );
  }

  void _backAction(BlocState currentState) {
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
        RequestCheckoutEvent(state.order, BlocProvider.of<AuthBloc>(context).currentUser),
      );
    }

    return Flex(
      direction: Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        BlocBuilder<OrderBloc, BlocState>(builder: (context, state) {
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
          } else if (state is CheckoutState) {
            return DualButton(
              properties: DualButtonProperties(
                separatorDirection: DualButtonSeparatorDirection.rightHand,
              ),
              rightButtonProperties: SingleButtonProperties(
                text: t('Order'),
                textStyle: TextFactory.buttonStyle,
                colors: [
                  Colors.grey,
                ],
                borderRadius: BorderRadius.circular(32.0),
                onPressed: () {},
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
