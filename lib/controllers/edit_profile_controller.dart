import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_v2/controllers/home_controller.dart';
import 'package:pos_v2/core/services/api_services.dart';

import '../constants/api_urls.dart';
import '../constants/app_constants.dart';
import '../utils/snakbar_helper.dart';

class EditProfileController extends GetxController {
  final api = Get.find<ApiService>();

  RxBool uploadingImage = false.obs;
  RxBool updatingProfile = false.obs;
  RxString selectedImagePath = "".obs;
  RxString profileImage = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadUserImage();
  }

  void loadUserImage() {
    final user = AppConstants.currentUser.value?.userData;
    final images = user?.imageUrl?.imageUrls;

    if (images != null && images.isNotEmpty) {
      profileImage.value = images.first.trim();
    }
  }

  /// PICK IMAGE (Camera / Gallery)
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: source, imageQuality: 70);

    if (file != null) {
      selectedImagePath.value = file.path; // SAVE PATH
      await uploadUserProfileImage(file); // ⬅ Upload automatically
    }
  }

  /// UPLOAD IMAGE
  Future<void> uploadUserProfileImage(XFile file) async {
    try {
      uploadingImage.value = true;

      final headers = await AppConstants.getAuthHeaders();

      final response = await api.postMultipart(
        ApiUrls.uploadProfileImage,
        files: {"image": File(file.path)},
        headers: headers,
      );

      if (response['success'] == true) {
        HomeController controller = Get.find();
        controller.getUserData();
        loadUserImage();
        SnackbarHelper.showSuccess("Profile image uploaded successfully!");
      } else {
        SnackbarHelper.showError(
          response['message'] ?? "Error while uploading image",
        );
      }
    } catch (e) {
      SnackbarHelper.showError("Unexpected error occurred");
    } finally {
      uploadingImage.value = false;
    }
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required String username,
    required String phone,
    required String govId,
    required String country,
    required String city,
    required String address,
    required String dob,
  }) async {
    try {
      updatingProfile.value = true;
      final headers = await AppConstants.getAuthHeaders();
      final body = {
        "name": name,
        "email": email,
        // "username": username,
        "phone": phone,
        "gov_id": govId,
        "country": country,
        "city": city,
        "address": address,
        "dob": dob,
      };

      final response = await api.post(
        ApiUrls.updateProfileUrl,
        body: body,
        headers: headers,
      );

      if (response['success'] == true) {
        final HomeController homeController = Get.find<HomeController>();
        await homeController.getUserData();
        Get.back();
        SnackbarHelper.showSuccess("Profile updated successfully");
      } else {
        SnackbarHelper.showError(
          response['message'] ?? "Profile update failed",
        );
      }
    } on ApiException catch (e) {
      SnackbarHelper.showError(e.message);
    } catch (e) {
      SnackbarHelper.showError("An unexpected error occurred");
    } finally {
      updatingProfile.value = false;
    }
  }

  Future<void> updateFamilyMember({
    required String memberId,
    required String name,
    required String email,
    required String phone,
    required String govId,
    required String country,
    required String city,
    required String address,
    required String dob,
  }) async {
    try {
      updatingProfile.value = true;
      final headers = await AppConstants.getAuthHeaders();
      final body = {
        "name": name,
        "email": email,
        "customer_id": memberId,
        "phone": phone,
        "gov_id": govId,
        "country": country,
        "city": city,
        "address": address,
        "dob": dob,
      };

      final response = await api.post(
        ApiUrls.updateProfileUrl,
        body: body,
        headers: headers,
      );

      if (response['success'] == true) {
        final HomeController homeController = Get.find<HomeController>();
        await homeController.getUserData();
        Get.back();
        SnackbarHelper.showSuccess("Profile updated successfully");
      } else {
        SnackbarHelper.showError(
          response['message'] ?? "Profile update failed",
        );
      }
    } on ApiException catch (e) {
      SnackbarHelper.showError(e.message);
    } catch (e) {
      SnackbarHelper.showError("An unexpected error occurred");
    } finally {
      updatingProfile.value = false;
    }
  }

  /// BOTTOM SHEET
  void showImagePickerSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Select Image",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _imageOption(
                    icon: Icons.camera_alt,
                    label: "Camera",
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  _imageOption(
                    icon: Icons.photo_library,
                    label: "Gallery",
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  Widget _imageOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blue.withOpacity(0.1),
            child: Icon(icon, size: 28, color: Colors.blue),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
