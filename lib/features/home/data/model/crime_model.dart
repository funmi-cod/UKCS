class CrimeModel {
  final String? category;
  final String? locationType;
  final Location? location;
  final String? context;
  final dynamic outcomeStatus;
  final String? persistentId;
  final int? id;
  final String? locationSubtype;
  final String? month;

  CrimeModel({
    this.category,
    this.locationType,
    this.location,
    this.context,
    this.outcomeStatus,
    this.persistentId,
    this.id,
    this.locationSubtype,
    this.month,
  });

  factory CrimeModel.fromJson(Map<String, dynamic> json) => CrimeModel(
    category: json["category"],
    locationType: json["location_type"],
    location: json["location"] == null
        ? null
        : Location.fromJson(json["location"]),
    context: json["context"],
    outcomeStatus: json["outcome_status"],
    persistentId: json["persistent_id"],
    id: json["id"],
    locationSubtype: json["location_subtype"],
    month: json["month"],
  );

  Map<String, dynamic> toJson() => {
    "category": category,
    "location_type": locationType,
    "location": location?.toJson(),
    "context": context,
    "outcome_status": outcomeStatus,
    "persistent_id": persistentId,
    "id": id,
    "location_subtype": locationSubtype,
    "month": month,
  };
}

class Location {
  final String? latitude;
  final Street? street;
  final String? longitude;

  Location({this.latitude, this.street, this.longitude});

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    latitude: json["latitude"],
    street: json["street"] == null ? null : Street.fromJson(json["street"]),
    longitude: json["longitude"],
  );

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "street": street?.toJson(),
    "longitude": longitude,
  };
}

class Street {
  final int? id;
  final String? name;

  Street({this.id, this.name});

  factory Street.fromJson(Map<String, dynamic> json) =>
      Street(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}
