// // lib/screens/manager/send_notification.dart

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class SendNotification extends StatefulWidget {
//   const SendNotification({super.key});

//   @override
//   State<SendNotification> createState() => _SendNotificationState();
// }

// class _SendNotificationState extends State<SendNotification> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _bodyController = TextEditingController();

//   bool _isLoading = false;
//   String? _errorMessage;

//   Future<void> _sendNotification() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//         _errorMessage = null;
//       });

//       try {
//         String title = _titleController.text.trim();
//         String body = _bodyController.text.trim();

//         await FirebaseFirestore.instance.collection('notifications').add({
//           'title': title,
//           'body': body,
//           'timestamp': FieldValue.serverTimestamp(),
//         });

//         _titleController.clear();
//         _bodyController.clear();

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Notification sent successfully')),
//         );
//       } catch (e) {
//         setState(() {
//           _errorMessage = 'Failed to send notification.';
//         });
//       } finally {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }
// }
