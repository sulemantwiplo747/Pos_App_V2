import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pos_v2/constants/app_constants.dart';
import 'package:pos_v2/screens/auth/register/register_main_screen.dart';
import 'package:pos_v2/screens/family_member/family_screen.dart';
import 'package:pos_v2/screens/more_screen.dart';
import 'package:pos_v2/screens/recharge/wallert_recharge.dart';
import 'package:pos_v2/screens/sales/sales_detail.dart';
import 'package:pos_v2/screens/wallet_screen.dart';
import 'package:pos_v2/widgets/login_wrapper.dart';

import '../constants/shimmer.dart';
import '../controllers/bottom_nav_controller.dart';
import '../controllers/home_controller.dart';
import '../core/services/analytics_services.dart';
import '../utils/snakbar_helper.dart' show SnackbarHelper;
import '../widgets/custom_bottom_nav.dart';
import '../widgets/family_card.dart';
import '../widgets/order_tile.dart';
import '../widgets/wallet_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BottomNavController navController = Get.put(
    BottomNavController(),
    permanent: true,
  );

  final HomeController controller = Get.put(HomeController(), permanent: true);

  final Map<int, Widget> _pageCache = {};

  final Map<int, Widget Function()> _pageBuilders = {
    0: () => const _HomePageContent(),
    1: () => WalletScreen(),
    2: () => FamilyScreen(),
    3: () => const MoreScreen(),
  };

  @override
  void initState() {
    super.initState();
    _buildPageIfNeeded(0);
    controller.getCurrentBalance();
    ever(navController.currentIndex, (index) {
      _buildPageIfNeeded(index);
    });
  }

  void _buildPageIfNeeded(int index) {
    if (!_pageCache.containsKey(index)) {
      _pageCache[index] = _pageBuilders[index]!();
    }
  }

  void _onItemTapped(int index) {
    navController.changeIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: IndexedStack(
          index: navController.currentIndex.value,
          children: List.generate(
            _pageBuilders.length,
            (index) => _pageCache[index] ?? const SizedBox.shrink(),
          ),
        ),
        bottomNavigationBar: CustomBottomNav(
          currentIndex: navController.currentIndex.value,
          onTap: _onItemTapped,
        ),
      );
    });
  }
}

class _HomePageContent extends StatefulWidget {
  const _HomePageContent({super.key});

  @override
  State<_HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<_HomePageContent> {
  final controller = Get.find<HomeController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Load more when scrolled to bottom
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !controller.isLoadMore.value &&
          controller.hasMorePages) {
        controller.getUserSales(loadMore: true);
      }
    });

    // Initial fetch
    if (controller.sales == null) {
      controller.getUserSales();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Show full screen shimmer on first load
      if (controller.isSaleLoading.value && controller.sales == null) {
        return const HomeShimmer();
      }

      final salesData = controller.sales?.message?.data ?? [];

      return LoginWrapper(
        title: "pos".tr,
        onWalletTap: () {
          final homeState = context.findAncestorStateOfType<_HomeScreenState>();
          homeState?._onItemTapped(1);
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WalletCard(
                balance: AppConstants.safeParseBalance(
                  AppConstants.currentBalance.toString(),
                ),
                onRecharge: () {
                  Get.to(WalletRechargeScreen());
                },
              ),
              const SizedBox(height: 30),
              controller.isFamilyLoading.isTrue ||
                      controller.isUserLoading.isTrue
                  ? const ShimmerBox(height: 120, width: double.infinity)
                  : FamilyCard(
                      activeMembers:
                          AppConstants.familyMembers.value?.message?.total ?? 0,
                      onAddMember: () {
                        final currentUser =
                            AppConstants.currentUser.value?.userData;
                        final totalMembers =
                            AppConstants.familyMembers.value?.message?.total ??
                            0;

                        if (currentUser?.parentId != null) {
                          Get.find<BottomNavController>().changeIndex(2);
                        } else if (totalMembers >= 10) {
                          SnackbarHelper.showError(
                            "max_family_members_error".tr,
                          );
                        } else {
                          Get.to(RegisterScreen(isFamilyMember: true));
                        }
                      },
                      onViewMember: () {
                        Get.find<BottomNavController>().changeIndex(2);
                      },
                    ),

              const SizedBox(height: 30),
              Text(
                'recent_orders'.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              salesData.isEmpty
                  ? Center(
                      child: Column(
                        children: [
                          Lottie.asset(
                            "assets/lottie/no_data.json",
                            width: 140,
                            height: 140,
                            repeat: true,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'no_orders_yet'.tr,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: salesData.length + 1,
                      itemBuilder: (context, index) {
                        if (index < salesData.length) {
                          final order = salesData[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: InkWell(
                              onTap: () {
                                AnalyticsService.logScreen(
                                  screenName: 'OrderDetail',
                                );
                                Get.to(OrderDetailScreen(order: order));
                              },
                              child: OrderTile(
                                orderId: order.referenceCode ?? '',
                                status: order.status ?? '',
                                statusColor: getStatusColor(order.status),
                                date: controller.formatOrderDate(order.date),
                                amount: "SAR ${order.total ?? '0.00'}",
                                delayAnimation: 100 * (index + 1),
                              ),
                            ),
                          );
                        } else {
                          if (controller.isLoadMore.value) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        }
                      },
                    ),
            ],
          ),
        ),
      );
    });
  }

  // Map order status to color
  Color getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'on the way':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
