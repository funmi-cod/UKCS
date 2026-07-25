// Home State
import 'package:ukcs_app/core/components/utils/enums/view_status.dart';
import 'package:ukcs_app/features/home/data/model/crime_model.dart';
import 'package:ukcs_app/features/home/data/model/postcode_model.dart';

class HomeState {
  final String message;
  final ViewStatus status;
  final List<CrimeModel>? data;
  final Result? result;
  final List<MapEntry<String, int>>? categories;
  final String? latestMonth;

  const HomeState({
    this.message = '',
    this.status = ViewStatus.idle,
    this.data,
    this.result,
    this.categories,
    this.latestMonth,
  });

  HomeState copyWith({
    String? message,
    ViewStatus? status,
    List<CrimeModel>? data,
    Result? result,
    List<MapEntry<String, int>>? categories,
    String? latestMonth,
  }) {
    return HomeState(
      message: message ?? this.message,
      status: status ?? this.status,
      data: data ?? this.data,
      result: result ?? this.result,
      categories: categories ?? this.categories,
      latestMonth: latestMonth ?? this.latestMonth,
    );
  }
}
