// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'index.dart';
import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart' as FMTC;
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:latlong2/latlong.dart' as ll;

class MapTest extends StatefulWidget {
  const MapTest({
    super.key,
    this.width,
    this.height,
    this.accessToken,
  });

  final double? width;
  final double? height;
  final String? accessToken;

  @override
  State<MapTest> createState() => _MapTestState();
}

class _MapTestState extends State<MapTest> {
  final MapController _mapController = MapController();
  TileProvider? _tileProvider;
  ll.LatLng? _currentLocation;
  String? _errorMessage;
  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    print('Initializing map...');
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    await _getCurrentLocation();
    await _downloadAndLoadMap();
    if (mounted) {
      setState(() {
        _isMapReady = true;
        print('Map is ready to display.');
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      print('Fetching current location...');
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        print('Requesting location permissions...');
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied.');
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _currentLocation = ll.LatLng(position.latitude, position.longitude);
      print('Current location obtained: $_currentLocation');
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to get current location: $e';
      });
      print('Error getting location: $e');
    }
  }

  Future<void> _downloadAndLoadMap() async {
    try {
      print('Starting map download and load...');
      final supabase = Supabase.instance.client;
      final fileName = 'exported_tiles.fmtc';
      final bucketName = 'mb-files';

      // Define local file path.
      final directory = await getApplicationDocumentsDirectory();
      final localFilePath = '${directory.path}/$fileName';
      print('Local file path: $localFilePath');

      // Check if the file exists locally; if not, download it.
      if (!File(localFilePath).existsSync()) {
        print('File not found locally, starting download...');
        final response =
            await supabase.storage.from(bucketName).download(fileName);
        print('Download completed, writing to file...');
        await File(localFilePath).writeAsBytes(response);
        print('File downloaded and saved to $localFilePath');
      } else {
        print('File already exists locally. Skipping download.');
      }

      // Set up the RootExternal from the local file.
      print('Setting up RootExternal from $localFilePath...');
      final rootExternal = FMTC.FMTCRoot.external(pathToArchive: localFilePath);

      // Import all stores from the file.
      final importResult = rootExternal.import(
        storeNames: null, // Import all stores.
        strategy: FMTC.ImportConflictStrategy.rename,
      );
      await importResult.complete;
      print('Stores imported successfully.');

      // Log available stores using RootStats.
      final stats = FMTC.FMTCRoot.stats;
      final storesAvailable = await stats.storesAvailable;
      print('Available stores:');
      for (final store in storesAvailable) {
        print('- ${store.storeName}');
      }

      // Check if the current location falls within any available store region.
      String? matchedStoreName;
      for (final store in storesAvailable) {
        // Replace with actual logic to match location to store.
        if (_isLocationWithinStoreRegion(_currentLocation!, store.storeName)) {
          matchedStoreName = store.storeName;
          break;
        }
      }

      // Set up the TileProvider based on the matched store.
      if (matchedStoreName != null) {
        print('Using offline store: $matchedStoreName');
        final store = FMTC.FMTCStore(matchedStoreName);
        _tileProvider = store.getTileProvider(
          settings: FMTC.FMTCTileProviderSettings(
            behavior: FMTC.CacheBehavior.cacheFirst,
          ),
        );
      } else {
        print('No matched store found. Using online fallback.');
        // Optionally, handle a fallback here.
      }

      print('TileProvider set up successfully.');
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading map: $e';
      });
      print('Error loading map: $e');
    }
  }

  bool _isLocationWithinStoreRegion(ll.LatLng location, String storeName) {
    // Implement your logic to check if the location falls within the store region.
    // For simplicity, returning true here.
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return Center(
        child: Text('Error: $_errorMessage'),
      );
    }

    if (!_isMapReady || _currentLocation == null) {
      return const Center(child: CircularProgressIndicator());
    }

    print('Rendering map with current location: $_currentLocation');

    return SizedBox(
      width: widget.width ?? MediaQuery.of(context).size.width,
      height: widget.height ?? MediaQuery.of(context).size.height,
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _currentLocation ?? ll.LatLng(0, 0),
          initialZoom: 18.0,
          minZoom: 13.0,
          maxZoom: 22.0,
        ),
        children: [
          if (_tileProvider != null)
            TileLayer(
              urlTemplate:
                  'https://api.mapbox.com/styles/v1/mapbox/satellite-v9/tiles/{z}/{x}/{y}@2x?access_token=${widget.accessToken}',
              tileProvider: _tileProvider!,
            ),
        ],
      ),
    );
  }
}

// --------------------------------- BACKUP
// import '/backend/schema/structs/index.dart';
// import '/backend/supabase/supabase.dart';
// import '/backend/sqlite/sqlite_manager.dart';
// import '/actions/actions.dart' as action_blocks;
// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import 'index.dart';
// import '/custom_code/actions/index.dart';
// import '/flutter_flow/custom_functions.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart' as FMTC;
// import 'package:geolocator/geolocator.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';
// import 'package:latlong2/latlong.dart' as ll;

// class MapTest extends StatefulWidget {
//   const MapTest({
//     super.key,
//     this.width,
//     this.height,
//     this.accessToken,
//   });

