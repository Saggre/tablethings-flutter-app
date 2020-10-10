import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sprintf/sprintf.dart';
import 'package:tablethings/blocs/session/session_bloc_events.dart';
import 'package:tablethings/blocs/session/session_bloc_states.dart';
import 'package:tablethings/models/tablethings/user.dart';
import 'package:tablethings/services/tablethings.dart';

class SessionBloc extends Bloc<SessionBlocEvent, SessionBlocState> {
  SessionBloc() : super(NotPresent());

  @override
  Stream<SessionBlocState> mapEventToState(SessionBlocEvent event) async* {
    if (event is SetScannedRestaurant) {
      try {
        var combo = await Tablethings.getAll(event.restaurantId);

        yield PhysicallyPresent(combo['restaurant'], combo['menu'], event.tableId);
      } catch (ex) {
        // TODO maybe show error
        yield NotPresent();
      }
    }
  }
}
