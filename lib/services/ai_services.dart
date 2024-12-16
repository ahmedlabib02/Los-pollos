import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:los_pollos_hermanos/models/ai_prompt.dart';
import 'package:los_pollos_hermanos/models/restaurant_model.dart';
import 'package:los_pollos_hermanos/services/manager_services.dart';

class AiServices {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static Future<AiPrompt> getPrompt(String userId, String restaurantId) async {
    AiPrompt prompt = AiPrompt();
    try {
      await getRestaurantDetails(restaurantId, prompt);
      await getPastTenOrders(userId, prompt);
    } catch (e) {
      throw Exception('Error getting prompt: $e');
    } finally {
      return prompt;
    }
  }

  static Future<void> getRestaurantDetails(
      String restaurantId, AiPrompt prompt) async {
    Restaurant restaurant =
        await ManagerServices().getRestaurant(restaurantId) as Restaurant;
    prompt.restaurantName = restaurant.name;
    prompt.restaurantCategory = restaurant.category;
    await getMenuItems(restaurant.menuId, prompt);
  }

  static Future<void> getMenuItems(String menuId, AiPrompt prompt) async {
    DocumentSnapshot menuDoc =
        await _firestore.collection('menus').doc(menuId).get();

    try {
      // get the categories  Map<String, List<String>> from the menuId
      Map<String, dynamic> categoriesData = menuDoc.get('categories');
      Map<String, List<String>> categories = {};

      // Now, check if the data is in the correct format (List<String> for each key)
      categoriesData.forEach((key, value) {
        if (value is List) {
          categories[key] = List<String>.from(value);
        }
      });
      // loop on each category and get the menuitem from the category and append category to it and add it to the prompt menuitems
      for (String category in categories.keys) {
        List<String> menuItemsIds = categories[category] as List<String>;
        for (String menuItemId in menuItemsIds) {
          DocumentSnapshot menuItemDoc =
              await _firestore.collection('menuItems').doc(menuItemId).get();
          prompt.menuItems.add({
            'name': menuItemDoc['name'] as String,
            'price': menuItemDoc['price'].toString(),
            'description': menuItemDoc['description'] as String,
            'extras':
                (menuItemDoc['extras'] as Map).keys.toList() as List<String>,
            'category': category,
          });
        }
      }
    } catch (e) {
      print('Error getting menu items: $e');
    }
  }

  static Future<void> getPastTenOrders(String userId, AiPrompt prompt) async {
    // get the last 10 bills from the user
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('clients')
          .doc(userId)
          .collection('bills')
          .orderBy('timestamp', descending: true)
          .limit(15)
          .get();
      // get the orders ids from the bills
      List<String> orderIds = querySnapshot.docs
          .map((QueryDocumentSnapshot doc) => doc['orderId'] as String)
          .toList();
      // get the orders from the orders ids
      List<Map<String, String>> pastOrders = [];
      for (String orderId in orderIds) {
        DocumentSnapshot orderDoc =
            await _firestore.collection('orders').doc(orderId).get();
        pastOrders.add({
          'name': orderDoc['name'] as String,
        });
      }
      print("GOT PAST ORDERS");
    } catch (e) {
      print('Error getting past orders: $e');
    }
  }

  static Future<String> getResponse(AiPrompt prompt, String query) async {
    prompt.userQuery = query;
    String parsedPrompt = prompt.parsePrompt();
    try {
      final url = Uri.parse('https://api.groq.com/openai/v1/chat/completions');

      // Prepare the body of the request
      final body = json.encode({
        "model": "mixtral-8x7b-32768",
        "messages": [
          {"role": "user", "content": "$parsedPrompt"}
        ]
      });

      // Send the request to the API
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${dotenv.env['GROQ_API_KEY']}',
        },
        body: body,
      );
      String completion = 'Sorry, I can not help with that right now :(';
      print("AI RESPONSE: ${response.statusCode}");
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        completion = data['choices'][0]['message']['content'];
        updatePromptObject(prompt, query, completion);
        print(completion);
      } else {
        print('Error: ${response.statusCode}');
      }
      return completion;
    } catch (e) {
      return 'Sorry, I can not help with that right now :(';
    }
  }

  static void updatePromptObject(
      AiPrompt prompt, String query, String response) {
    if (prompt.chatContext.length > 20) {
      prompt.chatContext.removeRange(0, 2);
    }
    prompt.chatContext.add("user_query: $query");
    prompt.chatContext.add("ai_response: $response");
  }
}
