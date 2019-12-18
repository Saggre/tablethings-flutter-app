import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tablething/blocs/bloc.dart';
import 'package:tablething/localization/translate.dart';
import 'package:tablething/theme/theme.dart';
import 'package:tablething/util/text_factory.dart';
import 'buttons/dual_button.dart';
import 'corner_bar.dart';

class EditCardPopup extends StatefulWidget {
  final Function onCloseTapped;

  const EditCardPopup({Key key, this.onCloseTapped}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EditCardPopupState();
  }
}

class EditCardPopupState extends State<EditCardPopup> {
  final _formKey = GlobalKey<FormState>();
  final _formFieldControllers = {
    'cardNumber': TextEditingController(),
    'expMonth': TextEditingController(),
    'expYear': TextEditingController(),
    'cvv': TextEditingController(),
  };

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      borderRadius: BorderRadius.circular(32.0),
      child: Container(
          width: double.infinity,
          color: offWhiteColor,
          child: BlocBuilder<PaymentMethodBloc, ProgressBlocState>(builder: (context, state) {
            return Column(children: () {
              List<Widget> builder = [
                Container(
                  alignment: Alignment.centerLeft,
                  height: 5.0,
                  width: double.infinity,
                  color: Colors.grey[800],
                  child: AnimatedContainer(
                    curve: Curves.easeInOut,
                    duration: Duration(milliseconds: 500),
                    width: (MediaQuery.of(context).size.width - 20.0) * state.progress,
                    height: 5.0,
                    decoration: BoxDecoration(
                      color: mainThemeColor,
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    CornerBar(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      color: darkThemeColor,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          onPressed: () => widget.onCloseTapped(),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 16.0,
                      ),
                      child: Center(
                        child: TextFactory.h4(state.toString()),
                      ),
                    ),
                  ],
                ),
              ];

              builder.add(
                Padding(
                  padding: EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: () {
                          List<Widget> builder = List();

                          if (state is CardNumberState) {
                            builder.add(
                              TextFormField(
                                controller: _formFieldControllers['cardNumber'],
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(32.0),
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                                  hintText: t('Enter your card number'),
                                ),
                                validator: (value) {
                                  if (value.isEmpty || value.length < 16) {
                                    return t('Please enter a valid card number');
                                  }

                                  return null;
                                },
                              ),
                            );
                          } else if (state is SecurityInfoState) {
                            builder.add(
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    t('Expiration date'),
                                    style: TextFactory.pStyle,
                                    textAlign: TextAlign.left,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 10.0),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Flexible(
                                        flex: 5,
                                        child: TextFormField(
                                          controller: _formFieldControllers['expMonth'],
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: const BorderRadius.all(
                                                const Radius.circular(32.0),
                                              ),
                                            ),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                                            hintText: t('MM'),
                                          ),
                                          style: TextFactory.pStyle,
                                          validator: (value) {
                                            if (value.isEmpty || value.length > 2) {
                                              return t('Please enter a \nvalid month');
                                            }

                                            return null;
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 5.0),
                                      ),
                                      Flexible(
                                        flex: 5,
                                        child: TextFormField(
                                          controller: _formFieldControllers['expYear'],
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: const BorderRadius.all(
                                                const Radius.circular(32.0),
                                              ),
                                            ),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                                            hintText: t('YYYY'),
                                          ),
                                          style: TextFactory.pStyle,
                                          validator: (value) {
                                            if (value.isEmpty || value.length != 4) {
                                              return t('Please enter \na valid year\n (4 digits)');
                                            }

                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 20.0),
                                  ),
                                  Text(
                                    t('CVV-number'),
                                    style: TextFactory.pStyle,
                                    textAlign: TextAlign.left,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 10.0),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Flexible(
                                        flex: 5,
                                        child: TextFormField(
                                          controller: _formFieldControllers['cvv'],
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: const BorderRadius.all(
                                                const Radius.circular(32.0),
                                              ),
                                            ),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                                            hintText: t('CVV'),
                                          ),
                                          style: TextFactory.pStyle,
                                          validator: (value) {
                                            if (value.isEmpty || value.length < 3 || value.length > 4) {
                                              return t('Please enter \na valid CVV-number');
                                            }

                                            return null;
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 5.0),
                                      ),
                                      Flexible(
                                        flex: 5,
                                        child: Container(),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            );
                          } else if (state is ApiConnectionState) {
                            builder.add(
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                color: Colors.transparent,
                                alignment: Alignment.center,
                                child: SpinKitPulse(
                                  color: mainThemeColor,
                                  size: 128.0,
                                ),
                              ),
                            );
                          } else if (state is CardAddedState) {
                            builder.add(
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                color: Colors.transparent,
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.check,
                                  color: mainThemeColor,
                                  size: 128.0,
                                ),
                              ),
                            );
                          }

                          return builder;
                        }()),
                  ),
                ),
              );

              builder.add(Padding(
                padding: EdgeInsets.only(bottom: 32.0),
              ));

              builder.add(
                DualButton(
                  properties: DualButtonProperties(
                    separatorDirection: DualButtonSeparatorDirection.leftHand,
                  ),
                  rightButtonProperties: SingleButtonProperties(
                    text: t('Continue'),
                    textStyle: TextFactory.buttonStyle,
                    colors: [
                      darkThemeColorGradient,
                      darkThemeColor,
                    ],
                    borderRadius: BorderRadius.circular(32.0),
                    onPressed: () {
                      if (state is CardNumberState) {
                        if (_formKey.currentState.validate()) {
                          BlocProvider.of<PaymentMethodBloc>(context).add(AddCardNumber(_formFieldControllers['cardNumber'].text.toString()));
                        }
                      } else if (state is SecurityInfoState) {
                        if (_formKey.currentState.validate()) {
                          BlocProvider.of<PaymentMethodBloc>(context).add(AddSecurityInfo(
                              _formFieldControllers['expMonth'].text.toString(), _formFieldControllers['expYear'].text.toString(), _formFieldControllers['cvv'].text.toString()));
                        }
                      } else if (state is CardAddedState) {
                        widget.onCloseTapped();
                      }
                    },
                  ),
                ),
              );

              return builder;
            }());
          })),
    );
  }
}
