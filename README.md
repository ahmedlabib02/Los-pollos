## LOS POLLOS HERMANOS: A Revolutionary Dining Experience

The Los Pollos Hermanos mobile application is designed to transform the restaurant dining experience by enabling customers to order food, join tables, share order items, and split bills conveniently. With flexible payment options and intuitive features, the app enhances customer satisfaction while streamlining operations for restaurants.

App Structure and Key Features

The application is divided into two primary components:

1. Customer App : this app caters to diners, offering features like table joining, order sharing, and bill splitting.

2. Restaurant App : this app is used by restaurant staff to manage tables, orders, and related operations.

Customer App Features

The Customer App is structured into the following key modules:

1. Login and Registration
	•	Users can create an account or log in using their email and password.
	•	Password change functionality is also available.

1. Restaurant Selection
	•	Upon logging in, users can browse and select the restaurant they are dining at, provided it is registered with the app.

2. Table Creation and Joining
	•	Users can create a new table or join an existing one by entering a shared code.
	•	During table creation, users can specify their bill-splitting preference:
	•	Equally among members
	•	Based on ordered items

3. Menu Selection
	•	Users can explore the restaurant’s menu and add items to their order.

4. Order Summary
	•	Displays all items ordered by the table.
	•	Users can opt to share specific orders with other table members and split the associated costs.

5. Bills
	•	Bill Summary: Users can review their own orders and the bills of other table members.
	•	Payment Options: Allows users to pay their dues via credit/debit card.
	•	Bill History: Enables users to view their previous bills and the details of each order.

6. AI Chatbot Support
	•	An intelligent chatbot, powered by GroqCloud API and the mixtral-8x7b-32768 model, assists users by:
	•	Answering queries about their past orders.
	•	Providing insights about the restaurant menu.
	•	Offering guidance on app features.

This context-aware assistant ensures seamless user support tailored to individual needs.

The Customer App not only simplifies dining but also fosters collaboration and convenience for table members, making it an integral part of the modern dining experience.

Restaurant App Features

The Restaurant App is designed to streamline operations and enhance customer service by providing the following functionalities:

1. Menu Management
    •	Enables restaurant staff to update and manage the menu in real time.
    •	Allows for easy customization and item categorization.

2. Table Management
    •	Allows restaurant staff to manage table orders and bill tracking efficiently.
    •	Enables real-time updates on table status and occupancy.

3. Special Offers
    •	Enables restaurants to create and promote special offers for customers.
    •	Notify customers about ongoing promotions and discounts.

Database Design and Integration

The application leverages firebase firestore database to store and manage user data, orders, bills, and other relevant information. The integration of firebase ensures real-time synchronization and seamless data access across the customer and restaurant apps.

Shared Features:
1. User Authentication: Both apps support secure user authentication using email and password.

### Database Schema includes collections for:

#### Client
| Field          | Type           | Description                         |
|-----------------|----------------|-------------------------------------|
| userID         | String         | Unique ID of the client             |
| name           | String         | Name of the client                 |
| email          | String         | Email address of the client         |
| imageUrl       | String         | Profile image URL of the client     |
| pastBillsIDs   | List<String>   | List of IDs of past bills           |
| currentTableID | String         | ID of the current table             |
| fcmToken       | String (Optional) | Firebase Cloud Messaging token   |
| notificationIDs| List<String>   | List of notification IDs            |

---

#### Bill
| Field          | Type          | Description                  |
|-----------------|---------------|------------------------------|
| id             | String        | Unique ID of the bill        |
| orderItemIds   | List<String>  | List of associated order item IDs |
| amount         | double        | Total amount of the bill     |
| isPaid         | bool          | Payment status of the bill   |
| userId         | String        | ID of the user               |
| restaurantId   | String        | ID of the restaurant         |

---

