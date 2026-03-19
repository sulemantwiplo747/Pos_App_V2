import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';

/// Beautiful, modern error/offline UI using app's blue color scheme.
class AppErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final bool compact;

  const AppErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _buildCompact(context);
    }
    return _buildFull(context);
  }

  Widget _buildFull(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIllustration(),
              const SizedBox(height: 24),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              _buildRetryButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompact(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIllustration(),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          _buildRetryButton(),
        ],
      ),
    );
  }

  Widget _buildIllustration() {
    final isCompact = compact;
    final size = isCompact ? 64.0 : 120.0;
    final iconSize = isCompact ? 32.0 : 52.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryBlue.withOpacity(0.12),
            AppColors.lightBlue.withOpacity(0.06),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.15),
            blurRadius: isCompact ? 12 : 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.wifi_off_rounded,
          size: iconSize,
          color: AppColors.primaryBlue,
        ),
      ),
    );
  }

  Widget _buildRetryButton() {
    final isCompact = compact;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onRetry,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 20 : 32,
            vertical: isCompact ? 10 : 14,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primaryBlue, AppColors.lightBlue],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue.withOpacity(0.3),
                blurRadius: isCompact ? 8 : 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.refresh_rounded,
                color: Colors.white,
                size: compact ? 18 : 22,
              ),
              SizedBox(width: compact ? 6 : 10),
              Text(
                'retry'.tr,
                style: TextStyle(
                  fontSize: compact ? 14 : 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
