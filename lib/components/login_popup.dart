import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tablething/blocs/auth/auth_bloc.dart';
import 'package:tablething/blocs/auth/auth_bloc_states.dart';
import 'package:tablething/blocs/bloc.dart';
import 'package:tablething/localization/translate.dart';
import 'package:tablething/theme/theme.dart';
import 'package:tablething/util/text_factory.dart';
import 'buttons/single_button.dart';

class LoginPopup extends StatelessWidget {
  final Function onCloseTapped;
  final String description;
  final bool isCancelable;
  final BlocState authState;

  const LoginPopup({
    Key key,
    @required this.onCloseTapped,
    this.description,
    this.isCancelable = false,
    @required this.authState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, BlocState>(builder: (context, state) {
      if (state is Unauthenticated) {
        return ClipRRect(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          borderRadius: BorderRadius.circular(42.0),
          child: Container(
            color: offWhiteColor,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  TextFactory.h1(t('Login')),
                  if (description != null) TextFactory.p(description),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                  ),
                  SingleButton(
                    properties: SingleButtonProperties(
                      colors: [Color(0xFF3B5998)],
                      text: 'Facebook',
                      textStyle: TextFactory.buttonStyle,
                      borderRadius: BorderRadius.only(topLeft: Radius.zero, topRight: Radius.circular(32.0), bottomLeft: Radius.circular(32.0), bottomRight: Radius.circular(32.0)),
                      onPressed: () {
                        BlocProvider.of<AuthBloc>(context).add(FacebookLoginEvent());
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                  ),
                  SingleButton(
                    properties: SingleButtonProperties(
                      colors: [Colors.white],
                      text: 'Google',
                      textStyle: TextFactory.buttonStyle.copyWith(color: Colors.black),
                      borderRadius: BorderRadius.only(topLeft: Radius.zero, topRight: Radius.circular(32.0), bottomLeft: Radius.circular(32.0), bottomRight: Radius.circular(32.0)),
                      onPressed: () {
                        BlocProvider.of<AuthBloc>(context).add(GoogleLoginEvent());
                      },
                    ),
                  ),
                  if (isCancelable)
                    GestureDetector(
                      onTap: () {
                        onCloseTapped();
                      },
                      child: Container(
                        height: 64.0,
                        alignment: Alignment.center,
                        child: Text(
                          t('I will sign in later'),
                          style: TextFactory.lightButtonStyle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      } else if (state is Authenticating) {
        return Container(
          color: Colors.transparent,
          alignment: Alignment.center,
          child: SpinKitPulse(
            color: mainThemeColor,
            size: 128,
          ),
        );
      }

      // TODO error popup
      return Container(
        color: Colors.red,
        height: 200,
      );
    });
  }
}
