import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pos_v2/constants/enums.dart';
import 'package:pos_v2/controllers/wallet_controller.dart';
import 'package:pos_v2/widgets/login_wrapper.dart';
import 'package:pos_v2/widgets/wallet_card.dart';
import 'package:pos_v2/widgets/wallet_transaction_tile.dart';
import 'package:shimmer/shimmer.dart';

import '../constants/app_constants.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final WalletController controller = Get.put(WalletController());
    final ScrollController scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        if (controller.hasMore &&
            !controller.isLoadMore.value &&
            !controller.isLoading.value) {
          controller.loadNextPage();
        }
      }
    });

    return LoginWrapper(
      title: "wallet".tr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: WalletCard(
              balance: AppConstants.safeParseBalance(
                AppConstants.currentBalance.toString(),
              ),
              onRecharge: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Obx(() {
              return Row(
                children: [
                  Expanded(
                    child: Text(
                      'transaction_limit_text'.trParams({
                        'limit': controller.transactionLimit.value
                            .toInt()
                            .toString(),
                      }),
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ),
                  GestureDetector(
                    onTap: () =>
                        controller.showLimitBottomSheet(context, controller),
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit,
                          size: 18,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'change_limit'.tr,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'recent_transactions'.tr,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.transactions.isEmpty) {
                return _buildShimmerList();
              }
              if (controller.transactions.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () => controller.fetchTransactions(),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: 120),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              "assets/lottie/empty.json",
                              width: 140,
                              height: 140,
                              repeat: true,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'no_transaction_yet'.tr,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }

              // if (controller.transactions.isEmpty) {
              //   return Center(
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Lottie.asset(
              //           "assets/lottie/empty.json",
              //           width: 140,
              //           height: 140,
              //           repeat: true,
              //         ),
              //         const SizedBox(height: 16),
              //         Text(
              //           'no_transaction_yet'.tr,
              //           style: const TextStyle(
              //             fontSize: 16,
              //             color: Colors.grey,
              //           ),
              //         ),
              //       ],
              //     ),
              //   );
              // }

              return RefreshIndicator(
                onRefresh: () => controller.fetchTransactions(),
                child: ListView.builder(
                  controller: scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount:
                      controller.transactions.length +
                      (controller.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == controller.transactions.length) {
                      return const Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final txn = controller.transactions[index];

                    final type =
                        (txn.transactionType?.toLowerCase() ?? 'debit') ==
                            'credit'
                        ? TransactionType.credit
                        : TransactionType.debit;

                    final color = type == TransactionType.credit
                        ? Colors.green
                        : Colors.redAccent;

                    final formattedAmount = type == TransactionType.credit
                        ? '+SAR ${((txn.amount ?? 0)).toStringAsFixed(2)}'
                        : '-SAR ${((txn.amount ?? 0)).toStringAsFixed(2)}';

                    final date = txn.createdAt?.split(' ').first ?? '';

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: WalletTransactionTile(
                        transactionId: txn.transactionId ?? '#TRX${txn.id}',
                        transactionType: type,
                        statusColor: color,
                        date: date,
                        amount: formattedAmount,
                        index: index,
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(width: 40, height: 40, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(height: 14, width: 150, color: Colors.white),
                        const SizedBox(height: 8),
                        Container(height: 12, width: 100, color: Colors.white),
                      ],
                    ),
                  ),
                  Container(
                    width: 70,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(width: 80, height: 20, color: Colors.white),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
