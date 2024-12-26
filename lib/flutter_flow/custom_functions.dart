import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/auth/supabase_auth/auth_util.dart';

double? getLat(LatLng? latlng) {
  return latlng?.latitude;
}

double? getLng(LatLng? latlng) {
  return latlng?.longitude;
}

String? removePpirOnString(String? text) {
  // remove the PPIR on the string
  return text?.replaceAll('PPIR', '');
}

String? sentenceCaseWords(String? text) {
  // sentence case each what is in the text
  if (text == null || text.isEmpty) {
    return text;
  }
  final words = text.split(' ');
  final capitalizedWords = words.map((word) {
    if (word.isEmpty) {
      return word;
    }
    final firstLetter = word[0].toUpperCase();
    final restOfWord = word.substring(1).toLowerCase();
    return '$firstLetter$restOfWord';
  });
  return capitalizedWords.join(' ');
}

LatLng kalmanFilterAlgo(
  double latitude,
  double longitude,
  double previousLatitude,
  double previousLongitude,
  double previousErrorCovarianceLat,
  double previousErrorCovarianceLng,
) {
  double q = 0.0001; // Process noise covariance
  double r = 0.01; // Measurement noise covariance

  // Kalman filter calculation for latitude
  double pLat = previousErrorCovarianceLat + q;
  double kLat = pLat / (pLat + r);
  double filteredLat = previousLatitude + kLat * (latitude - previousLatitude);
  double updatedErrorCovarianceLat = (1 - kLat) * pLat;

  // Kalman filter calculation for longitude
  double pLng = previousErrorCovarianceLng + q;
  double kLng = pLng / (pLng + r);
  double filteredLng =
      previousLongitude + kLng * (longitude - previousLongitude);
  double updatedErrorCovarianceLng = (1 - kLng) * pLng;

  // Return the filtered LatLng coordinates
  return LatLng(filteredLat, filteredLng);
}

String? getAddress(dynamic data) {
  if (data == null || data is! Map<String, dynamic>) {
    return null;
  }

  List<String> addressParts = [];

  if (data['unitLotNo']?.isNotEmpty == true) {
    addressParts.add(data['unitLotNo']);
  }
  if (data['buildingName']?.isNotEmpty == true) {
    addressParts.add(data['buildingName']);
  }
  if (data['street']?.isNotEmpty == true) {
    addressParts.add(data['street']);
  }
  if (data['barangayVillage']?.isNotEmpty == true) {
    addressParts.add(data['barangayVillage']);
  }
  if (data['city']?.isNotEmpty == true) {
    addressParts.add(data['city']);
  }
  if (data['province']?.isNotEmpty == true) {
    addressParts.add(data['province']);
  }
  if (data['zipCode']?.isNotEmpty == true) {
    addressParts.add(data['zipCode']);
  }
  if (data['country']?.isNotEmpty == true) {
    addressParts.add(data['country']);
  }

  return addressParts.join(', ');
}

String? lowerCaseWords(String? text) {
  //  if (text == null) { return null; } return text.toLowerCase();
  return text != null ? text.toLowerCase() : null;
}

String? capitalizeWords(String? text) {
  // if (text == null || text.isEmpty) { return text;  } return text.toUpperCase();
  return (text == null || text.isEmpty) ? text : text.toUpperCase();
}

String sanitizeStoreName(String storeName) {
  return storeName.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_').toLowerCase();
}

bool? checkIfNull(String? attribute) {
  // if (attribute == null) { return true;  } else { return false; }
  return attribute == null;
}

String? convertDateToString(String? date) {
  // update the date string like this 2024-08-04 10:05:58 to a proper date format
  return "";
}

String? timesStampConverter(String? date) {
  // If date is null or empty, return null
  if (date == null || date.isEmpty) {
    return null;
  }

  // Check if the date is already in the desired format
  final RegExp formattedPattern = RegExp(
      r'^(Mon|Tue|Wed|Thu|Fri|Sat|Sun)\. [A-Z][a-z]+ \d{2}, \d{4} - \d{1,2}:\d{2}(am|pm)$');
  if (formattedPattern.hasMatch(date)) {
    return date; // Already formatted, return as is
  }

  try {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate =
        DateFormat('E. MMMM dd, yyyy - h:mma').format(dateTime);
    return formattedDate;
  } catch (e) {
    print('Error parsing date: $date');
    return date; // Return original string if parsing fails
  }
}

String formatDate(String? input) {
  if (input == null || input.isEmpty) return '';
  try {
    final parts = input.split('/');
    if (parts.length != 3) return input;
    final day = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final year = int.parse(parts[2]);
    final date = DateTime(year, month, day);
    return DateFormat('MM/dd/yyyy').format(date);
  } catch (e) {
    return input; // Return original string if parsing fails
  }
}

String? timeStampToMoment(String? timestampString) {
  // Check if the input string is null, 'null', or empty.
  if (timestampString == null ||
      timestampString == 'null' ||
      timestampString.isEmpty) return 'a moment ago';

  // Parse the timestamp string into a DateTime object.
  DateTime? timestamp;
  try {
    timestamp = DateTime.parse(timestampString);
  } catch (e) {
    // If parsing fails, return an error indication or fallback.
    return 'Invalid timestamp';
  }

  // Calculate the time difference between the parsed timestamp and the current time.
  final now = DateTime.now();
  final difference = now.difference(timestamp);

  // Handle custom time ranges for seconds, minutes, hours, days, weeks, months, and years.
  if (difference.inSeconds < 60) {
    return 'a moment ago';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
  } else if (difference.inDays < 7) {
    return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
  } else if (difference.inDays < 30) {
    final weeks = (difference.inDays / 7).floor();
    return '$weeks week${weeks > 1 ? 's' : ''} ago';
  } else if (difference.inDays < 365) {
    final months = (difference.inDays / 30).floor();
    return '$months month${months > 1 ? 's' : ''} ago';
  } else {
    final years = (difference.inDays / 365).floor();
    return '$years year${years > 1 ? 's' : ''} ago';
  }
}
