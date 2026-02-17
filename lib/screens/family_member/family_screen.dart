import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pos_v2/constants/app_constants.dart';
import 'package:pos_v2/controllers/home_controller.dart';
import 'package:pos_v2/models/family_member_model.dart';
import 'package:pos_v2/screens/family_member/familt_member_title.dart';
import 'package:pos_v2/screens/family_member/family_member_detail.dart';
import 'package:pos_v2/widgets/login_wrapper.dart';

import '../../core/services/analytics_services.dart';
import '../../utils/snakbar_helper.dart';
import '../auth/register/register_main_screen.dart';

class FamilyScreen extends StatelessWidget {
  FamilyScreen({super.key});

  final HomeController controller = Get.find<HomeController>();

  final List<Color> avatarColors = [
    Colors.red,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.brown,
    Colors.green,
    Colors.teal,
  ];

  Color _randomColor() {
    return avatarColors[Random().nextInt(avatarColors.length)];
  }

  void _showDeleteDialog({
    required Accounts member,
    required HomeController controller,
    required int parentId,
  }) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('delete_family_member'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('confirm_remove_member'.trParams({'name': member.name ?? ''})),
            if (member.remainingBalance! > 0) ...[
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.orange.shade700,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'warning'.tr,
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'delete_member_warning'.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Get.back();
              await controller.deleteFamilyMember(
                accountId: member.id!,
                parentCustomerId: parentId,
              );
            },
            child: Text(
              'delete'.tr,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AnalyticsService.logScreen(screenName: 'FamilyScreen');
    });
    return LoginWrapper(
      title: "family".tr,
      child: Obx(
        () => RefreshIndicator(
          onRefresh: controller.getFamilyMember,
          child: controller.isFamilyLoading.value
              ? const Center(child: CircularProgressIndicator())
              : _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    final currentUser = AppConstants.currentUser.value!.userData;
    final isOwner = currentUser!.parentId == null;

    final displayUser = isOwner
        ? currentUser
        : AppConstants.familyOwner.value?.userData;

    final family = AppConstants.familyMembers.value;
    final members = family?.message?.accounts ?? [];
    List<Accounts> orderedMembers = [...members];

    if (!isOwner) {
      final myIndex = orderedMembers.indexWhere((e) => e.id == currentUser.id);
      if (myIndex != -1) {
        final me = orderedMembers.removeAt(myIndex);
        orderedMembers.insert(0, me);
      }
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPersonTile(
              name: displayUser?.name ?? '',
              email: displayUser?.email ?? '',
              role: 'owner'.tr,
              isOwner: true,
              avatarColor: Colors.red,
              imageUrl: displayUser?.imageUrl?.imageUrls?.first,
            ),

            const SizedBox(height: 20),

            Text(
              'lorem_text'.tr, // Translate key
              style: const TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 63, 63, 63),
              ),
            ),

            const SizedBox(height: 30),

            /// MEMBERS HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'members_count'.trParams({
                    'count': '${orderedMembers.length}',
                  }),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Visibility(
                  visible: isOwner,
                  child: TextButton.icon(
                    onPressed: () {
                      final totalMembers =
                          AppConstants.familyMembers.value?.message?.total ?? 0;

                      if (totalMembers >= 10) {
                        SnackbarHelper.showError("max_family_members".tr);
                      } else {
                        AnalyticsService.logScreen(screenName: 'AddMember');

                        Get.to(RegisterScreen(isFamilyMember: true));
                      }
                    },
                    icon: const Icon(Icons.add, size: 20),
                    label: Text('add_member'.tr),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// ✅ MEMBERS LIST OR INLINE EMPTY STATE
            if (orderedMembers.isEmpty)
              _buildInlineEmptyMembers()
            else
              ...List.generate(orderedMembers.length, (index) {
                final e = orderedMembers[index];
                final isMe = !isOwner && e.id == currentUser.id;

                return AnimatedFamilyMemberTile(
                  index: index,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        if (isOwner) {
                          AnalyticsService.logScreen(
                            screenName: 'FamilyMemberDetail',
                          );
                          Get.to(() => FamilyMemberDetailScreen(member: e));
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(.1),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildPersonTile(
                                name: e.name ?? '',
                                email: e.username ?? '',
                                role: 'member'.tr,
                                isOwner: isMe == true,
                                avatarColor: _randomColor(),
                                imageUrl:
                                    e.imageUrl?.imageUrls?.isNotEmpty == true
                                    ? e.imageUrl!.imageUrls!.first
                                    : null,
                              ),
                            ),

                            // Expanded(
                            //   child: _buildPersonTile(
                            //     name: e.name ?? '',
                            //     email: e.email ?? '',
                            //     role: 'member'.tr,
                            //     isOwner: isMe == true,
                            //     avatarColor: _randomColor(),
                            //     imageUrl: e.imageUrl?.imageUrls?.first,
                            //   ),
                            // ),
                            if (isOwner && e.id != currentUser.id)
                              Obx(() {
                                final isDeleting =
                                    controller.deletingMemberId.value == e.id;

                                return InkWell(
                                  onTap: isDeleting
                                      ? null
                                      : () {
                                          _showDeleteDialog(
                                            member: e,
                                            controller: controller,
                                            parentId: currentUser.id!,
                                          );
                                        },
                                  borderRadius: BorderRadius.circular(30),
                                  child: Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: isDeleting
                                        ? SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.red.shade400,
                                                  ),
                                            ),
                                          )
                                        : Icon(
                                            Icons.delete_outline_rounded,
                                            color: Colors.red.shade400,
                                            size: 22,
                                          ),
                                  ),
                                );
                              }),

                            // InkWell(
                            //   onTap: () {
                            //     _showDeleteDialog(
                            //       member: e,
                            //       controller: controller,
                            //       parentId: currentUser.id!,
                            //     );
                            //   },
                            //   borderRadius: BorderRadius.circular(30),
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(6),
                            //     child: Icon(
                            //       Icons.delete_outline_rounded,
                            //       color: Colors.red.shade400,
                            //       size: 22,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildInlineEmptyMembers() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            SizedBox(height: 60),
            Lottie.asset(
              'assets/lottie/family.json', // animation for empty members
              width: 120,
              height: 120,
              repeat: true,
            ),
            const SizedBox(height: 12),
            Text(
              'no_family_members'.tr,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// PERSON TILE (UNCHANGED UI)
  Widget _buildPersonTile({
    required String name,
    required String email,
    required String role,
    required bool isOwner,
    required Color avatarColor,
    String? imageUrl,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 23,
            backgroundColor: avatarColor.withOpacity(0.2),
            backgroundImage: imageUrl != null && imageUrl.isNotEmpty
                ? NetworkImage(imageUrl)
                : null,
            child: imageUrl == null || imageUrl.isEmpty
                ? Icon(Icons.person, color: avatarColor, size: 23)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                Text(email, style: const TextStyle(fontSize: 13)),
              ],
            ),
          ),
          Row(
            children: [
              Text(
                role,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: isOwner
                      ? const Color(0xffdd4610)
                      : const Color.fromARGB(255, 0, 65, 185).withOpacity(.5),
                ),
              ),
              if (isOwner) ...[
                const SizedBox(width: 4),
                const Icon(Icons.star, color: Colors.orange, size: 16),
              ],
            ],
          ),
        ],
      ),
    );
  }

  /// MEMBER CARD (UNCHANGED UI)
  Widget _buildMemberTitle({required Accounts account, bool? isME}) {
    final avatarColor = _randomColor();
    final imageUrl = account.imageUrl?.imageUrls?.isNotEmpty == true
        ? account.imageUrl!.imageUrls!.first
        : null;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(.1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: _buildPersonTile(
        name: account.name ?? '',
        email: account.email ?? '',
        role: 'member'.tr,
        isOwner: isME == true ? true : false,
        avatarColor: avatarColor,
        imageUrl: imageUrl,
      ),
    );
  }
}
