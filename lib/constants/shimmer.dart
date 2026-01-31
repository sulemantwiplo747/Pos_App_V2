import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBox extends StatelessWidget {
  final double height, width, radius;

  const ShimmerBox({
    super.key,
    required this.height,
    required this.width,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Wallet Card
              const ShimmerBox(height: 120, width: double.infinity),
              const SizedBox(height: 20),

              // Family card
              const ShimmerBox(height: 100, width: double.infinity),
              const SizedBox(height: 20),

              // Orders title
              const ShimmerBox(height: 20, width: 120),
              const SizedBox(height: 20),

              // List of shimmer order tiles
              ...List.generate(
                5,
                (i) => const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: ShimmerBox(height: 80, width: double.infinity),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