#### MenuItem
| Field          | Type           | Description                         |
|-----------------|----------------|-------------------------------------|
| id             | String         | Unique ID of the menu item          |
| name           | String         | Name of the menu item               |
| price          | double         | Price of the menu item              |
| description    | String         | Description of the menu item        |
| variants       | List<String>   | List of variants available          |
| extras         | List<String>   | List of extras available            |
| discount       | double         | Discount on the menu item           |
| reviewIds      | List<String>   | List of associated review IDs       |
| imageUrl       | String         | Image URL of the menu item          |

---

#### Menu
| Field          | Type                          | Description                            |
|-----------------|-------------------------------|----------------------------------------|
| id             | String                        | Unique ID of the menu                  |
| categories     | Map<String, List<String>>     | Map of categories to menu item IDs     |

---

#### OrderItem
| Field          | Type           | Description                         |
|-----------------|----------------|-------------------------------------|
| id             | String         | Unique ID of the order item         |
| userIds        | List<String>   | List of user IDs associated with the order |
| menuItemId     | String         | ID of the menu item ordered         |
| tableId        | String         | ID of the table                     |
| status         | String         | Status of the order (e.g., pending, completed) |
| itemCount      | int            | Number of items ordered             |
| notes          | String         | Special instructions or notes       |
| price          | double         | Price of the order item             |
| name           | String (Optional) | Name of the item                  |
| imageUrl       | String (Optional) | Image URL of the item             |

---

#### Restaurant
| Field          | Type           | Description                         |
|-----------------|----------------|-------------------------------------|
| id             | String         | Unique ID of the restaurant         |
| name           | String         | Name of the restaurant              |
| menuId         | String         | ID of the associated menu           |
| category       | String         | Category of the restaurant          |
| imageUrl       | String (Optional) | Image URL of the restaurant       |

---

#### Review
| Field          | Type           | Description                         |
|-----------------|----------------|-------------------------------------|
| id             | String         | Unique ID of the review             |
| userId         | String         | ID of the user who wrote the review |
| menuItemId     | String         | ID of the reviewed menu item        |
| reviewContent  | String         | Content of the review               |

---

#### Table
| Field          | Type           | Description                         |
|-----------------|----------------|-------------------------------------|
| id             | String         | Unique ID of the table              |
| isTableSplit   | bool           | Whether the table is split          |
| userIds        | List<String>   | List of user IDs at the table        |
| orderItemIds   | List<String>   | List of associated order item IDs   |
| billIds        | List<String>   | List of associated bill IDs         |
| totalAmount    | double         | Total amount for the table          |
| tableCode      | String         | Unique code for identifying the table |
| isOngoing      | bool           | Whether the table is in use         |
| restaurantId   | String         | ID of the associated restaurant     |

---

#### Notifications
| Field          | Type           | Description                         |
|-----------------|----------------|-------------------------------------|
| id             | String         | Unique ID of the notification       |
| title          | String         | Title of the notification           |
| body           | String         | Body of the notification            |

### API Integration
#### Stripe API
The application integrates the Stripe API to facilitate secure and seamless payment processing. Users can pay their bills using credit/debit cards, and the API ensures secure transactions and real-time payment processing.

#### GroqCloud API
The application leverages the GroqCloud API to power the AI chatbot feature. The chatbot provides personalized assistance to users, answering queries, providing insights, and guiding users through the app features. The GroqCloud API enables natural language processing and context-aware responses, enhancing the user experience.

### Screenshots and User Flow
The following screenshots show some of the key features of the Los Pollos Hermanos mobile application:

| ![Login]( /screenshots/login.png){ width=200 height=445 } | ![Signup]( /screenshots/signup.png){ width=200 height=445 } | ![Menu]( /screenshots/menu.png){ width=200 height=445 } |
|-----------------------------------------------------------|------------------------------------------------------------|----------------------------------------------------------|
| **Login**                                                | **Signup**                                                | **Menu**                                                 |
| ![Past Orders]( /screenshots/pastOrders.png){ width=200 height=445 } | ![Order Details]( /screenshots/orderDetails.png){ width=200 height=445 } | ![AI Chatbot]( /screenshots/ai.png){ width=200 height=445 } |
| **Past Orders**                                          | **Order Details**                                          | **AI Chatbot**                                           |