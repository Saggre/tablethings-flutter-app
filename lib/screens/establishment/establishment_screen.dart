import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tablething/blocs/bloc.dart';
import 'package:tablething/blocs/order/order_bloc_events.dart';
import 'package:tablething/blocs/order/order_bloc_states.dart';
import 'package:tablething/components/layered_button_group/layered_button_group.dart';
import 'package:tablething/models/establishment/menu/menu.dart';
import 'package:tablething/models/persistent_data.dart';
import 'package:tablething/components/buttons/dual_button.dart';
import 'package:tablething/components/colored_safe_area.dart';
import 'package:tablething/components/establishment_image.dart';
import 'package:tablething/components/establishment_info.dart';
import 'package:tablething/components/main_app_bar.dart';
import 'package:tablething/localization/translate.dart';
import 'package:tablething/models/establishment/establishment.dart';
import 'package:tablething/models/establishment/order/order.dart';
import 'package:tablething/models/establishment/order/order_item.dart';
import 'package:tablething/screens/establishment/components/dropdown_menu.dart';
import 'package:tablething/theme/colors.dart';
import 'package:tablething/util/text_factory.dart';
import 'components/menu_view/menu_view.dart';

import 'components/menu_view/menu_view_item.dart';

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
  var orderQuantityController = DropdownMenuController<String>();

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
                if (state.error) {
                  // TODO handle error
                }

                if (state is LoadingState) {
                  // TODO loading
                  return CircularProgressIndicator(value: null);
                } else if (state is EstablishmentState) {
                  print("Successfully got establishment: " + state.establishment.name);

                  return _getFrame(
                    _getEstablishmentView(state),
                    state.establishment.imageUrl,
                  );
                } else if (state is OrderItemState) {
                  return WillPopScope(
                    onWillPop: () async {
                      _backAction(state);
                      return false;
                    },
                    child: _getFrame(
                      _getOrderItemView(state.establishment, state.orderItem),
                      state.establishment.imageUrl,
                    ),
                  );
                } else if (state is ShoppingBasketState) {
                  return WillPopScope(
                    onWillPop: () async {
                      _backAction(state);
                      return false;
                    },
                    child: _getFrame(
                      _getShoppingBasketView(state.establishment, state.order),
                      state.establishment.imageUrl,
                    ),
                  );
                }

                return Container(
                  color: Colors.red,
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
    }

    // TODO add check
    Navigator.pop(context);
  }

  Widget _getButtons() {
    /// On checkout button press
    void checkoutPressed(ShoppingBasketState state) {
      BlocProvider.of<OrderBloc>(context).add(
        RequestCheckoutEvent(state.order),
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
                    AddOrderItemEvent(state.orderItem, OrderItemOptions(quantity: int.tryParse(orderQuantityController.currentValue))),
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

  /// A frame which can show variable scroll views inside itself
  Widget _getFrame(Widget child, String imageUrl) {
    return Stack(
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
                EstablishmentImage(imageUrl: imageUrl, height: 160.0),
              ],
            ),
          ),
        ),
        ListView(children: <Widget>[
          Container(
            height: 152,
          ),
          _getCard(
            AnimatedSwitcher(
              key: ValueKey('AnimatedSwitcher'),
              child: child,
              duration: Duration(milliseconds: 400),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return SlideTransition(
                    child: child,
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 1.0),
                      end: Offset.zero,
                    ).animate(animation));
              },
            ),
          ),
        ])
      ],
    );
  }

  Widget _getCard(Widget child) {
    return ClipRRect(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(32.0),
        topLeft: Radius.circular(32.0),
      ),
      child: Container(
        color: offWhiteColor,
        child: child,
      ),
    );
  }

  /// Shopping basket view with all order items
  Widget _getShoppingBasketView(Establishment establishment, Order<MenuItem> order) {
    return Column(
        key: ValueKey('ShoppingBasketView'),
        children: () {
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
                        t('Your order'),
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
                        Provider.of<PersistentData>(context).selectedTableId, // TODO takeaway
                        style: TextFactory.h3Style.copyWith(color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ];

          order.items.forEach((orderItem) {
            builder.add(
              Container(
                color: offWhiteColor,
                child: Container(
                  decoration: BoxDecoration(
                    color: offWhiteColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(32.0),
                      topLeft: Radius.circular(32.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5.0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: MenuViewItem(
                      menuItem: orderItem.product,
                      establishment: establishment,
                      onPress: (MenuItem menuItem) {
                        BlocProvider.of<OrderBloc>(context).add(
                          RemoveOrderItemEvent(orderItem),
                        );
                      },
                      buttonStyle: MenuViewItemButtonStyle.remove,
                      wholeAreaIsClickable: false,
                      descriptionPadding: 15.0,
                      imageRadius: BorderRadius.only(bottomLeft: Radius.circular(32.0), topRight: Radius.circular(32.0)),
                    ),
                  ),
                ),
              ),
            );

            builder.add(Container(
              color: offWhiteColor,
              padding: EdgeInsets.only(bottom: 15.0),
            ));
          });

          builder.add(
            GestureDetector(
              onTap: () {
                BlocProvider.of<OrderBloc>(context).add(
                  RequestMenuEvent(),
                );
              },
              child: Container(
                color: offWhiteColor,
                child: Container(
                  decoration: BoxDecoration(
                    color: offWhiteColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(32.0),
                      topLeft: Radius.circular(32.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5.0,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 60.0),
                  child: Center(
                    child: Text(
                      t('+ Add more items'),
                      style: TextFactory.h2Style.copyWith(color: Colors.grey[500]),
                    ),
                  ),
                ),
              ),
            ),
          );

          builder.add(Container(
            height: 128.0,
            color: offWhiteColor,
          ));

          return builder;
        }());
  }

  /// Added order item view
  Widget _getOrderItemView(Establishment establishment, OrderItem<MenuItem> orderItem) {
    return Column(
      key: ValueKey('OrderItemView'),
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 15.0),
          child: MenuViewItem(
            menuItem: orderItem.product,
            establishment: establishment,
            onPress: () {},
            buttonStyle: MenuViewItemButtonStyle.none,
            descriptionPadding: 25.0,
          ),
        ),
        DropdownMenu(
          controller: orderQuantityController,
          title: t('Määrä'),
          options: <String>['1', '2', '3', '4', '5', '6', '7', '8', '9'],
        ),
        DropdownMenu(
          title: t('Lisuke'),
          options: <String>['Kana'],
        ),
      ],
    );
  }

  /// Establishment menu view
  Widget _getEstablishmentView(EstablishmentState state) {
    return Column(
      key: ValueKey('EstablishmentView'),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 25.0),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15.0,
          ),
          child: Column(
            children: <Widget>[
              Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  EstablishmentInfo(
                    establishment: state.establishment,
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
                  TextFactory.h2(t('Menu')),
                ],
              ),
            ],
          ),
        ),
        MenuView(
          menu: state.menu,
          establishment: state.establishment,
          onAddItem: (MenuItem menuItem) {
            BlocProvider.of<OrderBloc>(context).add(
              CreateOrderItemEvent(menuItem),
            );
          },
        ),
        Container(
          height: 64.0,
          color: offWhiteColor,
        ),
      ],
    );
  }
}
