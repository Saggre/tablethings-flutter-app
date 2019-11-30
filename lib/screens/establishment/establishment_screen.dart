import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tablething/blocs/bloc.dart';
import 'package:tablething/blocs/order/order_bloc_events.dart';
import 'package:tablething/blocs/order/order_bloc_states.dart';
import 'package:tablething/blocs/order_bloc_delegate.dart';
import 'package:tablething/components/buttons/dual_button.dart';
import 'package:tablething/components/colored_safe_area.dart';
import 'package:tablething/components/establishment_image.dart';
import 'package:tablething/components/establishment_info.dart';
import 'package:tablething/components/main_app_bar.dart';
import 'package:tablething/localization/translate.dart';
import 'package:tablething/models/establishment/establishment.dart';
import 'package:tablething/models/establishment/menu/menu_item.dart';
import 'package:tablething/models/establishment/order/order.dart';
import 'package:tablething/models/establishment/order/order_item.dart';
import 'package:tablething/models/fetchable_package.dart';
import 'package:tablething/screens/establishment/components/dropdown_menu.dart';
import 'package:tablething/screens/establishment/components/menu_view/menu_view_item_text.dart';
import 'package:tablething/theme/colors.dart';
import 'package:tablething/util/text_factory.dart';
import 'components/menu_view/menu_view.dart';
import 'package:bloc/bloc.dart';

/// Arguments sent to this screen
class EstablishmentScreenArguments {
  final FetchablePackage<String, Establishment> establishmentPackage;
  final String tableId;

  EstablishmentScreenArguments({this.establishmentPackage, this.tableId});
}

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

    // Set bloc delegate
    BlocSupervisor.delegate = SimpleBlocDelegate();

    // Delayed to after context is initialized
    () async {
      await Future.delayed(Duration.zero);
      final EstablishmentScreenArguments args = ModalRoute.of(context).settings.arguments;

      // Get establishment
      print("Getting establishment: " + args.establishmentPackage.getFetchId());
      BlocProvider.of<OrderBloc>(context).add(
        GetEstablishmentEvent(args.establishmentPackage),
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

                if (state is EstablishmentState) {
                  print("Successfully got establishment: " + state.establishment.name);

                  return _getFrame(
                    _getEstablishmentView(state.establishment),
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

                //return CircularProgressIndicator(value: null);

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
// TODO back event
    }
  }

  Widget _getButtons() {
    return Flex(
      direction: Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        BlocBuilder<OrderBloc, OrderBlocState>(builder: (context, state) {
          if (state is OrderItemState) {
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
                  print(orderQuantityController.currentValue.toString());
                  // Add to order
                  BlocProvider.of<OrderBloc>(context).add(
                    ModifyOrderItemOptionsEvent(OrderItemOptions(quantity: int.tryParse(orderQuantityController.currentValue)), state.orderItem),
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
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 25.0),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: <Widget>[
              Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  EstablishmentInfo(
                    establishment: establishment,
                    showDescription: false,
                    showRating: false,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 25.0),
              ),
              Row(
                children: <Widget>[
                  // TODO Subtotal
                ],
              ),
            ],
          ),
        ),
        Container(),
      ],
    );
  }

  /// Added order item view
  Widget _getOrderItemView(Establishment establishment, OrderItem<MenuItem> orderItem) {
    return Column(
      key: ValueKey('OrderItemView'),
      children: <Widget>[
        Container(
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 25.0,
                ),
                child: MenuViewItemText(
                  menuItem: orderItem.product,
                  establishment: establishment,
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                width: MediaQuery.of(context).size.width * 0.33,
                child: CachedNetworkImage(
                  imageUrl: orderItem.product.imageUrl,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ],
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
  Widget _getEstablishmentView(Establishment establishment) {
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
                    establishment: establishment,
                  ),
                ],
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
          menu: establishment.menu,
          establishment: establishment,
          onAddItem: (MenuItem menuItem) {
            BlocProvider.of<OrderBloc>(context).add(
              AddOrderItemEvent(menuItem),
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
