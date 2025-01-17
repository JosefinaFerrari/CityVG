import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/structs/index.dart';

int getStringText(
  String text,
  double width,
) {
  if (width < 479) {
    return text.length * 8 + 25;
  } else if (width < 900) {
    return text.length * 10 + 35;
  } else {
    return text.length * 11 + 40;
  }
}

String getBudgetDescription(String str) {
  if (str == 'Cheap') {
    return 'Budget-friendly';
  } else if (str == 'Balanced') {
    return 'Moderate spending ';
  } else if (str == 'Luxury') {
    return 'High-end, indulgent experiences';
  } else {
    return 'No budget restrictions';
  }
}

String getPeopleString(NumberOfPeopleStruct people) {
  String str = '';
  int count = 0;

  if (people.seniors != 0) {
    if (people.seniors == 1)
      str += '${people.seniors} Senior';
    else
      str += '${people.seniors} Seniors';
    count++;
  }
  if (people.adults != 0) {
    if (count == 1) str += ',  ';
    if (people.adults == 1)
      str += '${people.adults} Adult';
    else
      str += '${people.adults} Adults';
    count++;
  }
  if (people.youth != 0) {
    if (count == 1)
      str += ',  ';
    else if (count == 2) str += '\n';
    if (people.youth == 1)
      str += '${people.youth} Boy';
    else
      str += '${people.youth} Boys';
    count++;
  }
  if (people.children != 0) {
    if (count == 1)
      str += ',  ';
    else if (count == 2)
      str += '\n';
    else if (count == 3) str += ',  ';
    if (people.children == 1)
      str += '${people.children} Child';
    else
      str += '${people.children} Children';
  }
  return str;
}

String getDistanceText(double sliderIndex) {
  double distance = sliderIndex / 22;
  String result = distance.toStringAsFixed(2);
  return '$result km';
}

int getRadius(double sliderIndex) {
  double radius = sliderIndex / 22;
  int result = radius.toInt();
  return result;
}

List<DateTime> getDatesFromAttractions(List<dynamic> attractions) {
  List<DateTime> dates = [];

  for (var attraction in attractions) {
    DateTime date = DateTime.parse(attraction["day"]);
    if (!dates.contains(date)) {
      dates.add(date);
    }
  }

  return dates;
}

LatLng convertLatLng(
  double lat,
  double lng,
) {
  return LatLng(lat, lng);
}

List<AttractionStruct> attractionsFromJson(List<dynamic> attractionsJson) {
  List<AttractionStruct> attractionsList = [];

  String? castToString(dynamic value) {
    if (value is int) {
      return value.toString(); // Convert int to String
    } else if (value is String) {
      return value; // Return as is if already a String
    }
    return null; // Handle null or unexpected types
  }

  double castToDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    }
    if (value is double) {
      return value;
    }
    return 0.0;
  }

  String getWheelChairInfo(bool? value) {
    if (value != null) {
      if (value) {
        return "Wheelchair access available";
      } else
        return "Wheelchair access not available";
    } else
      return "Information not available";
  }

  for (int i = 0; i < attractionsJson.length; i++) {
    dynamic json = attractionsJson[i];

    var product = json["product"];
    var summary = json["editorialSummary"];
    var accessibility = json["accessibilityOptions"];
    List<String> photos = [];
    if (json["photos"] != null &&
        json["photos"] is String &&
        json["photos"] != "") {
      photos.add(json["photos"] as String);
    }
    if (product != null &&
        product["images"] != null &&
        product["images"] is List) {
      photos.addAll(
        (product["images"] as List)
            .map((image) => image['large'] as String)
            .toList(),
      );
    }
    AttractionStruct newAttraction = AttractionStruct(
      name: json["name"],
      startingHour: castToString(json["startingHour"]),
      endingHour: castToString(json["endingHour"]),
      day: DateTime.parse(json["day"]),
      location: LatLng(json["lat"], json["lng"]),
      city: json["city"],
      country: json["country"],
      //description: product != null ? product["description"] : "No Description",
      productTitle: product != null ? product["title"] : "No Title",
      productPrice: product != null ? castToDouble(product["price"]) : 0,
      productSummary: product != null
          ? product["summary"]
          : (summary != null &&
                  !(summary is String) &&
                  summary["text"] != null &&
                  summary["text"] is String
              ? summary["text"]
              : "No description available"),
      productCheckoutUrl:
          product != null ? product["product_checkout_url"] : "No Url",
      productRating: product != null ? castToDouble(product["rating"]) : 4,
      images: photos,
      whatsIncluded: product != null ? product["whats_included"] : "none",
      wheelChairAccess: product != null
          ? getWheelChairInfo(product["wheelchair_access"])
          : (accessibility != null && !(accessibility is String)
              ? (accessibility["wheelchairAccessibleEntrance"] != null
                  ? getWheelChairInfo(
                      accessibility["wheelchairAccessibleEntrance"])
                  : "No information available")
              : "No information available"),
    );
    attractionsList.add(newAttraction);
  }
  return attractionsList;
}

