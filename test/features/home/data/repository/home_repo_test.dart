import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:ukcs_app/core/req_client.dart';
import 'package:ukcs_app/features/home/data/repository/home_repo.dart';

class MockReqClient extends Mock implements ReqClient {}

void main() {
  late MockReqClient mockReqClient;
  late HomeRepo homeRepo;

  setUp(() {
    mockReqClient = MockReqClient();
    homeRepo = HomeRepo(mockReqClient);
  });

  group('HomeRepo', () {
    const tPostcode = 'SW1A 2AA';
    const tLat = 51.50354;
    const tLong = -0.127695;

    test(
      'locationPoints should call getWithoutAuthClient with correct URL',
      () async {
        // Arrange
        final response = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'status': 200},
          statusCode: 200,
        );
        when(
          () => mockReqClient.getWithoutAuthClient(any()),
        ).thenAnswer((_) async => response);

        // Act
        final result = await homeRepo.locationPoints(postcode: tPostcode);

        // Assert
        verify(
          () => mockReqClient.getWithoutAuthClient(
            'https://api.postcodes.io/postcodes/$tPostcode',
          ),
        ).called(1);
        expect(result, equals(response));
      },
    );

    test(
      'locationCrimeHistory should call getWithoutAuthClient with correct URL',
      () async {
        // Arrange
        final response = Response(
          requestOptions: RequestOptions(path: ''),
          data: [],
          statusCode: 200,
        );
        when(
          () => mockReqClient.getWithoutAuthClient(any()),
        ).thenAnswer((_) async => response);

        // Act
        final result = await homeRepo.locationCrimeHistory(
          lat: tLat,
          long: tLong,
        );

        // Assert
        verify(
          () => mockReqClient.getWithoutAuthClient(
            'https://data.police.uk/api/crimes-street/all-crime?lat=$tLat&lng=$tLong',
          ),
        ).called(1);
        expect(result, equals(response));
      },
    );
  });
}