//   final double? width;
//   final double? height;
//   final String? accessToken;

//   @override
//   State<MapTest> createState() => _MapTestState();
// }

// class _MapTestState extends State<MapTest> {
//   final MapController _mapController = MapController();
//   TileProvider? _tileProvider;
//   ll.LatLng? _currentLocation;
//   String? _errorMessage;
//   bool _isMapReady = false;

//   @override
//   void initState() {
//     super.initState();
//     print('Initializing map...');
//     _initializeMap();
//   }

//   Future<void> _initializeMap() async {
//     await _getCurrentLocation();
//     await _downloadAndLoadMap();
//     if (mounted) {
//       setState(() {
//         _isMapReady = true;
//         print('Map is ready to display.');
//       });
//     }
//   }

//   Future<void> _getCurrentLocation() async {
//     try {
//       print('Fetching current location...');
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         throw Exception('Location services are disabled.');
//       }

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         print('Requesting location permissions...');
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           throw Exception('Location permissions are denied.');
//         }
//       }

//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//       _currentLocation = ll.LatLng(position.latitude, position.longitude);
//       print('Current location obtained: $_currentLocation');
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Failed to get current location: $e';
//       });
//       print('Error getting location: $e');
//     }
//   }

//   Future<void> _downloadAndLoadMap() async {
//     try {
//       print('Starting map download and load...');
//       final supabase = Supabase.instance.client;
//       final fileName = 'exported_tiles.fmtc';
//       final bucketName = 'mb-files';

//       // Define local file path.
//       final directory = await getApplicationDocumentsDirectory();
//       final localFilePath = '${directory.path}/$fileName';
//       print('Local file path: $localFilePath');

//       // Check if the file exists locally; if not, download it.
//       if (!File(localFilePath).existsSync()) {
//         print('File not found locally, starting download...');
//         final response =
//             await supabase.storage.from(bucketName).download(fileName);
//         print('Download completed, writing to file...');
//         await File(localFilePath).writeAsBytes(response);
//         print('File downloaded and saved to $localFilePath');
//       } else {
//         print('File already exists locally. Skipping download.');
//       }

//       // Set up the RootExternal from the local file.
//       print('Setting up RootExternal from $localFilePath...');
//       final rootExternal = FMTC.FMTCRoot.external(pathToArchive: localFilePath);

//       // Import all stores from the file.
//       final importResult = rootExternal.import(
//         storeNames: null, // Import all stores.
//         strategy: FMTC.ImportConflictStrategy.rename,
//       );
//       await importResult.complete;
//       print('Stores imported successfully.');

//       // Log available stores using RootStats.
//       final stats = FMTC.FMTCRoot.stats;
//       final storesAvailable = await stats.storesAvailable;
//       print('Available stores:');
//       for (final store in storesAvailable) {
//         print('- ${store.storeName}');
//       }

//       // Check if the current location falls within any available store region.
//       String? matchedStoreName;
//       for (final store in storesAvailable) {
//         // Replace with actual logic to match location to store.
//         if (_isLocationWithinStoreRegion(_currentLocation!, store.storeName)) {
//           matchedStoreName = store.storeName;
//           break;
//         }
//       }

//       // Set up the TileProvider based on the matched store.
//       if (matchedStoreName != null) {
//         print('Using offline store: $matchedStoreName');
//         final store = FMTC.FMTCStore(matchedStoreName);
//         _tileProvider = store.getTileProvider(
//           settings: FMTC.FMTCTileProviderSettings(
//             behavior: FMTC.CacheBehavior.cacheFirst,
//           ),
//         );
//       } else {
//         print('No matched store found. Using online fallback.');
//         // Optionally, handle a fallback here.
//       }

//       print('TileProvider set up successfully.');
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Error loading map: $e';
//       });
//       print('Error loading map: $e');
//     }
//   }

//   bool _isLocationWithinStoreRegion(ll.LatLng location, String storeName) {
//     // Implement your logic to check if the location falls within the store region.
//     // For simplicity, returning true here.
//     return true;
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_errorMessage != null) {
//       return Center(
//         child: Text('Error: $_errorMessage'),
//       );
//     }

//     if (!_isMapReady || _currentLocation == null) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     print('Rendering map with current location: $_currentLocation');

//     return SizedBox(
//       width: widget.width ?? MediaQuery.of(context).size.width,
//       height: widget.height ?? MediaQuery.of(context).size.height,
//       child: FlutterMap(
//         mapController: _mapController,
//         options: MapOptions(
//           initialCenter: _currentLocation ?? ll.LatLng(0, 0),
//           initialZoom: 18.0,
//           minZoom: 13.0,
//           maxZoom: 22.0,
//         ),
//         children: [
//           if (_tileProvider != null)
//             TileLayer(
//               urlTemplate:
//                   'https://api.mapbox.com/styles/v1/mapbox/satellite-v9/tiles/{z}/{x}/{y}@2x?access_token=${widget.accessToken}',
//               tileProvider: _tileProvider!,
//             ),
//         ],
//       ),
//     );
//   }
// }
