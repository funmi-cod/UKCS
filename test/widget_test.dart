import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:ukcs_app/features/home/data/repository/home_repo.dart';
import 'package:ukcs_app/main.dart';

class MockHomeRepo extends Mock implements HomeRepo {}

void main() {
  late MockHomeRepo mockHomeRepo;

  setUp(() {
    mockHomeRepo = MockHomeRepo();
  });

  testWidgets('UK Crime & Safety Explorer page loads and renders title', (
    WidgetTester tester,
  ) async {
    // Arrange
    final postcodeResponse = Response(
      requestOptions: RequestOptions(path: ''),
      data: {
        "status": 200,
        "result": {
          "postcode": "SE13 6JP",
          "latitude": 51.464,
          "longitude": -0.015,
          "admin_district": "Lewisham",
          "region": "London",
          "pfa": "Metropolitan Police",
        },
      },
      statusCode: 200,
    );
    final crimeResponse = Response(
      requestOptions: RequestOptions(path: ''),
      data: [],
      statusCode: 200,
    );

    when(
      () => mockHomeRepo.locationPoints(postcode: any(named: 'postcode')),
    ).thenAnswer((_) async => postcodeResponse);
    when(
      () => mockHomeRepo.locationCrimeHistory(
        lat: any(named: 'lat'),
        long: any(named: 'long'),
      ),
    ).thenAnswer((_) async => crimeResponse);

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [homeRepoProvider.overrideWithValue(mockHomeRepo)],
        child: const MyApp(),
      ),
    );

    // Re-trigger frames to let post-frame callback run
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Verify title and subtitle are present
    expect(find.text("UK Crime & Safety Explorer"), findsOneWidget);
    expect(
      find.text(
        "Explore recent street-level crime data around any UK postcode",
      ),
      findsOneWidget,
    );

    // Verify search text field is present
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text("Search"), findsOneWidget);
  });
}
