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

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:xml/xml.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart' as FMTC;

class MapBase64 extends StatefulWidget {
  const MapBase64({
    super.key,
    this.width,
    this.height,
    this.blob,
    required this.accessToken,
  });

  final double? width;
  final double? height;
  final String? blob;
  final String accessToken;

  @override
  State<MapBase64> createState() => _MapBase64State();
}

class _MapBase64State extends State<MapBase64> {
  List<latlong.LatLng> _coordinates = [];
  late final MapController _mapController;
  double _currentZoom = 17.0;
  bool _isLoading = true;
  TileProvider? _tileProvider;
  String? _storeName;
  String? _errorMessage;
  latlong.LatLng? _initialCenter;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _initializeMap();
  }

  @override
  void didUpdateWidget(MapBase64 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.blob != oldWidget.blob) {
      _resetState();
      _initializeMap();
    }
  }

  void _resetState() {
    setState(() {
      _coordinates = [];
      _isLoading = true;
      _tileProvider = null;
      _storeName = null;
      _errorMessage = null;
      _currentZoom = 17.0;
      _initialCenter = null;
    });
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _initializeMap() async {
    try {
      print('Initializing map with blob: ${widget.blob}');
      if (widget.blob != null &&
          widget.blob!.trim().isNotEmpty &&
          widget.blob!.toLowerCase() != "null") {
        await _parseGPX(widget.blob!);
        if (_coordinates.isNotEmpty) {
          await _initializeTileProvider();
          _calculateInitialView();
        }
      } else {
        _errorMessage = 'No GPS data available';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _parseGPX(String base64Data) async {
    try {
      final document = XmlDocument.parse(utf8.decode(base64Decode(base64Data)));
      _coordinates = document.findAllElements('trkpt').map((trkpt) {
        return latlong.LatLng(
          double.parse(trkpt.getAttribute('lat')!),
          double.parse(trkpt.getAttribute('lon')!),
        );
      }).toList();

      if (_coordinates.isEmpty) {
        _errorMessage = 'No GPS coordinates found in the data';
      }
    } catch (e) {
      print('Error parsing GPX data: $e');
      _errorMessage = 'Error parsing GPX data: $e';
    }
  }

  Future<void> _initializeTileProvider() async {
    if (_coordinates.isEmpty) {
      print('No coordinates available');
      return;
    }

    // Use the first coordinate from the GPX data
    final firstCoordinate = _coordinates.first;

    final stats = FMTC.FMTCRoot.stats;
    final stores = await stats.storesAvailable;
    print('Available stores: ${stores.length}');

    for (var store in stores) {
      print('Checking store: ${store.storeName}');
      final md = FMTC.FMTCStore(store.storeName).metadata;
      final metadata = await md.read;
      print('Metadata for ${store.storeName}: $metadata');

      if (metadata != null) {
        try {
          Map<String, double> regionData = {
            'region_south': double.tryParse(metadata['minLat'] ?? '') ?? 0.0,
            'region_north': double.tryParse(metadata['maxLat'] ?? '') ?? 0.0,
            'region_west': double.tryParse(metadata['minLon'] ?? '') ?? 0.0,
            'region_east': double.tryParse(metadata['maxLon'] ?? '') ?? 0.0,
          };
          print('Parsed region data: $regionData');

          if (_isLocationInRegion(firstCoordinate, regionData)) {
            _storeName = store.storeName;
            print('Found store based on the first coordinate: $_storeName');

            _tileProvider = FMTC.FMTCStore(_storeName!).getTileProvider(
              settings: FMTC.FMTCTileProviderSettings(
                behavior: FMTC.CacheBehavior.cacheFirst,
              ),
            );
            print('Tile provider initialized with store: $_storeName');
            break;
          }
        } catch (e) {
          print('Error processing metadata for ${store.storeName}: $e');
        }
      } else {
        print('Metadata is null for ${store.storeName}');
      }
    }

    if (_storeName == null) {
      print('No matching store found for the provided GPX data.');
    }
  }

  bool _isLocationInRegion(
      latlong.LatLng location, Map<String, double> region) {
    print('Checking location: ${location.latitude}, ${location.longitude}');
    print('Region: $region');

    return location.latitude >= region['region_south']! &&
        location.latitude <= region['region_north']! &&
        location.longitude >= region['region_west']! &&
        location.longitude <= region['region_east']!;
  }

  void _calculateInitialView() {
    if (_coordinates.isNotEmpty) {
      final bounds = _calculateBounds(_coordinates);
      final centerLat = (bounds[0] + bounds[2]) / 2;
      final centerLon = (bounds[1] + bounds[3]) / 2;
      _initialCenter = latlong.LatLng(centerLat, centerLon);
      _currentZoom = _calculateZoom(bounds);
    }
  }

  List<double> _calculateBounds(List<latlong.LatLng> points) {
    double minLat = 90, maxLat = -90, minLon = 180, maxLon = -180;
    for (var point in points) {
      minLat = math.min(minLat, point.latitude);
      maxLat = math.max(maxLat, point.latitude);
      minLon = math.min(minLon, point.longitude);
      maxLon = math.max(maxLon, point.longitude);
    }
    return [minLat, minLon, maxLat, maxLon];
  }

  double _calculateZoom(List<double> bounds) {
    const WORLD_PX = 256.0;
    const ZOOM_MAX = 21.0;
    const ZOOM_MIN = 1.0;

    final latFraction = (bounds[2] - bounds[0]) / 180.0;
    final lonFraction = (bounds[3] - bounds[1]) / 360.0;

    final latZoom = math.log(WORLD_PX / latFraction) / math.ln2;
    final lonZoom = math.log(WORLD_PX / lonFraction) / math.ln2;

    return math.min(latZoom, lonZoom).clamp(ZOOM_MIN, ZOOM_MAX) - 1;
  }

  void _zoomIn() {
    _currentZoom = math.min(_currentZoom + 1, 21);
    _mapController.move(_mapController.camera.center, _currentZoom);
  }

  void _zoomOut() {
    _currentZoom = math.max(_currentZoom - 1, 1);
    _mapController.move(_mapController.camera.center, _currentZoom);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }

    if (_coordinates.isEmpty || _initialCenter == null) {
      return const Center(child: Text('No GPS data available'));
    }

    return Stack(
      children: [
        SizedBox(
          width: widget.width,
          height: widget.height,
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              minZoom: 17,
              maxZoom: 22,
              initialCenter: _initialCenter!,
              initialZoom: _currentZoom,
            ),
            children: [
              TileLayer(
                tileProvider: _tileProvider ??
                    NetworkTileProvider(), // Fallback to NetworkTileProvider if _tileProvider is null
                urlTemplate:
                    'https://api.mapbox.com/styles/v1/mapbox/satellite-v9/tiles/{z}/{x}/{y}@2x?access_token=${widget.accessToken}',
                additionalOptions: {'accessToken': widget.accessToken},
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _coordinates,
                    strokeWidth: 4.0,
                    color: Colors.blue,
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                mini: true,
                onPressed: _zoomIn,
                child: const Icon(Icons.add),
              ),
              const SizedBox(height: 8),
              FloatingActionButton(
                mini: true,
                onPressed: _zoomOut,
                child: const Icon(Icons.remove),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// import 'index.dart'; // Imports other custom widgets

// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart' as latlong;
// import 'package:xml/xml.dart';
// import 'dart:convert';
// import 'dart:math' as math;
// import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart' as FMTC;

// class MapBase64 extends StatefulWidget {
//   const MapBase64({
//     super.key,
//     this.width,
//     this.height,
//     this.blob,
//     required this.accessToken,
//   });

//   final double? width;
//   final double? height;
//   final String? blob;
//   final String accessToken;

//   @override
//   State<MapBase64> createState() => _MapBase64State();
// }

// class _MapBase64State extends State<MapBase64> {
//   List<latlong.LatLng> _coordinates = [];
//   late final MapController _mapController;
//   double _currentZoom = 17.0;
//   bool _isLoading = true;
//   TileProvider? _tileProvider;
//   String? _storeName;
//   String? _errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     _mapController = MapController();
//     _initializeMap();
//   }

//   @override
//   void didUpdateWidget(MapBase64 oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.blob != oldWidget.blob) {
//       _resetState();
//       _initializeMap();
//     }
//   }

//   void _resetState() {
//     setState(() {
//       _coordinates = [];
//       _isLoading = true;
//       _tileProvider = null;
//       _storeName = null;
//       _errorMessage = null;
//       _currentZoom = 17.0;
//     });
//   }

//   @override
//   void dispose() {
//     _mapController.dispose();
//     super.dispose();
//   }

//   Future<void> _initializeMap() async {
//     try {
//       print('Initializing map with blob: ${widget.blob}');
//       if (widget.blob != null &&
//           widget.blob!.trim().isNotEmpty &&
//           widget.blob!.toLowerCase() != "null") {
//         await _parseGPX(widget.blob!);
//         if (_coordinates.isNotEmpty) {
//           await _initializeTileProvider();
//         }
//       } else {
//         _errorMessage = 'No GPS data available';
//       }
//     } catch (e) {
//       _errorMessage = e.toString();
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _parseGPX(String base64Data) async {
//     try {
//       final document = XmlDocument.parse(utf8.decode(base64Decode(base64Data)));
//       _coordinates = document.findAllElements('trkpt').map((trkpt) {
//         return latlong.LatLng(
//           double.parse(trkpt.getAttribute('lat')!),
//           double.parse(trkpt.getAttribute('lon')!),
//         );
//       }).toList();

//       if (_coordinates.isEmpty) {
//         _errorMessage = 'No GPS coordinates found in the data';
//       } else {
//         WidgetsBinding.instance.addPostFrameCallback((_) => _centerMap());
//       }
//     } catch (e) {
//       print('Error parsing GPX data: $e');
//       _errorMessage = 'Error parsing GPX data: $e';
//     }
//   }

//   Future<void> _initializeTileProvider() async {
//     if (_coordinates.isEmpty) {
//       print('No coordinates available');
//       return;
//     }

//     // Use the first coordinate from the GPX data
//     final firstCoordinate = _coordinates.first;

//     final stats = FMTC.FMTCRoot.stats;
//     final stores = await stats.storesAvailable;
//     print('Available stores: ${stores.length}');

//     for (var store in stores) {
//       print('Checking store: ${store.storeName}');
//       final md = FMTC.FMTCStore(store.storeName).metadata;
//       final metadata = await md.read;
//       print('Metadata for ${store.storeName}: $metadata');

//       if (metadata != null) {
//         try {
//           // Extract the region boundaries from the metadata
//           Map<String, double> regionData = {
//             'region_south': double.tryParse(metadata['minLat'] ?? '') ?? 0.0,
//             'region_north': double.tryParse(metadata['maxLat'] ?? '') ?? 0.0,
//             'region_west': double.tryParse(metadata['minLon'] ?? '') ?? 0.0,
//             'region_east': double.tryParse(metadata['maxLon'] ?? '') ?? 0.0,
//           };
//           print('Parsed region data: $regionData');

//           // Check if the first coordinate is within this region's boundaries
//           if (_isLocationInRegion(firstCoordinate, regionData)) {
//             _storeName = store.storeName;
//             print('Found store based on the first coordinate: $_storeName');

//             _tileProvider = FMTC.FMTCStore(_storeName!).getTileProvider(
//               settings: FMTC.FMTCTileProviderSettings(
//                 behavior: FMTC.CacheBehavior.cacheFirst,
//               ),
//             );
//             print('Tile provider initialized with store: $_storeName');
//             break; // Stop checking further stores once a match is found
//           }
//         } catch (e) {
//           print('Error processing metadata for ${store.storeName}: $e');
//         }
//       } else {
//         print('Metadata is null for ${store.storeName}');
//       }
//     }

//     if (_storeName == null) {
//       print('No matching store found for the provided GPX data.');
//     }
//   }

//   bool _isLocationInRegion(
//       latlong.LatLng location, Map<String, double> region) {
//     print('Checking location: ${location.latitude}, ${location.longitude}');
//     print('Region: $region');

//     return location.latitude >= region['region_south']! &&
//         location.latitude <= region['region_north']! &&
//         location.longitude >= region['region_west']! &&
//         location.longitude <= region['region_east']!;
//   }

//   void _centerMap() {
//     if (_coordinates.isNotEmpty) {
//       final bounds = _calculateBounds(_coordinates);
//       final centerLat = (bounds[0] + bounds[2]) / 2;
//       final centerLon = (bounds[1] + bounds[3]) / 2;
//       _currentZoom = _calculateZoom(bounds);
//       _mapController.move(latlong.LatLng(centerLat, centerLon), _currentZoom);
//     }
//   }

//   List<double> _calculateBounds(List<latlong.LatLng> points) {
//     double minLat = 90, maxLat = -90, minLon = 180, maxLon = -180;
//     for (var point in points) {
//       minLat = math.min(minLat, point.latitude);
//       maxLat = math.max(maxLat, point.latitude);
//       minLon = math.min(minLon, point.longitude);
//       maxLon = math.max(maxLon, point.longitude);
//     }
//     return [minLat, minLon, maxLat, maxLon];
//   }

//   double _calculateZoom(List<double> bounds) {
//     const WORLD_PX = 256.0;
//     const ZOOM_MAX = 21.0;
//     const ZOOM_MIN = 1.0;

//     final latFraction = (bounds[2] - bounds[0]) / 180.0;
//     final lonFraction = (bounds[3] - bounds[1]) / 360.0;

//     final latZoom = math.log(WORLD_PX / latFraction) / math.ln2;
//     final lonZoom = math.log(WORLD_PX / lonFraction) / math.ln2;

//     return math.min(latZoom, lonZoom).clamp(ZOOM_MIN, ZOOM_MAX) - 1;
//   }

//   void _zoomIn() {
//     _currentZoom = math.min(_currentZoom + 1, 21);
//     _mapController.move(_mapController.camera.center, _currentZoom);
//   }

//   void _zoomOut() {
//     _currentZoom = math.max(_currentZoom - 1, 1);
//     _mapController.move(_mapController.camera.center, _currentZoom);
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (_errorMessage != null) {
//       return Center(child: Text(_errorMessage!));
//     }

//     if (_coordinates.isEmpty) {
//       return const Center(child: Text('No GPS data available'));
//     }

//     return Stack(
//       children: [
//         SizedBox(
//           width: widget.width,
//           height: widget.height,
//           child: FlutterMap(
//             mapController: _mapController,
//             options: MapOptions(
//               minZoom: 18,
//               maxZoom: 22,
//               initialCenter: _coordinates.first,
//               initialZoom: _currentZoom,
//             ),
//             children: [
//               if (_tileProvider != null)
//                 TileLayer(
//                   tileProvider: _tileProvider!,
//                   urlTemplate:
//                       'https://api.mapbox.com/styles/v1/mapbox/satellite-v9/tiles/{z}/{x}/{y}@2x?access_token=${widget.accessToken}',
//                   additionalOptions: {'accessToken': widget.accessToken},
//                 )
//               else
//                 TileLayer(
//                   urlTemplate:
//                       'https://api.mapbox.com/styles/v1/mapbox/satellite-v9/tiles/{z}/{x}/{y}@2x?access_token=${widget.accessToken}',
//                   additionalOptions: {'accessToken': widget.accessToken},
//                 ),
//               PolylineLayer(
//                 polylines: [
//                   Polyline(
//                     points: _coordinates,
//                     strokeWidth: 4.0,
//                     color: Colors.blue,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         Positioned(
//           right: 16,
//           bottom: 16,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               FloatingActionButton(
//                 mini: true,
//                 onPressed: _zoomIn,
//                 child: const Icon(Icons.add),
//               ),
//               const SizedBox(height: 8),
//               FloatingActionButton(
//                 mini: true,
//                 onPressed: _zoomOut,
//                 child: const Icon(Icons.remove),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
