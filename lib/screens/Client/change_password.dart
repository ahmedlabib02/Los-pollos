// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// void showChangePasswordSheet(BuildContext context) {
//   final _formKey = GlobalKey<FormState>();
//   final _oldPasswordController = TextEditingController();
//   final _newPasswordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();

//   bool _isLoading = false;

//   Future<void> _changePassword(BuildContext context) async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         // Show loading
//         _isLoading = true;
//         (context as Element).markNeedsBuild();

//         User? user = FirebaseAuth.instance.currentUser;

//         // Reauthenticate user to confirm old password
//         final credential = EmailAuthProvider.credential(
//           email: user!.email!,
//           password: _oldPasswordController.text,
//         );
//         await user.reauthenticateWithCredential(credential);

//         // Update password
//         await user.updatePassword(_newPasswordController.text);

//         // Hide loading and close sheet
//         _isLoading = false;
//         (context as Element).markNeedsBuild();

//         Navigator.of(context).pop();
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Password updated successfully!')),
//         );
//       } on FirebaseAuthException catch (e) {
//         // Handle Firebase exceptions
//         _isLoading = false;
//         (context as Element).markNeedsBuild();

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: ${e.message}')),
//         );
//       } catch (e) {
//         _isLoading = false;
//         (context as Element).markNeedsBuild();

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('An unexpected error occurred.')),
//         );
//       }
//     }
//   }

//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     builder: (context) {
//       return Padding(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom,
//         ),
//         child: StatefulBuilder(
//           builder: (context, setState) {
//             return SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Change Password',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         controller: _oldPasswordController,
//                         obscureText: true,
//                         decoration: const InputDecoration(
//                           labelText: 'Old Password',
//                           border: OutlineInputBorder(),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your old password';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         controller: _newPasswordController,
//                         obscureText: true,
//                         decoration: const InputDecoration(
//                           labelText: 'New Password',
//                           border: OutlineInputBorder(),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter a new password';
//                           } else if (value.length < 6) {
//                             return 'Password must be at least 6 characters long';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         controller: _confirmPasswordController,
//                         obscureText: true,
//                         decoration: const InputDecoration(
//                           labelText: 'Confirm New Password',
//                           border: OutlineInputBorder(),
//                         ),
//                         validator: (value) {
//                           if (value != _newPasswordController.text) {
//                             return 'Passwords do not match';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 24),
//                       _isLoading
//                           ? const Center(child: CircularProgressIndicator())
//                           : ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.yellow[700],
//                                 foregroundColor: Colors.black,
//                                 minimumSize: const Size(double.infinity, 50.0),
//                                 maximumSize: const Size(double.infinity, 50.0),
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 10.0),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10.0),
//                                 ),
//                               ),
//                               onPressed: () {
//                                 setState(() => _isLoading = true);
//                                 _changePassword(context).then((_) {
//                                   setState(() => _isLoading = false);
//                                 });
//                               },
//                               child: const Text(
//                                 'Confirm',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                       const SizedBox(height: 8),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       );
//     },
//   );
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void showChangePasswordSheet(BuildContext context) {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _changePassword(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        // Show loading
        _isLoading = true;
        _errorMessage = null;
        (context as Element).markNeedsBuild();

        User? user = FirebaseAuth.instance.currentUser;

        // Reauthenticate user to confirm old password
        final credential = EmailAuthProvider.credential(
          email: user!.email!,
          password: _oldPasswordController.text,
        );
        await user.reauthenticateWithCredential(credential);

        // Update password
        await user.updatePassword(_newPasswordController.text);

        // Hide loading and close sheet
        _isLoading = false;
        (context as Element).markNeedsBuild();

        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password updated successfully!')),
        );
      } on FirebaseAuthException catch (e) {
        _isLoading = false;
        (context as Element).markNeedsBuild();
        if (e.code == 'invalid-credential') {
          _errorMessage = 'Incorrect old password. Please try again.';
        } else {
          _errorMessage = e.code;
        }
      } catch (e) {
        _isLoading = false;
        _errorMessage = 'An unexpected error occurred.';
        (context as Element).markNeedsBuild();
      }
    }
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Change Password',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      TextFormField(
                        controller: _oldPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Old Password',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your old password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _newPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'New Password',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a new password';
                          } else if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Confirm New Password',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value != _newPasswordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellow[700],
                                foregroundColor: Colors.black,
                                minimumSize: const Size(double.infinity, 50.0),
                                maximumSize: const Size(double.infinity, 50.0),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              onPressed: () {
                                setState(() => _isLoading = true);
                                _changePassword(context).then((_) {
                                  setState(() => _isLoading = false);
                                });
                              },
                              child: const Text(
                                'Confirm',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}