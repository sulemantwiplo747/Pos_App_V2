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

class FamilyShimmer extends StatelessWidget {
  const FamilyShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Owner tile
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  const ShimmerBox(height: 46, width: 46, radius: 23),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ShimmerBox(height: 18, width: 150, radius: 8),
                        const SizedBox(height: 8),
                        const ShimmerBox(height: 14, width: 100, radius: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Family description text shimmer
            const ShimmerBox(height: 40, width: double.infinity, radius: 8),
            const SizedBox(height: 30),
            // Members header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const ShimmerBox(height: 20, width: 120, radius: 8),
                const ShimmerBox(height: 32, width: 80, radius: 8),
              ],
            ),
            const SizedBox(height: 12),
            // Member tiles
            ...List.generate(
              4,
              (i) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ],
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
