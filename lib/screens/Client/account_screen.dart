import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:los_pollos_hermanos/screens/Client/change_password.dart';
import 'package:los_pollos_hermanos/screens/Client/order_history_screen.dart'; // Import OrderHistoryScreen
import 'package:provider/provider.dart';
import 'package:los_pollos_hermanos/models/client_model.dart';
import 'package:los_pollos_hermanos/models/customUser.dart';
import 'package:los_pollos_hermanos/services/client_services.dart';
import 'package:uuid/uuid.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late Future<Client?> _clientData;
  late String? _imageUrl;
  bool _isUploading = false; // Track if upload is in progress

  final ImagePicker _picker = ImagePicker();

  Future<void> _fetchClientData(CustomUser user) async {
    try {
      _clientData = ClientService().getClient(user.uid);
      setState(() {});
    } catch (e) {
      print('Error fetching client data: $e');
    }
  }

  Future<void> _updateProfileImage(Client client) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 300,
      maxWidth: 300,
      imageQuality: 80,
    );
    if (pickedFile == null) return;

    try {
      setState(() {
        _isUploading = true; // Start loading
      });

      File imageFile = File(pickedFile.path);
      String imagePath = 'profile_images/${Uuid().v4()}.jpg';
      if (client.imageUrl.isNotEmpty) {
        await FirebaseStorage.instance.refFromURL(client.imageUrl).delete();
      }
      UploadTask uploadTask =
          FirebaseStorage.instance.ref().child(imagePath).putFile(imageFile);

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      client.imageUrl = downloadUrl;
      await ClientService().updateClient(client);

      setState(() {
        _isUploading = false; // Stop loading when upload finishes
        _imageUrl = downloadUrl; // Update the image URL
      });
    } catch (e) {
      setState(() {
        _isUploading = false; // Stop loading if error occurs
      });
      print('Error uploading image: $e');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final user = Provider.of<CustomUser?>(context);
    if (user != null) {
      _fetchClientData(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Client?>(
      future: _clientData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No client data found.'));
        }

        final client = snapshot.data!;
        _imageUrl = client.imageUrl.isNotEmpty ? client.imageUrl : null;

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey,
                        child: _isUploading // Show loading while uploading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : (_imageUrl != null
                                ? ClipOval(
                                    child: Image.network(
                                      _imageUrl!,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      (loadingProgress
                                                              .expectedTotalBytes ??
                                                          1)
                                                  : null,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () => _updateProfileImage(client),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  )),
                      ),
                      (_imageUrl != null || _isUploading)
                          ? Positioned(
                              right: -10,
                              bottom: -10,
                              child: ClipOval(
                                child: Material(
                                  color: Colors.grey.withOpacity(
                                      0.3), // Adjust transparency (0.5 is 50% transparent)
                                  child: IconButton(
                                    icon: const Icon(Icons.camera_alt,
                                        size: 20, color: Colors.white),
                                    onPressed: () =>
                                        _updateProfileImage(client),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink()
                    ],
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        client.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        client.email,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Options to change password and view past bills
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Change Password'),
                onTap: () {
                  showChangePasswordSheet(context);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('View Past Orders'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderHistoryScreen(),
                    ),
                  );
                },
              ),
              const Divider(),
            ],
          ),
        );
      },
    );
  }
}
