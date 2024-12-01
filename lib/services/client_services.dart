// lib/services/client_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:los_pollos_hermanos/models/bill_model.dart';
import 'package:los_pollos_hermanos/models/order_item_model.dart';
import 'package:los_pollos_hermanos/models/table_model.dart';
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

// ------------------------ Table Operations ------------------------
  Future<String> createTable(String userID) async {
    try {
      Table table = Table(
        id: "",
        isTableSplit: false,
        userIds: [userID],
        orderItemIds: [],
        billIds: [],
        totalAmount: 0.0,
        tableCode: Table.generateTableCode(),
        isOngoing: true,
      );
      DocumentReference tableRef = _firestore.collection('tables').doc();
      table.id = tableRef.id;
      await tableRef.set(table.toMap());
      print("Table added  successfully");
      // Return the generated table code
      return table.tableCode;
    } catch (e) {
      print("Failed to add table : $e");
      throw Exception("Failed to create table: $e");
    }
  }

  Future<Table?> getTableByID(String tableID) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('tables').doc(tableID).get();
      if (doc.exists) {
        return Table.fromMap(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print("Failed to retrieve table: $e");
    }
    return null;
  }

  Future<void> updateTableSplitStatus(String tableID, bool isTableSplit) async {
    try {
      await _firestore
          .collection('tables')
          .doc(tableID)
          .update({'isTableSplit': isTableSplit});
      print("Table split status updated successfully");
    } catch (e) {
      print("Failed to update table split status: $e");
    }
  }

  Future<void> addClientToTable(String tableID, String userID) async {
    try {
      DocumentReference tableRef = _firestore.collection('tables').doc(tableID);
      await tableRef.update({
        'userIds': FieldValue.arrayUnion([userID]),
      });
      print("Client added to table successfully");
    } catch (e) {
      print("Failed to add client to table: $e");
    }
  }

// ------------------------- Order Items ---------------------------------------
  Future<void> addOrderItemToTable(String tableID, OrderItem orderItem) async {
    try {
      DocumentReference tableRef = _firestore.collection('tables').doc(tableID);
      await tableRef.update({
        'orderItemIds': FieldValue.arrayUnion([orderItem.id]),
        'totalAmount': FieldValue.increment(orderItem.price),
      });
      createOrUpdateBill(orderItem.userIds[0], orderItem.id);
      updateAllBills(tableID);
      print("Order item added to table successfully");
    } catch (e) {
      print("Failed to add order item to table: $e");
    }
  }

