import 'package:flutter/material.dart';
import 'package:ukcs_app/core/components/shimmer_box.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Location overview
        Row(
          children: [
            Expanded(child: ShimmerBox(height: 90, width: width)),

            const SizedBox(width: 20),

            Expanded(child: ShimmerBox(height: 90, width: width)),
          ],
        ),

        const SizedBox(height: 30),

        // Summary cards
        Wrap(
          spacing: 20,
          runSpacing: 20,
          children: List.generate(
            3,
            (index) => const ShimmerBox(height: 100, width: 260),
          ),
        ),

        const SizedBox(height: 40),

        // Crime categories title
        const ShimmerBox(height: 25, width: 180),

        const SizedBox(height: 20),

        // Crime cards
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1.4,
          ),
          itemBuilder: (_, index) {
            return const ShimmerBox(height: 150, width: double.infinity);
          },
        ),

        const SizedBox(height: 40),

        // Top streets
        const ShimmerBox(height: 250, width: double.infinity),
      ],
    );
  }
}
