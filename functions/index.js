// functions/index.js
/* eslint-disable */
const functions = require("firebase-functions/v2");
const {onCall} = require("firebase-functions/v2/https");
const admin = require("firebase-admin");

// Initialize Firebase Admin SDK
admin.initializeApp();

// Callable function to send discount notifications
exports.sendDiscountNotification = onCall(async (data, context) => {
    // 1. Authentication Check
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "The function must be called while authenticated."
      );
    }
  
  // 2. Validate Input Data
  const { title, body } = data;
  
  if (!title || !body) {
    throw new functions.https.HttpsError(
        "invalid-argument",
        "The function must be called with title and body.",
    );
  }

  try {
    // 3. Create the Message Payload targeting the "offers" topic
    const message = {
      topic: "offers",
      notification: {
        title: title,
        body: body,
    },
    data: {
        // Any additional data you want to send
        // For example: offerId: "12345"
        },
      };
  
    // 4. Send the Notification via FCM to the "offers" topic
    const response = await admin.messaging().send(message);
    // eslint-disable-next-line max-len
    console.log(`Notification sent to "offers" topic successfully: ${response}`);
  
    return { success: true, message: "Notification sent to offers topic." };
  } catch (error) {
    console.error("Error sending offers notification:", error);
    // eslint-disable-next-line max-len
    throw new functions.https.HttpsError("internal", "Failed to send notification.");
    }
  });