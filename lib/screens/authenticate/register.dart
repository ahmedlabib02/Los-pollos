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
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  File? _selectedImage;
  String _imageUrl = '';
  late ImagePicker imagePicker;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        if (_selectedImage != null) {
          String imageUrl = await _uploadImageToFirebase(_selectedImage!);
          _imageUrl = imageUrl;
        }

        await _authService.registerClient(
          email: _emailController.text,
          password: _passwordController.text,
          name: _nameController.text,
          imageUrl: _imageUrl,
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
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<String> _uploadImageToFirebase(File image) async {
    try {
      String fileName = Uuid().v4();
      Reference storageRef =
          FirebaseStorage.instance.ref().child('profile_images/$fileName.jpg');
      UploadTask uploadTask = storageRef.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Failed to upload image: $e');
      return '';
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await imagePicker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 300,
        maxWidth: 300,
        imageQuality: 80,
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

  @override
  Widget build(BuildContext context) {
    const Color gradientStart = Color(0xFFFDE68A);
    const Color gradientEnd = Color(0xFFFFB800);
    const Color primaryColor = Color(0xFFFFC107);
    const Color backgroundColor = Colors.white;

    return _isLoading
        ? const Loading()
        : Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [gradientStart, gradientEnd],
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Image Picker
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          backgroundImage: _selectedImage != null
                              ? FileImage(_selectedImage!)
                              : null,
                          child: _selectedImage == null
                              ? const Icon(Icons.add_a_photo,
                                  size: 40, color: gradientEnd)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Form Card
                      Card(
                        color: backgroundColor,
                        elevation: 8.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                _buildTextField(
                                    _nameController, 'Name', Icons.person),
                                const SizedBox(height: 16),
                                _buildTextField(
                                    _emailController, 'Email', Icons.email),
                                const SizedBox(height: 16),
                                _buildTextField(
                                    _passwordController, 'Password', Icons.lock,
                                    isObscure: true),
                                const SizedBox(height: 16),
                                _buildTextField(_confirmPasswordController,
                                    'Confirm Password', Icons.lock,
                                    isObscure: true),
                                const SizedBox(height: 20),

                                // Error Message
                                if (_errorMessage != null)
                                  Text(
                                    _errorMessage!,
                                    style: const TextStyle(color: Colors.red),
                                  ),

                                // Register Button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _register,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14.0,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                    ),
                                    child: const Text(
                                      'Register',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Return to Sign In
                                TextButton(
                                  onPressed: () => widget.toggleView(),
                                  child: const Text(
                                    'Already have an account? Sign In',
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isObscure = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        return null;
      },
    );
  }
}
