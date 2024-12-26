// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:http/http.dart' as http;
import 'dart:convert';

Future<dynamic> fetchAddressFromCoordinates(
  double? lng,
  double? lat,
) async {
  if (lng == null || lat == null) {
    throw ArgumentError('Longitude and latitude must not be null');
  }

  bool isOnline = FFAppState().ONLINE;

  if (isOnline) {
    final url =
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lng&addressdetails=1';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final address = data['address'] as Map<String, dynamic>;
        return {
          'barangayVillage': address['suburb'] ?? '',
          'buildingName': address['building'] ?? '',
          'city': address['city'] ?? address['town'] ?? '',
          'country': address['country'] ?? '',
          'province': address['state'] ?? '',
          'street': address['road'] ?? '',
          'unitLotNo': address['house_number'] ?? '',
          'zipCode': address['postcode'] ?? '',
        };
      } else {
        throw Exception('Failed to fetch address: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching address: $e');
    }
  } else {
    // Offline scenario
    return {
      'barangayVillage': 'Offline',
      'buildingName': 'Offline',
      'city': 'Offline',
      'country': 'Offline',
      'province': 'Offline',
      'street': 'Offline',
      'unitLotNo': 'Offline',
      'zipCode': 'Offline',
      'coordinates': '$lat, $lng', // Include the coordinates for reference
    };
  }
}
