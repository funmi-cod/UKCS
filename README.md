# ukcs_app

# UK Crime & Safety Explorer

A responsive Flutter Web application that allows users to search a UK postcode and explore nearby street-level crime information using official public APIs.

The application provides a simple and reliable crime dashboard showing:

- Total crime incidents
- Crime category breakdown
- Latest reporting month
- Postcode location information
- Crime distribution overview
- Responsive user interface for different screen sizes

---

# Track & APIs Used

## Track 02 — UK Crime & Safety Explorer

## APIs Used

### UK Police Data API

Endpoint:

```
https://data.police.uk/api/crimes-street/all-crime
```

### Purpose

Used to retrieve recent street-level crime data based on latitude and longitude.

### Why this API was chosen

- Official UK police open data source
- No API key required
- Provides real-world crime information
- Contains useful crime details including:
  - Crime category
  - Street location
  - Crime month
  - Location coordinates
  - Police force information

---

### Postcodes.io API

Endpoint:

```
https://api.postcodes.io/postcodes/{postcode}
```

### Purpose

Converts a UK postcode into geographical coordinates and location information.

The UK Police API requires latitude and longitude instead of a postcode, so Postcodes.io is used as the first step.

Application flow:

```
User enters postcode

        ↓

Postcodes.io API

        ↓

Latitude & Longitude

        ↓

UK Police API

        ↓

Crime Dashboard
```

---

# Architecture

The application follows a **feature-first MVVM architecture** using Riverpod for state management.

Project structure:

```
lib/

├── core/
│   ├── components/
│   ├── utils/
│   └── req_client.dart
│
├── features/
│   └── home/
│       │
│       ├── data/
│       │   ├── models/
│       │   └── repository/
│       │
│       └── presentation/
│           ├── pages/
│           ├── viewmodel/
│           ├── state/
│           └── provider/
│
└── main.dart
```

---

# Architecture Decisions

## Feature-first organisation

The project is structured by feature rather than grouping files globally.

Benefits:

- Easier navigation
- Better scalability
- Keeps related files together
- Allows new features to be added independently

---

# MVVM Pattern

The application follows:

```
View

 ↓

ViewModel

 ↓

Repository

 ↓

External APIs
```

---

## View Layer

Responsible for:

- Displaying UI
- Handling user interaction
- Listening to state changes

The UI does not directly communicate with APIs.

---

## ViewModel Layer

Responsible for:

- Coordinating application logic
- Managing loading, success, and error states
- Transforming API responses into UI-friendly data

Examples:

- Calculating total crime count
- Grouping crimes by category
- Extracting latest crime month

---

## Repository Layer

Responsible for:

- Handling API communication
- Abstracting external data sources from the ViewModel

The ViewModel does not directly depend on Dio or API implementation details.

---

# Key Trade-offs

For this assessment, a lightweight MVVM approach was selected instead of full Clean Architecture.

A full Clean Architecture implementation would introduce:

- Entities
- Use cases
- Repository interfaces
- Additional abstraction layers

Although useful for large-scale applications, these layers would add unnecessary complexity for a single-feature assessment project.

The current approach provides:

- Clear separation of concerns
- Maintainability
- Testability
- Less boilerplate

while keeping the application simple and focused.

---

# Reliability & Error Handling

The application handles different failure scenarios.

## Invalid Postcode

If a postcode cannot be resolved:

```
Invalid postcode coordinates
```

is displayed.

---

## Empty Crime Response

If no crime records are returned:

```
No crime data available
```

is displayed instead of rendering an empty dashboard.

---

## Network and API Errors

Handled cases include:

- Network failures
- Invalid API responses
- Unexpected server responses
- Missing location coordinates

The application displays appropriate error states instead of crashing.

---

# UI Features

## Postcode Search

Users can enter a UK postcode to retrieve nearby crime information.

Example:

```
SE13 6JP is used when the app loads for the first time
```

---

## Summary Statistics

Displays:

- Total crimes
- Number of crime categories
- Latest crime reporting month

---

## Location Overview

Displays postcode information:

- Postcode
- Administrative district
- Region
- Police force

---

## Crime Category Breakdown

Crime incidents are grouped dynamically by category.

Example:

```
Anti-social behaviour     24
Burglary                  12
Vehicle crime              8
```

---

## Testing & QA Approach

The project includes unit and widget tests to validate the business logic, data layer, and user interface.

### Unit Tests

#### HomeViewModel

The ViewModel is tested independently by mocking the repository using Mockito.

The tests verify:

- Initial state is `HomeState` with `ViewStatus.idle`
- Successful postcode lookup and crime history retrieval
- State transitions:
  - `idle → loading → success`
  - `idle → loading → error`
- Correct crime data is stored in state
- Crime categories are grouped and sorted correctly
- Latest available crime month is extracted correctly
- Invalid postcode responses
- Missing postcode coordinates
- Network failures (`DioException`)
- Unexpected exceptions

#### HomeRepo

Repository tests mock the `ReqClient` to ensure the correct API requests are made.

The tests verify:

- Correct endpoint is called for postcode lookups
- Correct endpoint is called for crime history lookups
- Latitude and longitude query parameters are passed correctly
- Repository returns the expected response from the HTTP client

#### Utilities

Utility methods are tested separately.

Current coverage includes:

- Formatting API month values (e.g. `2026-05` → `May 2026`)
- Empty string handling
- Invalid input edge cases

### Widget Tests

Widget tests verify that the UI behaves correctly for different application states.

The tests cover:

- Initial home page rendering
- Loading state (Shimmer)
- Success state
- Error state
- Empty state
- Search UI components render correctly

## Manual Test Plan

### 1. Initial Application Load

Expected:

- Application loads successfully
- Search input is visible
- No UI crashes occur

---

### 2. Valid Postcode Search

Example:

```
SE13 6JP used when the app loads
```

Expected:

- Location information appears
- Crime statistics load
- Crime categories are displayed

---

### 3. Invalid Postcode

Example:

```
ABC123
```

Expected:

- Error message displayed
- User can attempt another search

---

### 4. Empty API Response

Expected:

- Empty state displayed
- No rendering errors

---

### 5. Network Failure

Expected:

- Error state displayed
- Application remains responsive

---

# Known Limitations

## No Pagination

The UK Police crime endpoint does not provide traditional pagination.

For larger datasets, additional optimisation may be required.

Possible improvements:

- Client-side pagination

---

## No Map Visualisation

The API provides crime coordinates, but the current version does not display them visually.

Future improvement:

- Add map integration
- Display crime hotspots
- Show incident locations

---

## Limited Filtering

Currently users cannot filter by:

- Crime category
- Date range
- Distance radius

Future improvement:

Add filtering and sorting functionality.

---

## External API Dependency

The application relies on public APIs which may experience:

- Slow responses
- Temporary downtime
- Missing records

Future improvements:

- Add local caching
- Store previous searches
- Add offline fallback support

---

# Future Improvements

With more time, I would add:

- Interactive crime map
- Crime trend charts
- Category filtering
- Date range selection
- Local caching using Hive/SQLite
- Improved accessibility support
- Search history

---

# Tech Stack

- Flutter Web
- Dart
- Riverpod
- Dio
- Postcodes.io API
- UK Police Data API

---

# Running the Project

Install dependencies:

```bash
flutter pub get
```

Run on Chrome:

```bash
flutter run -d chrome
```

Build for Web:

```bash
flutter build web
```

---
