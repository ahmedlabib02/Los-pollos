// // lib/screens/authenticate/register.dart

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:los_pollos_hermanos/services/auth.dart';
// import 'package:los_pollos_hermanos/shared/loadingScreen.dart';

// class Register extends StatefulWidget {
//   final Function toggleView;
//   const Register({super.key, required this.toggleView});

//   @override
//   State<Register> createState() => _RegisterState();
// }

// class _RegisterState extends State<Register> {
//   // Form key for validation
//   final _formKey = GlobalKey<FormState>();

//   // Instance of AuthService
//   final AuthService _authService = AuthService();

//   // Controllers for text fields
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();

//   // State variables
//   bool _isLoading = false;
//   String? _errorMessage;

//   // Dispose controllers to free resources
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   // Registration method
//   Future<void> _register() async {
//     if (_formKey.currentState!.validate()) {
//       // Start loading
//       setState(() {
//         _isLoading = true;
//         _errorMessage = null;
//       });

//       try {
//         // Attempt to register the user
//         await _authService.registerClient(
//           email: _emailController.text,
//           password: _passwordController.text,
//           name: _nameController.text, // Pass name here
//         );
//         // On success, navigation is handled by the Wrapper widget
//       } on FirebaseAuthException catch (e) {
//         setState(() {
//           _errorMessage = e.message;
//         });
//       } catch (e) {
//         setState(() {
//           _errorMessage = 'An unexpected error occurred.';
//         });
//       } finally {
//         // Stop loading
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   // Build method for UI
//   @override
//   Widget build(BuildContext context) {
//     return _isLoading
//         ? const Loading()
//         : Scaffold(
//             appBar: AppBar(
//               title: const Text('Register to Los Pollos'),
//               actions: [
//                 IconButton(
//                   icon: const Icon(Icons.person),
//                   tooltip: 'Sign In',
//                   onPressed: () => widget.toggleView(),
//                 ),
//               ],
//             ),
//             body: Center(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Card(
//                   elevation: 8.0,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10)),
//                   child: Padding(
//                     padding: const EdgeInsets.all(24.0),
//                     child: Form(
//                       key: _formKey,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           // Name Field
//                           TextFormField(
//                             controller: _nameController,
//                             decoration: const InputDecoration(
//                               labelText: 'Name',
//                               prefixIcon: Icon(Icons.person),
//                               border: OutlineInputBorder(),
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter your name';
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(height: 20),
//                           // Email Field
//                           TextFormField(
//                             controller: _emailController,
//                             decoration: const InputDecoration(
//                               labelText: 'Email',
//                               prefixIcon: Icon(Icons.email),
//                               border: OutlineInputBorder(),
//                             ),
//                             keyboardType: TextInputType.emailAddress,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter your email';
//                               }
//                               final emailRegex = RegExp(
//                                   r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@"
//                                   r"[a-zA-Z0-9]+\.[a-zA-Z]+");
//                               if (!emailRegex.hasMatch(value)) {
//                                 return 'Please enter a valid email';
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(height: 20),
//                           // Password Field
//                           TextFormField(
//                             controller: _passwordController,
//                             decoration: const InputDecoration(
//                               labelText: 'Password',
//                               prefixIcon: Icon(Icons.lock),
//                               border: OutlineInputBorder(),
//                             ),
//                             obscureText: true,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter your password';
//                               }
//                               if (value.length < 6) {
//                                 return 'Password must be at least 6 characters';
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(height: 20),
//                           // Confirm Password Field
//                           TextFormField(
//                             controller: _confirmPasswordController,
//                             decoration: const InputDecoration(
//                               labelText: 'Confirm Password',
//                               prefixIcon: Icon(Icons.lock),
//                               border: OutlineInputBorder(),
//                             ),
//                             obscureText: true,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please confirm your password';
//                               }
//                               if (value != _passwordController.text) {
//                                 return 'Passwords do not match';
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(height: 20),
//                           // Error Message
//                           if (_errorMessage != null)
//                             Text(
//                               _errorMessage!,
//                               style: const TextStyle(color: Colors.red),
//                             ),
//                           if (_errorMessage != null) const SizedBox(height: 10),
//                           // Register Button
//                           SizedBox(
//                             width: double.infinity,
//                             child: ElevatedButton(
//                               onPressed: _register,
//                               child: _isLoading
//                                   ? const SizedBox(
//                                       width: 24,
//                                       height: 24,
//                                       child: CircularProgressIndicator(
//                                         valueColor:
//                                             AlwaysStoppedAnimation<Color>(
//                                                 Colors.white),
//                                         strokeWidth: 2.0,
//                                       ),
//                                     )
//                                   : const Text('Register'),
//                               style: ElevatedButton.styleFrom(
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 16.0),
//                                 textStyle: const TextStyle(fontSize: 16),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//   }
// }
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:los_pollos_hermanos/services/auth.dart';
import 'package:los_pollos_hermanos/shared/loadingScreen.dart';
import 'package:uuid/uuid.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  const Register({super.key, required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Instance of AuthService
  final AuthService _authService = AuthService();

  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // State variables
  bool _isLoading = false;
  String? _errorMessage;
  File? _selectedImage;
  String _imageUrl = ''; // Store the URL of the uploaded image
  late ImagePicker imagePicker;

  // Dispose controllers to free resources
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Registration method
  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      // Start loading
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        // If there is an image, upload it
        if (_selectedImage != null) {
          String imageUrl = await _uploadImageToFirebase(_selectedImage!);
          if (imageUrl.isEmpty) {
            setState(() {
              _errorMessage = 'Failed to upload image';
            });
            _imageUrl = '';
          } else {
            _imageUrl = imageUrl;
          }
        }

        // Attempt to register the user with the image URL
        await _authService.registerClient(
          email: _emailController.text,
          password: _passwordController.text,
          name: _nameController.text,
          imageUrl: _imageUrl, // Send the image URL to Firebase
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          _errorMessage = e.message;
        });
      } catch (e) {
        setState(() {
          _errorMessage = 'An unexpected error occurred.';
        });
      } finally {
        // Stop loading
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker(); // Initialize the picker
  }

  // Method to upload image to Firebase Storage
  Future<String> _uploadImageToFirebase(File image) async {
    try {
      // Create a unique ID for the image
      String fileName = Uuid().v4();
      // Create a reference to the Firebase Storage
      Reference storageRef =
          FirebaseStorage.instance.ref().child('profile_images/$fileName.jpg');

      // Upload the image to Firebase Storage
      UploadTask uploadTask = storageRef.putFile(image);

      print('Uploading image...');
      TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
      print('Image uploaded!');
      // Get the image URL
      String imageUrl = await snapshot.ref.getDownloadURL();

      return imageUrl;
    } catch (e) {
      print('Failed to upload image: $e');
      return ''; // Return empty string if upload fails
    }
  }

  // Image picker method
  Future<void> _pickImage() async {
    try {
      final pickedFile = await imagePicker.pickImage(
        source: ImageSource.gallery, // Or ImageSource.camera
        maxHeight: 300,
        maxWidth: 300,
        imageQuality: 80, // Compress image
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to pick image: $e';
      });
    }
  }

  // Build method for UI
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Register to Los Pollos'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.person),
                  tooltip: 'Sign In',
                  onPressed: () => widget.toggleView(),
                ),
              ],
            ),
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: _pickImage,
                            child: CircleAvatar(
             
                              radius: 50,
                              backgroundImage: _selectedImage != null
                                  ? FileImage(_selectedImage!)
                                  : null,
                              child: _selectedImage == null
                                  ? const Icon(Icons.add_a_photo, size: 50)
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Other form fields go here
                          // Name Field
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          // Email Field
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              final emailRegex = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@"
                                  r"[a-zA-Z0-9]+\.[a-zA-Z]+");
                              if (!emailRegex.hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          // Password Field
                          TextFormField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          // Confirm Password Field
                          TextFormField(
                            controller: _confirmPasswordController,
                            decoration: const InputDecoration(
                              labelText: 'Confirm Password',
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          // Error Message
                          if (_errorMessage != null)
                            Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          if (_errorMessage != null) const SizedBox(height: 10),
                          // Register Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _register,
                              child: const Text('Register'),
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                textStyle: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
