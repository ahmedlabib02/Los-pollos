// lib/services/client_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/client_model.dart';

class ClientService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = 'clients';

  /// Adds a new client to Firestore
  Future<void> addClient(Client client) async {
    try {
      await _firestore
          .collection(collectionPath)
          .doc(client.userID)
          .set(client.toMap());
    } catch (e) {
      throw Exception('Error adding client: $e');
    }
  }

  Future<Client?> getClient(String userID) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(collectionPath).doc(userID).get();
      if (doc.exists) {
        return Client.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Error fetching client: $e');
    }
  }

  Stream<Client?> streamClient(String userID) {
    return _firestore
        .collection(collectionPath)
        .doc(userID)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return Client.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    });
  }

  Future<void> updateClient(Client client) async {
    try {
      await _firestore
          .collection(collectionPath)
          .doc(client.userID)
          .update(client.toMap());
    } catch (e) {
      throw Exception('Error updating client: $e');
    }
  }

  /// Deletes a client from Firestore
  Future<void> deleteClient(String userID) async {
    try {
      await _firestore.collection(collectionPath).doc(userID).delete();
    } catch (e) {
      throw Exception('Error deleting client: $e');
    }
  }

  Future<void> updateClientFcmToken(String uid, String token) async {
    try {
      await _firestore.collection('clients').doc(uid).update({
        'fcmToken': token,
      });
    } catch (e) {
      print('Error updating FCM token: $e');
    }
  }

  Future<void> removeClientFcmToken(String? userId) async {
    try {
      await FirebaseFirestore.instance
          .collection('clients')
          .doc(userId)
          .update({
        'fcmToken': FieldValue.delete(),
      });
      print('FCM Token removed from Firestore');
    } catch (e) {
      print('Error removing FCM Token: $e');
    }
  }
}
