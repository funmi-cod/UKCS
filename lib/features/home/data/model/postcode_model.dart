class PostcodeModel {
  final int? status;
  final Result? result;

  PostcodeModel({this.status, this.result});

  factory PostcodeModel.fromJson(Map<String, dynamic> json) => PostcodeModel(
    status: json["status"],
    result: json["result"] == null ? null : Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "result": result?.toJson(),
  };
}

class Result {
  final String? postcode;
  final int? quality;
  final int? eastings;
  final int? northings;
  final String? country;
  final String? nhsHa;
  final double? longitude;
  final double? latitude;
  final String? europeanElectoralRegion;
  final String? primaryCareTrust;
  final String? region;
  final String? lsoa;
  final String? msoa;
  final String? incode;
  final String? outcode;
  final String? parliamentaryConstituency;
  final String? parliamentaryConstituency2024;
  final dynamic seneddConstituency;
  final dynamic seneddConstituencyNo;
  final String? adminDistrict;
  final String? parish;
  final dynamic adminCounty;
  final String? dateOfIntroduction;
  final dynamic dateOfTermination;
  final int? indexOfMultipleDeprivation;
  final String? adminWard;
  final dynamic ced;
  final String? ccg;
  final String? nuts;
  final String? pfa;
  final String? nhsRegion;
  final String? ttwa;
  final String? nationalPark;
  final String? bua;
  final String? icb;
  final String? cancerAlliance;
  final String? lsoa11;
  final String? msoa11;
  final String? lsoa21;
  final String? msoa21;
  final String? oa21;
  final String? ruc11;
  final String? ruc21;
  final String? lep1;
  final dynamic lep2;
  final Codes? codes;

  Result({
    this.postcode,
    this.quality,
    this.eastings,
    this.northings,
    this.country,
    this.nhsHa,
    this.longitude,
    this.latitude,
    this.europeanElectoralRegion,
    this.primaryCareTrust,
    this.region,
    this.lsoa,
    this.msoa,
    this.incode,
    this.outcode,
    this.parliamentaryConstituency,
    this.parliamentaryConstituency2024,
    this.seneddConstituency,
    this.seneddConstituencyNo,
    this.adminDistrict,
    this.parish,
    this.adminCounty,
    this.dateOfIntroduction,
    this.dateOfTermination,
    this.indexOfMultipleDeprivation,
    this.adminWard,
    this.ced,
    this.ccg,
    this.nuts,
    this.pfa,
    this.nhsRegion,
    this.ttwa,
    this.nationalPark,
    this.bua,
    this.icb,
    this.cancerAlliance,
    this.lsoa11,
    this.msoa11,
    this.lsoa21,
    this.msoa21,
    this.oa21,
    this.ruc11,
    this.ruc21,
    this.lep1,
    this.lep2,
    this.codes,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    postcode: json["postcode"],
    quality: json["quality"],
    eastings: json["eastings"],
    northings: json["northings"],
    country: json["country"],
    nhsHa: json["nhs_ha"],
    longitude: json["longitude"]?.toDouble(),
    latitude: json["latitude"]?.toDouble(),
    europeanElectoralRegion: json["european_electoral_region"],
    primaryCareTrust: json["primary_care_trust"],
    region: json["region"],
    lsoa: json["lsoa"],
    msoa: json["msoa"],
    incode: json["incode"],
    outcode: json["outcode"],
    parliamentaryConstituency: json["parliamentary_constituency"],
    parliamentaryConstituency2024: json["parliamentary_constituency_2024"],
    seneddConstituency: json["senedd_constituency"],
    seneddConstituencyNo: json["senedd_constituency_no"],
    adminDistrict: json["admin_district"],
    parish: json["parish"],
    adminCounty: json["admin_county"],
    dateOfIntroduction: json["date_of_introduction"],
    dateOfTermination: json["date_of_termination"],
    indexOfMultipleDeprivation: json["index_of_multiple_deprivation"],
    adminWard: json["admin_ward"],
    ced: json["ced"],
    ccg: json["ccg"],
    nuts: json["nuts"],
    pfa: json["pfa"],
    nhsRegion: json["nhs_region"],
    ttwa: json["ttwa"],
    nationalPark: json["national_park"],
    bua: json["bua"],
    icb: json["icb"],
    cancerAlliance: json["cancer_alliance"],
    lsoa11: json["lsoa11"],
    msoa11: json["msoa11"],
    lsoa21: json["lsoa21"],
    msoa21: json["msoa21"],
    oa21: json["oa21"],
    ruc11: json["ruc11"],
    ruc21: json["ruc21"],
    lep1: json["lep1"],
    lep2: json["lep2"],
    codes: json["codes"] == null ? null : Codes.fromJson(json["codes"]),
  );

  Map<String, dynamic> toJson() => {
    "postcode": postcode,
    "quality": quality,
    "eastings": eastings,
    "northings": northings,
    "country": country,
    "nhs_ha": nhsHa,
    "longitude": longitude,
    "latitude": latitude,
    "european_electoral_region": europeanElectoralRegion,
    "primary_care_trust": primaryCareTrust,
    "region": region,
    "lsoa": lsoa,
    "msoa": msoa,
    "incode": incode,
    "outcode": outcode,
    "parliamentary_constituency": parliamentaryConstituency,
    "parliamentary_constituency_2024": parliamentaryConstituency2024,
    "senedd_constituency": seneddConstituency,
    "senedd_constituency_no": seneddConstituencyNo,
    "admin_district": adminDistrict,
    "parish": parish,
    "admin_county": adminCounty,
    "date_of_introduction": dateOfIntroduction,
    "date_of_termination": dateOfTermination,
    "index_of_multiple_deprivation": indexOfMultipleDeprivation,
    "admin_ward": adminWard,
    "ced": ced,
    "ccg": ccg,
    "nuts": nuts,
    "pfa": pfa,
    "nhs_region": nhsRegion,
    "ttwa": ttwa,
    "national_park": nationalPark,
    "bua": bua,
    "icb": icb,
    "cancer_alliance": cancerAlliance,
    "lsoa11": lsoa11,
    "msoa11": msoa11,
    "lsoa21": lsoa21,
    "msoa21": msoa21,
    "oa21": oa21,
    "ruc11": ruc11,
    "ruc21": ruc21,
    "lep1": lep1,
    "lep2": lep2,
    "codes": codes?.toJson(),
  };
}

class Codes {
  final String? adminDistrict;
  final String? adminCounty;
  final String? adminWard;
  final String? parish;
  final String? parliamentaryConstituency;
  final String? parliamentaryConstituency2024;
  final String? ccg;
  final String? ccgId;
  final String? ced;
  final String? nuts;
  final String? lsoa;
  final String? msoa;
  final String? lau2;
  final String? pfa;
  final String? nhsRegion;
  final String? ttwa;
  final String? nationalPark;
  final String? bua;
  final String? icb;
  final String? cancerAlliance;
  final String? lsoa11;
  final String? msoa11;
  final String? lsoa21;
  final String? msoa21;
  final String? oa21;
  final String? ruc11;
  final String? ruc21;
  final String? lep1;
  final dynamic lep2;

