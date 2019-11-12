import 'dart:async';

import 'package:tablething/blocs/bloc.dart';
import 'package:tablething/services/api_client.dart';
import 'package:tablething/services/location.dart';

class LocationQueryBloc implements Bloc {
  final _controller = StreamController<List<Location>>();
  final _client = ApiClient();

  Stream<List<Location>> get locationStream => _controller.stream;

  /// Gives the query to the API handler
  void submitQuery(String query) async {
    final List<Location> results = await _client.fetchLocations(query);
    _controller.sink.add(results);
  }

  @override
  void dispose() {
    _controller.close();
  }
}
