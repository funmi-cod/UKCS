import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukcs_app/core/utils/enums/view_status.dart';
import 'package:ukcs_app/core/utils/utilities.dart';
import 'package:ukcs_app/features/home/presentation/provider/home_provider.dart';
import 'package:ukcs_app/features/home/presentation/state/home_state.dart';
import 'package:ukcs_app/features/home/presentation/widgets/home_shimmer.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _CrimeHomePageState();
}

class _CrimeHomePageState extends ConsumerState<HomePage> {
  final TextEditingController postcodeController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchCrimeHistory(postcode: "SE13 6JP");
    });
  }

  /// Fetches crime data using the entered UK postcode.
  /// The ViewModel handles postcode conversion for the coordinates needed in crime API call.
  void fetchCrimeHistory({required String postcode}) async {
    await ref.read(homeViewModelProvider.notifier).getCrimeHistory(postcode);
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    // Listen for state changes (loading, success, error)
    final state = ref.watch(homeViewModelProvider);
    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Page title and description
                const Text(
                  "UK Crime & Safety Explorer",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                Text(
                  "Explore recent street-level crime data around any UK postcode",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),

                const SizedBox(height: 32),

                /// Search Card
                /// Allows users to enter a postcode and trigger crime search
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: postcodeController,
                          decoration: InputDecoration(
                            hintText: "Enter postcode e.g SW1A 2AA",
                            prefixIcon: const Icon(Icons.location_on),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      SizedBox(
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Basic validation before making API request
                            if (postcodeController.text.trim().length > 5) {
                              fetchCrimeHistory(
                                postcode: postcodeController.text.trim(),
                              );
                            }
                          },
                          icon: const Icon(Icons.search),
                          label: const Text("Search"),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Handles loading, error and successful API states
                _buildMainContent(isDesktop, state),
                const SizedBox(height: 20),

                /// Info section
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, size: 32),

                      SizedBox(width: 16),

                      Expanded(
                        child: Text(
                          "Crime data is updated monthly and may vary depending on availability from the UK Police API.",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(bool isDesktop, HomeState state) {
    // Show shimmer while data is loading
    if (state.status == ViewStatus.loading) {
      return HomeShimmer();
    }

    // Display API error message
    if (state.status == ViewStatus.error) {
      return Container(
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Text(
              state.message,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(
              "Try again",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      );
    }
    // Display view when crime data has been successfully loaded
    if (state.status == ViewStatus.success) {
      // when data is empty
      if ((state.data ?? []).isEmpty) {
        return Container(
          padding: const EdgeInsets.all(24),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            state.message,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        );
      }
      if ((state.data ?? []).isNotEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Summary Cards
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                _summaryCard(
                  title: "Total Crimes",
                  value: state.data!.length.toString(),
                  icon: Icons.warning_amber,
                ),

                _summaryCard(
                  title: "Categories",
                  value: state.categories!.length.toString(),
                  icon: Icons.category,
                ),

                _summaryCard(
                  title: "Latest Month",
                  value: Utilities.formatMonth(state.latestMonth ?? ''),
                  icon: Icons.calendar_month,
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              "Location Overview",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                _locationCard(
                  "Postcode",
                  state.result?.postcode ?? '',
                  Icons.location_on,
                ),

                _locationCard(
                  "District",
                  state.result?.adminDistrict ?? '',
                  Icons.location_city,
                ),

                _locationCard("Region", state.result?.region ?? '', Icons.map),

                _locationCard(
                  "Police Force",
                  state.result?.pfa ?? '',
                  Icons.local_police,
                ),
              ],
            ),

            const SizedBox(height: 40),

            const Text(
              "Crime Categories",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            /// Displays crime categories ranked by occurrence.
            /// Data is grouped in the ViewModel to avoid expensive calculations during build.
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.categories?.length,
                    itemBuilder: (context, index) {
                      final entry = state.categories![index];

                      final category = entry.key;
                      final data = entry.value;

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    category
                                        .split("-")
                                        .map(
                                          (e) =>
                                              e[0].toUpperCase() +
                                              e.substring(1),
                                        )
                                        .join(" "),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),

                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    data.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if (index != state.categories!.length - 1)
                            const Divider(),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        );
      }
    }
    return SizedBox.shrink();
  }

  Widget _locationCard(String title, String value, IconData icon) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(icon),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.grey.shade600)),

                const SizedBox(height: 6),

                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(icon),
          ),

          const SizedBox(width: 16),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.grey.shade600)),

              const SizedBox(height: 5),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
