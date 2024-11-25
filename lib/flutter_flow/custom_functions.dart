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

int? getStringText(String? text) {
  return text != null ? (text.length * 8 + 25) : null;
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
  double distance = sliderIndex / 18;
  String result = distance.toStringAsFixed(2);
  return '$result km';
}

double getRadius(double sliderIndex) {
  double radius = sliderIndex / 18;
  double result = double.parse(radius.toStringAsFixed(2));
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

  for (int i = 0; i < attractionsJson.length; i++) {
    dynamic json = attractionsJson[i];

    print(json);

    var product = json["product"];
    AttractionStruct newAttraction = AttractionStruct(
      name: json["name"],
      productName: json["productName"],
      startingHour: json["startingHour"],
      endingHour: json["endingHour"],
      day: DateTime.parse(json["day"]),
      location: LatLng(json["lat"], json["lng"]),
      city: json["city"],
      country: json["country"],
      description: json["description"],
      productTitle: product != null ? product["title"] : "No Title",
      productPrice: product != null ? product["price"] : 0,
      productSummary: product != null ? product["summary"] : "No Summary",
      productCheckoutUrl:
          product != null ? product["product_checkout_url"] : "No Url",
      productRating: product != null ? product["rating"] : 0,
      images: product != null && product["images"] != null
          ? (product["images"] as List)
              .map((image) => image['large'] as String)
              .toList()
          : [],
    );

    attractionsList.add(newAttraction);
  }

  return attractionsList;
}

String getImageFromAttractions(List<dynamic> attractions) {
  List<String> images = [];

  for (var attraction in attractions) {
    var product = attraction["product"];
    if (product != null && product["images"] != null) {
      images.addAll(
        (product["images"] as List)
            .map((image) => image['small'] as String)
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
