import 'package:flutter/material.dart';
import 'package:pos_v2/constants/enums.dart';

class WalletTransactionTile extends StatefulWidget {
  final String transactionId;
  final TransactionType transactionType;
  final Color statusColor;
  final String date;
  final String amount;
  final int index;

  const WalletTransactionTile({
    super.key,
    required this.transactionId,
    required this.transactionType,
    required this.statusColor,
    required this.date,
    required this.amount,
    required this.index,
  });

  @override
  State<WalletTransactionTile> createState() => _WalletTransactionTileState();
}

class _WalletTransactionTileState extends State<WalletTransactionTile>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slideOffset;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _opacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _slideOffset = Tween<Offset>(
      begin: const Offset(0, 0.15), // subtle slide
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    Future.delayed(Duration(milliseconds: widget.index * 70), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slideOffset,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
          padding: const EdgeInsets.all(16),
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                widget.transactionType == TransactionType.credit
                    ? 'assets/images/credit.png'
                    : 'assets/images/debit.png',
                width: 25,
                height: 25,
              ),
              // Icon(
              //   widget.transactionType == TransactionType.credit
              //       ? Icons.add
              //       : Icons.remove,
              //   size: 20,
              //   color: widget.transactionType == TransactionType.credit
              //       ? Colors.black54
              //       : const Color.fromARGB(108, 255, 0, 0),
              // ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.transactionId,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          widget.date,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: widget.statusColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.transactionType.name.toUpperCase(),
                            style: TextStyle(
                              color: widget.statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          widget.amount,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
