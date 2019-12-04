import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tablething/blocs/auth/auth_bloc.dart';
import 'package:tablething/localization/translate.dart';
import 'package:tablething/theme/theme.dart';
import 'package:tablething/util/text_factory.dart';

import 'buttons/single_button.dart';

class LoginPopup extends StatelessWidget {
  final Function onCloseTapped;

  const LoginPopup({
    Key key,
    @required this.onCloseTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      borderRadius: BorderRadius.circular(48.0),
      child: Container(
        color: offWhiteColor,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              TextFactory.h1(t('Login')),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
              ),
              SingleButton(
                properties: SingleButtonProperties(
                  colors: [Color(0xFF3B5998)],
                  text: 'Facebook',
                  textStyle: TextFactory.buttonStyle,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.zero, topRight: Radius.circular(32.0), bottomLeft: Radius.circular(32.0), bottomRight: Radius.circular(32.0)),
                  onPressed: () {
                    print("FB");
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
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.zero, topRight: Radius.circular(32.0), bottomLeft: Radius.circular(32.0), bottomRight: Radius.circular(32.0)),
                  onPressed: () {
                    print("Google");
                    BlocProvider.of<AuthBloc>(context).add(GoogleLoginEvent());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
