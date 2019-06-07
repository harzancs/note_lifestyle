import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  searchByName(String SearchField) {
    return Firestore.instance
        .collection('car')
        .where('Brandname',
            isEqualTo: SearchField.substring(0, 1).toUpperCase())
        .getDocuments();
  }
}