// ------------------------- Bills ---------------------------------------
//  Bills are created for a user when the user orders for the first time or join someones order
//  Bills are updated when the user orders more items or joins more orders
  Future<void> createOrUpdateBill(String userID, String orderItemID) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userID).get();
      String currentTableID = userDoc.get('currentTableID');
      DocumentSnapshot orderItemDoc =
          await _firestore.collection('orderItems').doc(orderItemID).get();
      double orderItemAmount = orderItemDoc.get('amount') /
          orderItemDoc.get('userIds').length as double;
      DocumentSnapshot tableDoc =
          await _firestore.collection('tables').doc(currentTableID).get();
      List<String> billIds = List<String>.from(tableDoc.get('billIds'));
      String userBillId = billIds.firstWhere(
        (billId) => billId.contains(userID),
        orElse: () => '',
      );

      if (userBillId.isNotEmpty) {
        DocumentSnapshot billDoc =
            await _firestore.collection('bills').doc(userBillId).get();
        double currentAmount = billDoc.get('amount');
        double newAmount = currentAmount + orderItemAmount;
        await _firestore
            .collection('bills')
            .doc(userBillId)
            .update({'amount': newAmount});
      } else {
        DocumentReference billRef = _firestore.collection('bills').doc();
        Bill bill = Bill(
          id: billRef.id,
          amount: orderItemAmount,
          userId: userID,
          isPaid: false,
          orderItemIds: [orderItemID],
        );
        await billRef.set(bill.toMap());
        await _firestore.collection('tables').doc(currentTableID).update({
          'billIds': FieldValue.arrayUnion([billRef.id])
        });
      }
    } catch (e) {
      print("Failed to create or update bill: $e");
    }
  }

  Future<void> updateAllBills(String tableID) async {
    try {
      DocumentSnapshot tableDoc =
          await _firestore.collection('tables').doc(tableID).get();
      bool isTableSplit = tableDoc.get('isTableSplit');

      if (isTableSplit) {
        double totalAmount = tableDoc.get('totalAmount');
        double amountPerUser = totalAmount / tableDoc.get('userIds').length;
        List<String> billIds = List<String>.from(tableDoc.get('billIds'));
        for (String billId in billIds) {
          await _firestore
              .collection('bills')
              .doc(billId)
              .update({'amount': amountPerUser});
        }
      }
    } catch (e) {
      print("Failed to update all bills: $e");
    }
  }

  Future<void> updateBillStatus(String billID) async {
    try {
      await _firestore.collection('bills').doc(billID).update({'isPaid': true});
    } catch (e) {
      print("Failed to update bill: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getBillSummary(String userID) async {
    List<Map<String, dynamic>> billSummaries = [];
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userID).get();
      String currentTableID = userDoc.get('currentTableID');
      DocumentSnapshot tableDoc =
          await _firestore.collection('tables').doc(currentTableID).get();
      List<String> billIds = List<String>.from(tableDoc.get('billIds'));

      for (String billId in billIds) {
        DocumentSnapshot billDoc =
            await _firestore.collection('bills').doc(billId).get();
        String billUserID = billDoc.get('userId');
        String billUserName = userDoc.get('name');
        double billAmount = billDoc.get('amount');
        List<String> orderItemIds =
            List<String>.from(billDoc.get('orderItemIds'));
        List<Map<String, dynamic>> orderItems = [];
        for (String orderItemId in orderItemIds) {
          DocumentSnapshot orderItemDoc =
              await _firestore.collection('orderItems').doc(orderItemId).get();
          int itemCount = orderItemDoc.get('userIds').length;
          String menuItemID = orderItemDoc.get('menuItemID');
          String menuItemName =
              (await _firestore.collection('menuItems').doc(menuItemID).get())
                  .get('name');
          orderItems.add({
            'itemCount': itemCount,
            'itemName': menuItemName,
          });
        }

        Map<String, dynamic> billSummary = {
          'id': billId,
          'name': billUserName,
          'amount': billAmount,
          'orderItems': orderItems,
          'isPaid': billDoc.get('isPaid'),
          'isCurrentUser': billUserID == userID,
        };

        if (billUserID == userID) {
          billSummaries.insert(0, billSummary);
        } else {
          billSummaries.add(billSummary);
        }
      }
    } catch (e) {
      print("Failed to get bill summary: $e");
    }
    return billSummaries;
  }

  Future<List<Bill>> getPastBillsPerUser(String userID) async {
    try {
      QuerySnapshot billsSnapshot = await _firestore
          .collection('bills')
          .where('userId', isEqualTo: userID)
          .where('isPaid', isEqualTo: true) // Assuming past bills are paid
          .get();

      return billsSnapshot.docs.map((doc) {
        return Bill.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print("Error fetching past bills: $e");
      throw Exception("Failed to fetch past bills");
    }
  }

  Future<List<OrderItem>> getOrderPerBill(String billID) async {
    try {
      DocumentSnapshot billDoc =
          await _firestore.collection('bills').doc(billID).get();

      List<String> orderItemIds =
          List<String>.from(billDoc.get('orderItemIds'));

      List<OrderItem> orderItems = [];
      for (String orderItemId in orderItemIds) {
        DocumentSnapshot orderItemDoc =
            await _firestore.collection('orderItems').doc(orderItemId).get();
        Map<String, dynamic> orderItemData =
            orderItemDoc.data() as Map<String, dynamic>;

        // Fetch the name of the menu item using its menuItemID
        DocumentSnapshot menuItemDoc = await _firestore
            .collection('menuItems')
            .doc(orderItemData['menuItemID'])
            .get();
        String menuItemName = menuItemDoc.get('name');

        // Add the name to the orderItem
        OrderItem orderItem = OrderItem.fromMap(orderItemData);
        orderItem.name = menuItemName; // Dynamically set the name field
        orderItems.add(orderItem);
      }

      return orderItems;
    } catch (e) {
      print("Error fetching orders for bill: $e");
      throw Exception("Failed to fetch orders for the bill");
    }
  }
}
