import 'dart:async';
import 'dart:convert' show json;

import 'package:firestore_helpers/firestore_helpers.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'location.dart';
import 'establishment.dart';

/// Gets data from firebase
class ApiClient {
  final Firestore _databaseReference = Firestore.instance;

  Future<List<Establishment>> getEstablishments(
      {List<QueryConstraint> constraints}) async {
    // TODO geoquery
    QuerySnapshot qShot =
        await _databaseReference.collection("establishments").getDocuments();

    return qShot.documents
        .map((doc) => Establishment.fromJson(doc.data))
        .toList();
  }
}
