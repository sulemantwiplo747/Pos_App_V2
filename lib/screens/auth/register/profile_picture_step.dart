import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_v2/controllers/register_controller.dart';
import 'package:pos_v2/screens/home_screen.dart';

import '../../../controllers/bottom_nav_controller.dart';

class ProfilePictureStep extends StatelessWidget {
  final RegisterController controller;

  const ProfilePictureStep({super.key, required this.controller});

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (file != null) {
      controller.selectedImagePath.value = file.path;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),

          /// Title
          Text(
            "add_profile_picture".tr,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Text(
            "upload_photo_skip".tr,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
          ),

          const SizedBox(height: 30),

          /// Profile Image Preview
          CircleAvatar(
            radius: 65,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: controller.selectedImagePath.value.isNotEmpty
                ? FileImage(File(controller.selectedImagePath.value))
                : null,
            child: controller.selectedImagePath.value.isEmpty
                ? const Icon(Icons.person, color: Colors.white, size: 60)
                : null,
          ),

          const SizedBox(height: 30),

          /// Upload Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildOptionButton(
                icon: Icons.camera_alt,
                label: "camera".tr,
                onTap: () => _pickImage(ImageSource.camera),
              ),
              const SizedBox(width: 20),
              _buildOptionButton(
                icon: Icons.photo_library,
                label: "gallery".tr,
                onTap: () => _pickImage(ImageSource.gallery),
              ),
            ],
          ),

          const SizedBox(height: 25),

          /// Skip Button
          TextButton(
            onPressed: () {
              controller.selectedImagePath.value = "";
              if (controller.isFamilyMember) {
                Get.find<BottomNavController>().changeIndex(0);
              }
              Get.offAll(HomeScreen());
            },
            child: Text(
              "skip_now".tr,
              style: const TextStyle(fontSize: 16, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              blurRadius: 6,
            ),
          ],
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Icon(icon, size: 30, color: Colors.blue),
            const SizedBox(height: 6),
            Text(label),
          ],
        ),
      ),
    );
  }
}
