import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:ukcs_app/core/utils/enums/view_status.dart';
import 'package:ukcs_app/features/home/data/repository/home_repo.dart';
import 'package:ukcs_app/features/home/presentation/provider/home_provider.dart';

class MockHomeRepo extends Mock implements HomeRepo {}

void main() {
  late MockHomeRepo mockHomeRepo;
  late ProviderContainer container;

  setUp(() {
    mockHomeRepo = MockHomeRepo();
    container = ProviderContainer(
      overrides: [homeRepoProvider.overrideWithValue(mockHomeRepo)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('HomeViewModel', () {
    const tPostcode = 'SW1A 2AA';
    const tLat = 51.50354;
    const tLong = -0.127695;

    final tPostcodeResponseData = {
      "status": 200,
      "result": {
        "postcode": "SW1A 2AA",
        "latitude": tLat,
        "longitude": tLong,
        "admin_district": "Westminster",
        "region": "London",
        "pfa": "Metropolitan Police",
      },
    };

    final tCrimeResponseData = [
      {
        "category": "anti-social-behaviour",
        "location_type": "Force",
        "location": {
          "latitude": "51.50354",
          "longitude": "-0.127695",
          "street": {"id": 1, "name": "On or near Downing Street"},
        },
        "context": "",
        "outcome_status": null,
        "persistent_id": "",
        "id": 12345,
        "location_subtype": "",
        "month": "2023-05",
      },
      {
        "category": "anti-social-behaviour",
        "location_type": "Force",
        "location": {
          "latitude": "51.50354",
          "longitude": "-0.127695",
          "street": {"id": 1, "name": "On or near Downing Street"},
        },
        "context": "",
        "outcome_status": null,
        "persistent_id": "",
        "id": 12346,
        "location_subtype": "",
        "month": "2023-05",
      },
      {
        "category": "violent-crime",
        "location_type": "Force",
        "location": {
          "latitude": "51.50354",
          "longitude": "-0.127695",
          "street": {"id": 1, "name": "On or near Downing Street"},
        },
        "context": "",
        "outcome_status": null,
        "persistent_id": "",
        "id": 12347,
        "location_subtype": "",
        "month": "2023-05",
      },
    ];

    test('initial state should be HomeState with default values', () {
      final state = container.read(homeViewModelProvider);
      expect(state.status, equals(ViewStatus.idle));
      expect(state.message, equals(''));
      expect(state.data, isNull);
      expect(state.result, isNull);
      expect(state.categories, isNull);
      expect(state.latestMonth, isNull);
    });

    test('should successfully fetch coordinates and crime history', () async {
      // Arrange
      final postcodeResponse = Response(
        requestOptions: RequestOptions(path: ''),
        data: tPostcodeResponseData,
        statusCode: 200,
      );
      final crimeResponse = Response(
        requestOptions: RequestOptions(path: ''),
        data: tCrimeResponseData,
        statusCode: 200,
      );

      when(
        () => mockHomeRepo.locationPoints(postcode: tPostcode),
      ).thenAnswer((_) async => postcodeResponse);
      when(
        () => mockHomeRepo.locationCrimeHistory(lat: tLat, long: tLong),
      ).thenAnswer((_) async => crimeResponse);

      final viewModel = container.read(homeViewModelProvider.notifier);

      // Act
      await viewModel.getCrimeHistory(tPostcode);

      // Assert
      final state = container.read(homeViewModelProvider);
      expect(state.status, equals(ViewStatus.success));
      expect(state.message, equals('Successful'));
      expect(state.result?.postcode, equals('SW1A 2AA'));
      expect(state.data?.length, equals(3));
      expect(state.latestMonth, equals('2023-05'));
      expect(state.categories?.length, equals(2));
      expect(state.categories?[0].key, equals('anti-social-behaviour'));
      expect(state.categories?[0].value, equals(2));
      expect(state.categories?[1].key, equals('violent-crime'));
      expect(state.categories?[1].value, equals(1));
    });

    test('should fail when postcode is invalid/not found', () async {
      // Arrange
      final postcodeResponse = Response(
        requestOptions: RequestOptions(path: ''),
        data: {"message": "Invalid postcode"},
        statusCode: 404,
      );

      when(
        () => mockHomeRepo.locationPoints(postcode: tPostcode),
      ).thenAnswer((_) async => postcodeResponse);

      final viewModel = container.read(homeViewModelProvider.notifier);

      // Act
      await viewModel.getCrimeHistory(tPostcode);

      // Assert
      final state = container.read(homeViewModelProvider);
      expect(state.status, equals(ViewStatus.error));
      expect(state.message, equals('No postcode data'));
    });

    test('should fail when locationPoints throws DioException', () async {
      // Arrange
      when(() => mockHomeRepo.locationPoints(postcode: tPostcode)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          message: 'Network issue',
        ),
      );

      final viewModel = container.read(homeViewModelProvider.notifier);

      // Act
      await viewModel.getCrimeHistory(tPostcode);

      // Assert
      final state = container.read(homeViewModelProvider);
      expect(state.status, equals(ViewStatus.error));
      expect(state.message, equals('No postcode data'));
    });

    test('should fail when locationPoints throws general exception', () async {
      // Arrange
      when(
        () => mockHomeRepo.locationPoints(postcode: tPostcode),
      ).thenThrow(Exception('Unknown error'));

      final viewModel = container.read(homeViewModelProvider.notifier);

      // Act
      await viewModel.getCrimeHistory(tPostcode);

      // Assert
      final state = container.read(homeViewModelProvider);
      expect(state.status, equals(ViewStatus.error));
      expect(state.message, equals('No postcode data'));
    });

    test('should fail when locationData has null coordinates', () async {
      // Arrange
      final postcodeResponse = Response(
        requestOptions: RequestOptions(path: ''),
        data: {
          "status": 200,
          "result": {
            "postcode": "SW1A 2AA",
            "latitude": null,
            "longitude": null,
          },
        },
        statusCode: 200,
      );

      when(
        () => mockHomeRepo.locationPoints(postcode: tPostcode),
      ).thenAnswer((_) async => postcodeResponse);

      final viewModel = container.read(homeViewModelProvider.notifier);

      // Act
      await viewModel.getCrimeHistory(tPostcode);

      // Assert
      final state = container.read(homeViewModelProvider);
      expect(state.status, equals(ViewStatus.error));
      expect(state.message, equals('Invalid postcode coordinates'));
    });

    test('should fail when crime api returns invalid/empty format', () async {
      // Arrange
      final postcodeResponse = Response(
        requestOptions: RequestOptions(path: ''),
        data: tPostcodeResponseData,
        statusCode: 200,
      );
      final crimeResponse = Response(
        requestOptions: RequestOptions(path: ''),
        data: "not a list",
        statusCode: 200,
      );

      when(
        () => mockHomeRepo.locationPoints(postcode: tPostcode),
      ).thenAnswer((_) async => postcodeResponse);
      when(
        () => mockHomeRepo.locationCrimeHistory(lat: tLat, long: tLong),
      ).thenAnswer((_) async => crimeResponse);

      final viewModel = container.read(homeViewModelProvider.notifier);

      // Act
      await viewModel.getCrimeHistory(tPostcode);

      // Assert
      final state = container.read(homeViewModelProvider);
      expect(state.status, equals(ViewStatus.error));
      expect(state.message, equals('Error occured. Try again '));
    });

    test('should fail when crime api throws DioException', () async {
      // Arrange
      final postcodeResponse = Response(
        requestOptions: RequestOptions(path: ''),
        data: tPostcodeResponseData,
        statusCode: 200,
      );

      when(
        () => mockHomeRepo.locationPoints(postcode: tPostcode),
      ).thenAnswer((_) async => postcodeResponse);
      when(
        () => mockHomeRepo.locationCrimeHistory(lat: tLat, long: tLong),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          message: 'Crime API error',
        ),
      );

      final viewModel = container.read(homeViewModelProvider.notifier);

      // Act
      await viewModel.getCrimeHistory(tPostcode);

      // Assert
      final state = container.read(homeViewModelProvider);
      expect(state.status, equals(ViewStatus.error));
      expect(state.message, equals('Crime API error'));
    });
  });
}
