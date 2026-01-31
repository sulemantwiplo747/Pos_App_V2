// import 'package:flutter/material.dart';
// import 'package:pos_v2/screens/register/register_controller.dart';

// class LocationInfoStep extends StatelessWidget {
//   final RegisterController controller;
//   final GlobalKey<FormState> formKey;

//   const LocationInfoStep({
//     super.key,
//     required this.controller,
//     required this.formKey,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const SizedBox(height: 20),

//         /// COUNTRY DROPDOWN
//         DropdownButtonFormField<String>(
//           initialValue: controller.countryController.text.isEmpty
//               ? null
//               : controller.countryController.text,
//           decoration: _inputDecoration("Country", Icons.public),
//           items: controller.countries
//               .map((c) => DropdownMenuItem(value: c, child: Text(c)))
//               .toList(),
//           onChanged: (value) {
//             if (value != null) {
//               controller.countryController.text = value;
//             }
//           },
//           validator: (value) => value == null ? "Select Country" : null,
//         ),

//         const SizedBox(height: 20),

//         /// CITY
//         TextFormField(
//           controller: controller.cityController,
//           decoration: _inputDecoration("City", Icons.location_city),
//           validator: (value) => controller.validateRequired(value, "City"),
//         ),

//         const SizedBox(height: 20),

//         /// ADDRESS
//         TextFormField(
//           controller: controller.addressController,
//           decoration: _inputDecoration("Address", Icons.home),
//           validator: (value) => controller.validateRequired(value, "Address"),
//         ),
//       ],
//     );
//   }

//   /// DECORATION
//   InputDecoration _inputDecoration(String label, IconData icon) {
//     return InputDecoration(
//       labelText: label,
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       prefixIcon: Icon(icon),
//     );
//   }
// }
