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
  return text != null ? (text.length * 9 + 20) : null;
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
