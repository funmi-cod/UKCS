import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukcs_app/core/utils/enums/view_status.dart';
import 'package:ukcs_app/features/home/data/model/crime_model.dart';
import 'package:ukcs_app/features/home/data/model/postcode_model.dart';
import 'package:ukcs_app/features/home/data/repository/home_repo.dart';
import 'package:ukcs_app/features/home/presentation/state/home_state.dart';

class HomeViewModel extends Notifier<HomeState> {
  late final HomeRepo _repo;
  @override
  HomeState build() {
    _repo = ref.watch(homeRepoProvider);
    return const HomeState();
  }

  Future<Result?> _getLocationPoints(String postcode) async {
    state = state.copyWith(status: ViewStatus.loading);
    try {
      Response response = await _repo.locationPoints(postcode: postcode);
      debugPrint("points res:::::${response.data}");
      if (response.statusCode == 201 || response.statusCode == 200) {
        PostcodeModel data = PostcodeModel.fromJson(response.data);
        state = state.copyWith(result: data.result, message: "Successful");
        return data.result;
      }
      state = state.copyWith(
        status: ViewStatus.error,
        message: response.data["message"] ?? "Postcode not found",
      );
      return null;
    } on DioException catch (e) {
      state = state.copyWith(
        status: ViewStatus.error,
        message: e.message ?? "Oops an error occured",
      );
      return null;
    } catch (e) {
      state = state.copyWith(
        status: ViewStatus.error,
        message: 'An error occured',
      );
      return null;
    }
  }

  Future<void> getCrimeHistory(String postcode) async {
    state = state.copyWith(status: ViewStatus.loading);
    // returns location data from the postcodes api
    final locationData = await _getLocationPoints(postcode);

    if (locationData == null) {
      state = state.copyWith(
        status: ViewStatus.error,
        message: "No postcode data",
      );
      return;
    }
    if (locationData.latitude == null || locationData.longitude == null) {
      state = state.copyWith(
        status: ViewStatus.error,
        message: "Invalid postcode coordinates",
      );
      return;
    }
    final lat = locationData.latitude!;
    final long = locationData.longitude!;
    try {
      Response response = await _repo.locationCrimeHistory(
        lat: lat,
        long: long,
      );
      debugPrint("CrimeHistory res:::::${response.data}");
      if (response.statusCode == 201 || response.statusCode == 200) {
        if (response.data == null || response.data is! List) {
          state = state.copyWith(
            status: ViewStatus.error,
            message: "Error occured. Try again ",
          );
          return;
        }
        final List<CrimeModel> data = (response.data as List)
            .map((e) => CrimeModel.fromJson(e))
            .toList();
        state = state.copyWith(
          status: ViewStatus.success,
          data: data,
          message: "Successful",
          categories: _groupCategories(data),
          latestMonth: _getlatestMomth(data),
        );
        return;
      }
      state = state.copyWith(
        status: ViewStatus.error,
        message: response.data["message"] ?? "Error fetching history",
      );
    } on DioException catch (e) {
      state = state.copyWith(
        status: ViewStatus.error,
        message: e.message ?? "Oops an error occured",
      );
    } catch (e) {
      state = state.copyWith(
        status: ViewStatus.error,
        message: 'An error occured',
      );
    }
  }

  List<MapEntry<String, int>> _groupCategories(List<CrimeModel> data) {
    final Map<String, int> grouped = {};

    for (final crime in data) {
      final category = crime.category ?? "Unknown";

      grouped[category] = (grouped[category] ?? 0) + 1;
    }

    return grouped.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
  }

  String _getlatestMomth(List<CrimeModel>? data) {
    /// returns the umber of unique crime categories found
    // final categories =
    //     state.data
    //         ?.map((crime) => crime.category)
    //         .whereType<String>()
    //         .toSet()
    //         .length ??
    //     0;

    ///    Latest crime record month returned by API

    final month =
        data?.map((crime) => crime.month).whereType<String>().firstOrNull ?? "";
    return month;
  }
}
