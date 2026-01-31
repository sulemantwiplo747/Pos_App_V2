// import 'package:flutter/material.dart';
// import 'package:pos_v2/controllers/register_controller.dart';

// class AccountInfoStep extends StatelessWidget {
//   final RegisterController controller;
//   final GlobalKey<FormState> formKey;

//   const AccountInfoStep({
//     super.key,
//     required this.controller,
//     required this.formKey,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const SizedBox(height: 20),

//         /// USERNAME
//         TextFormField(
//           controller: controller.usernameController,
//           decoration: _inputDecoration("Username", Icons.account_circle),
//           validator: (value) => controller.validateRequired(value, "Username"),
//         ),

//         const SizedBox(height: 20),

//         /// PASSWORD
//         TextFormField(
//           controller: controller.passwordController,
//           obscureText: true,
//           decoration: _inputDecoration("Password", Icons.lock),
//           validator: controller.validatePassword,
//         ),

//         const SizedBox(height: 20),

//         /// CONFIRM PASSWORD
//         TextFormField(
//           obscureText: true,
//           decoration: _inputDecoration("Confirm Password", Icons.lock_outline),
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return "Confirm Password";
//             }
//             if (value != controller.passwordController.text) {
//               return "Passwords do not match";
//             }
//             return null;
//           },
//         ),

//         const SizedBox(height: 20),

//         const Text(
//           "Password must be at least 6 characters long",
//           style: TextStyle(color: Colors.grey, fontSize: 12),
//         ),
//       ],
//     );
//   }

//   /// INPUT DECORATION
//   InputDecoration _inputDecoration(String label, IconData icon) {
//     return InputDecoration(
//       labelText: label,
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       prefixIcon: Icon(icon),
//     );
//   }
// }
