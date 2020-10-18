import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tablethings/blocs/auth/auth_bloc.dart';
import 'package:tablethings/blocs/auth/auth_bloc_events.dart';
import 'package:tablethings/blocs/auth/auth_bloc_states.dart';
import 'package:tablethings/blocs/navigation/navigation_bloc.dart';
import 'package:tablethings/blocs/navigation/navigation_bloc_events.dart';
import 'package:tablethings/blocs/navigation/navigation_bloc_states.dart';

class PaymentMethodsScreen extends StatelessWidget {
  PaymentMethodsScreen();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthBlocState>(
      builder: (context, navState) {},
    );
  }
}