  Codes({
    this.adminDistrict,
    this.adminCounty,
    this.adminWard,
    this.parish,
    this.parliamentaryConstituency,
    this.parliamentaryConstituency2024,
    this.ccg,
    this.ccgId,
    this.ced,
    this.nuts,
    this.lsoa,
    this.msoa,
    this.lau2,
    this.pfa,
    this.nhsRegion,
    this.ttwa,
    this.nationalPark,
    this.bua,
    this.icb,
    this.cancerAlliance,
    this.lsoa11,
    this.msoa11,
    this.lsoa21,
    this.msoa21,
    this.oa21,
    this.ruc11,
    this.ruc21,
    this.lep1,
    this.lep2,
  });

  factory Codes.fromJson(Map<String, dynamic> json) => Codes(
    adminDistrict: json["admin_district"],
    adminCounty: json["admin_county"],
    adminWard: json["admin_ward"],
    parish: json["parish"],
    parliamentaryConstituency: json["parliamentary_constituency"],
    parliamentaryConstituency2024: json["parliamentary_constituency_2024"],
    ccg: json["ccg"],
    ccgId: json["ccg_id"],
    ced: json["ced"],
    nuts: json["nuts"],
    lsoa: json["lsoa"],
    msoa: json["msoa"],
    lau2: json["lau2"],
    pfa: json["pfa"],
    nhsRegion: json["nhs_region"],
    ttwa: json["ttwa"],
    nationalPark: json["national_park"],
    bua: json["bua"],
    icb: json["icb"],
    cancerAlliance: json["cancer_alliance"],
    lsoa11: json["lsoa11"],
    msoa11: json["msoa11"],
    lsoa21: json["lsoa21"],
    msoa21: json["msoa21"],
    oa21: json["oa21"],
    ruc11: json["ruc11"],
    ruc21: json["ruc21"],
    lep1: json["lep1"],
    lep2: json["lep2"],
  );

  Map<String, dynamic> toJson() => {
    "admin_district": adminDistrict,
    "admin_county": adminCounty,
    "admin_ward": adminWard,
    "parish": parish,
    "parliamentary_constituency": parliamentaryConstituency,
    "parliamentary_constituency_2024": parliamentaryConstituency2024,
    "ccg": ccg,
    "ccg_id": ccgId,
    "ced": ced,
    "nuts": nuts,
    "lsoa": lsoa,
    "msoa": msoa,
    "lau2": lau2,
    "pfa": pfa,
    "nhs_region": nhsRegion,
    "ttwa": ttwa,
    "national_park": nationalPark,
    "bua": bua,
    "icb": icb,
    "cancer_alliance": cancerAlliance,
    "lsoa11": lsoa11,
    "msoa11": msoa11,
    "lsoa21": lsoa21,
    "msoa21": msoa21,
    "oa21": oa21,
    "ruc11": ruc11,
    "ruc21": ruc21,
    "lep1": lep1,
    "lep2": lep2,
  };
}
