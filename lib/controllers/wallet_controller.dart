import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pos_v2/constants/api_urls.dart';
import 'package:pos_v2/controllers/home_controller.dart';
import 'package:pos_v2/models/transaction_model.dart';

import '../../../utils/error_message_helper.dart';
import '../../../utils/snakbar_helper.dart';
import '../constants/app_constants.dart';
import '../core/services/analytics_services.dart';
import '../core/services/api_services.dart';
import '../screens/auth/widget/success_dialoug.dart';

class WalletController extends GetxController {
  final api = Get.find<ApiService>();
  RxBool isTransferring = false.obs;
  var transactions = <Transactions>[].obs;
  var isLoading = false.obs;
  var isLoadMore = false.obs;
  final box = GetStorage();
  RxDouble currentBalance = 0.0.obs;
  RxBool isTransactionLoading = false.obs;
  RxDouble transactionLimit = 0.0.obs;
  RxInt maxDailyTransaction = 0.obs;
  RxBool isChildLimitLoading = false.obs;
  RxDouble childMaxPerTransaction = 0.0.obs;
  RxInt childMaxDailyTransaction = 0.obs;
  RxDouble tempChildMaxPerTxn = 10.0.obs;
  RxDouble tempChildMaxDailyTxn = 10.0.obs;
  int currentPage = 1;
  int perPage = 15;
  bool hasMorePages = true;
  /// Set when fetchTransactions fails (initial load); null on success.
  final fetchError = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
    getTransactionLimit();
    AnalyticsService.logScreen(screenName: 'WalletScreen');
    // transactionLimit.value = box.read('txn_limit') ?? 300.0;
  }

  void showLimitBottomSheet(BuildContext context, WalletController controller) {
    final RxDouble tempLimit = controller.transactionLimit.value.obs;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'set_transaction_limit'.tr,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'adjust_daily_limit'.tr,
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Obx(
              () => Column(
                children: [
                  Text(
                    'SAR ${tempLimit.value.toInt()}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Slider(
                    min: 100,
                    max: 10000,
                    divisions: 99,
                    value: tempLimit.value,
                    onChanged: (value) {
                      tempLimit.value = value;
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: controller.isTransactionLoading.isTrue
                    ? Center(
                        child: CircularProgressIndicator(color: Colors.blue),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          controller.updateTransactionLimit(
                            newValue: tempLimit.value.toString(),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // same as login
                          foregroundColor: Colors.white,
                          minimumSize: const Size(
                            double.infinity,
                            50,
                          ), // same height
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'confirm'.tr,
                          style: TextStyle(fontSize: 18), // same text size
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Future<void> reverseTransferToParent({
    required int fromCustomerId, // member ID who is reversing
    required double amount,
  }) async {
    try {
      isTransferring.value = true;

      final headers = await AppConstants.getAuthHeaders();

      final data = await api.post(
        ApiUrls.transferBalance, // same endpoint
        headers: headers,
        body: {
          "from_customer_id": fromCustomerId,
          "to_customer_id": AppConstants.currentUser.value!.userData!.id,
          "amount": amount,
        },
      );

      if (data['success'] == true) {
        SnackbarHelper.showSuccess(
          data['message']['message'] ?? 'Amount reversed successfully',
        );
        // update balances
        currentBalance.value = currentBalance.value - amount;
        fetchCustomerTransactions(customerId: fromCustomerId);
        fetchTransactions();
        final HomeController homeController = Get.find<HomeController>();
        await homeController.getCurrentBalance();
      } else {
        SnackbarHelper.showError(data['message'] ?? 'Reverse transfer failed');
      }
    } catch (e) {
      SnackbarHelper.showApiError(e);
    } finally {
      isTransferring.value = false;
    }
  }

  Future<void> transferAmountToMember({
    required int toCustomerId,
    required double amount,
  }) async {
    try {
      isTransferring.value = true;

      final headers = await AppConstants.getAuthHeaders();

      final data = await api.post(
        ApiUrls.transferBalance,
        headers: headers,
        body: {"to_customer_id": toCustomerId, "amount": amount},
      );

      if (data['success'] == true) {
        SnackbarHelper.showSuccess(
          data['message']['message'] ?? 'Amount transferred successfully',
        );
        currentBalance.value = currentBalance.value + amount;
        fetchCustomerTransactions(customerId: toCustomerId);
        fetchTransactions();
        final HomeController homeController = Get.find<HomeController>();
        await homeController.getCurrentBalance();
      } else {
        SnackbarHelper.showError(data['message'] ?? 'Transfer failed');
      }
    } catch (e) {
      SnackbarHelper.showApiError(e);
    } finally {
      isTransferring.value = false;
    }
  }

  Future<void> fetchTransactions({bool loadMore = false}) async {
    if (!loadMore) {
      currentPage = 1;
      hasMorePages = true;
      fetchError.value = null;
    }

    if (!hasMorePages) return;

    try {
      if (loadMore) {
        isLoadMore.value = true;
      } else {
        isLoading.value = true;
        transactions.clear();
      }

      final headers = await AppConstants.getAuthHeaders();
      final data = await api.get(
        ApiUrls.getTransactionsUrl,
        headers: headers,
        queryParameters: {
          "page": currentPage.toString(),
          "per_page": perPage.toString(),
        },
      );

      if (data['success'] == true) {
        final model = TransactionMode.fromJson(data);

        if (loadMore) {
          transactions.addAll(model.message?.transactions ?? []);
        } else {
          transactions.value = model.message?.transactions ?? [];
        }

        currentPage =
            (model.message?.pagination?.currentPage ?? currentPage) + 1;
        hasMorePages =
            currentPage <= (model.message?.pagination?.lastPage ?? currentPage);
      } else {
        final msg = data['message']?.toString() ?? 'error_loading_transactions'.tr;
        if (!loadMore) fetchError.value = msg;
        SnackbarHelper.showError(ErrorMessageHelper.toUserMessage(
          ApiException(message: msg, data: null),
          fallbackKey: 'error_loading_transactions',
        ));
      }
    } on ApiException catch (e) {
      final msg = ErrorMessageHelper.toUserMessage(e, fallbackKey: 'error_loading_transactions');
      if (!loadMore) fetchError.value = msg;
      SnackbarHelper.showError(msg);
    } catch (e) {
      final msg = ErrorMessageHelper.toUserMessage(e, fallbackKey: 'error_loading_transactions');
      if (!loadMore) fetchError.value = msg;
      SnackbarHelper.showError(msg);
    } finally {
      isLoading.value = false;
      isLoadMore.value = false;
    }
  }

  bool get hasMore => hasMorePages;
  Future<void> getTransactionLimit() async {
    try {
      isTransactionLoading.value = true;
      final headers = await AppConstants.getAuthHeaders();
      final data = await api.get(ApiUrls.walletLimitsUrl, headers: headers);

      if (data['success'] == true) {
        transactionLimit.value = AppConstants.parseToDouble(
          data['message']?['limits']?['max_per_transaction'],
        );
        maxDailyTransaction.value = int.tryParse(
              data['message']?['limits']?['max_daily_transaction']?.toString() ??
                  '0',
            ) ??
            0;
      } else {
        SnackbarHelper.showError(
          ErrorMessageHelper.toUserMessage(
            ApiException(message: data['message']?.toString() ?? '', data: null),
            fallbackKey: 'unexpected_error',
          ),
        );
      }
    } on ApiException catch (e) {
      SnackbarHelper.showError(ErrorMessageHelper.toUserMessage(e));
    } catch (e) {
      SnackbarHelper.showError(ErrorMessageHelper.toUserMessage(e));
    } finally {
      isTransactionLoading.value = false;
    }
  }

  Future<void> updateTransactionLimit({required String newValue}) async {
    try {
      isTransactionLoading.value = true;
      final headers = await AppConstants.getAuthHeaders();
      final data = await api.post(
        ApiUrls.walletLimitsUrl,
        headers: headers,
        body: {"max_per_transaction": newValue},
      );

      if (data['success'] == true) {
        transactionLimit.value = AppConstants.parseToDouble(
          data['message']?['limits']?['max_per_transaction'],
        );
        Get.back();
        showSuccessPopup();
      } else {
        SnackbarHelper.showError(
          ErrorMessageHelper.toUserMessage(
            ApiException(message: data['message']?.toString() ?? '', data: null),
            fallbackKey: 'unexpected_error',
          ),
        );
      }
    } on ApiException catch (e) {
      SnackbarHelper.showError(ErrorMessageHelper.toUserMessage(e));
    } catch (e) {
      SnackbarHelper.showError(ErrorMessageHelper.toUserMessage(e));
    } finally {
      isTransactionLoading.value = false;
    }
  }

  Future<void> getChildTransactionLimit({required int customerId}) async {
    try {
      isChildLimitLoading.value = true;
      final headers = await AppConstants.getAuthHeaders();
      final data = await api.get(
        ApiUrls.walletLimitsUrl,
        headers: headers,
        queryParameters: {"customer_id": customerId.toString()},
      );

      if (data['success'] == true) {
        final maxPer = AppConstants.parseToDouble(
          data['message']?['limits']?['max_per_transaction'],
        );
        final maxDaily = int.tryParse(
              data['message']?['limits']?['max_daily_transaction']
                      ?.toString() ??
                  '0',
            ) ??
            0;
        childMaxPerTransaction.value = maxPer;
        childMaxDailyTransaction.value = maxDaily;
        tempChildMaxPerTxn.value = maxPer.clamp(10.0, 200.0);
        tempChildMaxDailyTxn.value = maxDaily.toDouble().clamp(10.0, 200.0);
      }
    } on ApiException catch (e) {
      SnackbarHelper.showError(ErrorMessageHelper.toUserMessage(e));
    } catch (e) {
      SnackbarHelper.showError(ErrorMessageHelper.toUserMessage(e));
    } finally {
      isChildLimitLoading.value = false;
    }
  }

  Future<void> updateChildTransactionLimit({
    required int customerId,
    required String maxPerTransaction,
    required String maxDailyTransaction,
  }) async {
    try {
      isChildLimitLoading.value = true;
      final headers = await AppConstants.getAuthHeaders();
      final data = await api.post(
        ApiUrls.walletLimitsUrl,
        headers: headers,
        body: {
          "customer_id": customerId,
          "max_per_transaction": maxPerTransaction,
          "max_daily_transaction": maxDailyTransaction,
        },
      );

      if (data['success'] == true) {
        final maxPer = AppConstants.parseToDouble(
          data['message']?['limits']?['max_per_transaction'],
        );
        final maxDaily = int.tryParse(
              data['message']?['limits']?['max_daily_transaction']
                      ?.toString() ??
                  '0',
            ) ??
            0;
        childMaxPerTransaction.value = maxPer;
        childMaxDailyTransaction.value = maxDaily;
        tempChildMaxPerTxn.value = maxPer.clamp(10.0, 200.0);
        tempChildMaxDailyTxn.value = maxDaily.toDouble().clamp(10.0, 200.0);
        Get.back();
        showSuccessPopup();
      } else {
        SnackbarHelper.showError(
          ErrorMessageHelper.toUserMessage(
            ApiException(message: data['message']?.toString() ?? '', data: null),
            fallbackKey: 'unexpected_error',
          ),
        );
      }
    } on ApiException catch (e) {
      SnackbarHelper.showError(ErrorMessageHelper.toUserMessage(e));
    } catch (e) {
      SnackbarHelper.showError(ErrorMessageHelper.toUserMessage(e));
    } finally {
      isChildLimitLoading.value = false;
    }
  }

  void showSuccessPopup() {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: SuccessDialog(
          title: 'success'.tr,
          message: 'limit_updated_success'.tr,
          animation: 'assets/lottie/success.json',
          btnText: "continue".tr,
          onDone: () {
            Get.back();
          },
        ),
      ),
    );
  }

  Future<void> loadNextPage() async {
    if (hasMore && !isLoading.value && !isLoadMore.value) {
      await fetchTransactions(loadMore: true);
    }
  }

  var customerTransactions = <Transactions>[].obs;

  var isCustomerLoading = false.obs;
  var isCustomerLoadMore = false.obs;

  int customerCurrentPage = 1;
  bool customerHasMorePages = true;
  int? currentCustomerId;
  Future<void> fetchCustomerTransactions({
    required int customerId,
    bool loadMore = false,
  }) async {
    if (currentCustomerId != customerId || !loadMore) {
      customerCurrentPage = 1;
      customerHasMorePages = true;
      customerTransactions.clear();
    }

    currentCustomerId = customerId;

    if (!customerHasMorePages) return;

    try {
      if (loadMore) {
        isCustomerLoadMore.value = true;
      } else {
        isCustomerLoading.value = true;
      }

      final headers = await AppConstants.getAuthHeaders();

      final data = await api.get(
        ApiUrls.getTransactionsUrl,
        headers: headers,
        queryParameters: {
          "customer_id": customerId.toString(),
          "page": customerCurrentPage.toString(),
          "per_page": perPage.toString(),
        },
      );

      if (data['success'] == true) {
        final model = TransactionMode.fromJson(data);

        final newTxns = model.message?.transactions ?? [];

        if (loadMore) {
          customerTransactions.addAll(newTxns);
        } else {
          customerTransactions.value = newTxns;
        }

        customerCurrentPage =
            (model.message?.pagination?.currentPage ?? customerCurrentPage) + 1;
        customerHasMorePages =
            customerCurrentPage <=
            (model.message?.pagination?.lastPage ?? customerCurrentPage);
      } else {
        SnackbarHelper.showError(
          ErrorMessageHelper.toUserMessage(
            ApiException(
              message: data['message']?.toString() ?? '',
              data: null,
            ),
            fallbackKey: 'error_loading_transactions',
          ),
        );
      }
    } on ApiException catch (e) {
      SnackbarHelper.showError(ErrorMessageHelper.toUserMessage(e, fallbackKey: 'error_loading_transactions'));
    } catch (e) {
      SnackbarHelper.showError(ErrorMessageHelper.toUserMessage(e, fallbackKey: 'error_loading_transactions'));
    } finally {
      isCustomerLoading.value = false;
      isCustomerLoadMore.value = false;
    }
  }

  bool get customerHasMore => customerHasMorePages;

  Future<void> loadNextCustomerPage(int customerId) async {
    if (customerHasMore &&
        !isCustomerLoading.value &&
        !isCustomerLoadMore.value) {
      await fetchCustomerTransactions(customerId: customerId, loadMore: true);
    }
  }

  // Optional: Refresh customer transactions
  Future<void> refreshCustomerTransactions(int customerId) async {
    await fetchCustomerTransactions(customerId: customerId);
  }
}
