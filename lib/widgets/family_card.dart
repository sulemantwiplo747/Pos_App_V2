import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_v2/constants/app_constants.dart';

import '../constants/app_colors.dart';

class FamilyCard extends StatelessWidget {
  final int activeMembers;
  final VoidCallback onAddMember;
  final VoidCallback onViewMember;

  const FamilyCard({
    super.key,
    required this.activeMembers,
    required this.onAddMember,
    required this.onViewMember,
  });

  @override
  Widget build(BuildContext context) {
    final bool isParent =
        AppConstants.currentUser.value!.userData!.parentId == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'family'.tr,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: onAddMember,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blue[100],
                  child: const Icon(Icons.person_add, color: Colors.blue),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isParent
                            ? 'add_family_member'.tr
                            : 'explore_your_family'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        isParent
                            ? 'invite_manage_family'.tr
                            : 'see_family_people'.tr,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isParent ? Icons.chevron_right : Icons.explore,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: onViewMember,
          child: Text(
            'active_family_members'.trParams({
              'count': activeMembers.toString(),
            }),
            style: const TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
