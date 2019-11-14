import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'establishment.dart';

/// Gets data from firebase
class ApiClient {
  final Firestore _databaseReference = Firestore.instance;

  Future<List<Establishment>> getEstablishments() async {
    // TODO geoquery
    QuerySnapshot qShot = await _databaseReference.collection("establishments").getDocuments();

    return qShot.documents.map((doc) {
      Establishment establishment = Establishment.fromJson(doc.data);
      return establishment;
    }).toList();
  }
}
