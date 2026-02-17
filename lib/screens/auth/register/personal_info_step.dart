import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos_v2/controllers/register_controller.dart';

class PersonalInfoStep extends StatelessWidget {
  final RegisterController controller;
  final GlobalKey<FormState> formKey;

  const PersonalInfoStep({
    super.key,
    required this.controller,
    required this.formKey,
  });

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.dob.value ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      controller.dob.value = picked;
      controller.dobController.text = controller.formattedDob;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),

        /// Name
        _buildTextField(
          label: 'name'.tr,
          icon: Icons.person,
          controller: controller.nameController,
          validator: (v) => controller.validateRequired(v, "name".tr),
        ),

        const SizedBox(height: 20),

        _buildTextField(
          label: 'username'.tr,
          icon: Icons.account_circle,
          controller: controller.usernameController,
          validator: (v) => controller.validateRequired(v, "username".tr),
        ),
        if (!controller.isFamilyMember) const SizedBox(height: 20),

        if (!controller.isFamilyMember)
          _buildTextField(
            label: 'email'.tr,
            icon: Icons.email,
            controller: controller.emailController,
            validator: controller.validateEmail,
            keyboardType: TextInputType.emailAddress,
          ),

        const SizedBox(height: 20),

        /// Phone Number
        _buildTextField(
          label: 'phone_number'.tr,
          icon: Icons.phone,
          controller: controller.phoneController,
          validator: (v) => controller.validateRequired(v, "phone_number".tr),
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(15),
          ],
        ),

        const SizedBox(height: 20),

        /// Government ID
        _buildTextField(
          label: 'government_id'.tr,
          icon: Icons.numbers,
          controller: controller.govIdController,
          validator: (v) => controller.validateGovId(v),
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
        ),

        const SizedBox(height: 20),

        /// Date of Birth
        TextFormField(
          controller: controller.dobController,
          readOnly: true,
          onTap: () => _selectDate(context),
          decoration: _inputDecoration(
            "date_of_birth".tr,
            Icons.calendar_today,
          ),
          validator: (v) => controller.validateRequired(v, "date_of_birth".tr),
        ),

        const SizedBox(height: 20),

        /// Address
        _buildTextField(
          label: 'address'.tr,
          icon: Icons.home,
          controller: controller.addressController,
          validator: (v) => controller.validateRequired(v, "address".tr),
        ),

        const SizedBox(height: 20),

        /// Password
        _buildTextField(
          label: 'password'.tr,
          icon: Icons.lock,
          controller: controller.passwordController,
          validator: controller.validatePassword,
          obscureText: true,
        ),

        const SizedBox(height: 20),

        /// Confirm Password
        TextFormField(
          obscureText: true,
          decoration: _inputDecoration(
            "confirm_password".tr,
            Icons.lock_outline,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return "confirm_password".tr;
            if (value != controller.passwordController.text)
              return "password_mismatch".tr;
            return null;
          },
        ),

        const SizedBox(height: 20),
        Text(
          "password_hint".tr,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: _inputDecoration(label, icon),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      prefixIcon: Icon(icon),
    );
  }
}