String getImageFromAttractions(List<dynamic> attractions) {
  List<String> images = [];

  for (var attraction in attractions) {
    var product = attraction["product"];
    if (attraction["photos"] != null && attraction["photos"] != "") {
      images.add(attraction["photos"] as String);
    }
    if (product != null && product["images"] != null) {
      images.addAll(
        (product["images"] as List)
            .map((image) => image['large'] as String)
            .toList(),
      );
    }
  }

  String randomImage = "None";
  if (images.isNotEmpty) {
    // Generate a random index
    final randomIndex = math.Random().nextInt(images.length);

    // Pick a random image
    randomImage = images[randomIndex];

    print('Random Image: $randomImage');
  } else {
    print('The list is empty.');
  }
  return randomImage;
}

double getLatorLng(
  LatLng location,
  String field,
) {
  if (field == "lat") {
    return location.latitude;
  } else {
    return location.longitude;
  }
}

String getHoursFormatted(DateTime data) {
  int hour = data.hour;
  return '$hour:00';
}

List<AttractionStruct> attractionTop10fromJson(dynamic attractionsJson) {
  List<AttractionStruct> attractionsList = [];

  for (int i = 0; i < attractionsJson.length; i++) {
    dynamic json = attractionsJson[i];

    List<String> photos = [];
    if (json["photos"] != null &&
        json["photos"] is String &&
        json["photos"] != "") {
      photos.add(json["photos"] as String);
    }
    if (json["product_photos"] != null && json["product_photos"] is List) {
      photos.addAll(
        (json["product_photos"] as List)
            .map((image) => image['large'] as String)
            .toList(),
      );
    }
    AttractionStruct newAttraction = AttractionStruct(
      name: json["place"],
      images: photos,
    );

    attractionsList.add(newAttraction);
  }

  return attractionsList;
}

String getReqAndRemStrings(List<String> attractions) {
  String result = '';

  if (attractions.isEmpty) {
    return result;
  }
  result += '${attractions[0]}';

  for (int i = 1; i < attractions.length; i++) {
    result += ',${attractions[i]}';
  }
  return result;
}

AttractionStruct setVisited(AttractionStruct attraction) {
  return AttractionStruct(
    name: attraction.name,
    location: attraction.location,
    city: attraction.city,
    country: attraction.country,
    description: attraction.description,
    productTitle: attraction.productTitle,
    productSummary: attraction.productSummary,
    productCheckoutUrl: attraction.productCheckoutUrl,
    productRating: attraction.productRating,
    images: attraction.images,
    day: attraction.day,
    startingHour: attraction.startingHour,
    endingHour: attraction.endingHour,
    productPrice: attraction.productPrice,
    wheelChairAccess: attraction.wheelChairAccess,
    whatsIncluded: attraction.whatsIncluded,
    isVisited: true,
  );
}

String getCategoriesText(List<String> categories) {
  String result = '${categories[0]}';
  for (int i = 1; i < categories.length; i++) {
    result += ',${categories[i]}';
  }
  return result;
}

String imageFromJson(dynamic json) {
  if (json["image"] != null &&
      json["image"] is String &&
      json["image"] != "https://via.placeholder.com/300")
    return json["image"];
  else
    return "";
}
