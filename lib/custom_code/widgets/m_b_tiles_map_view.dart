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

import '/custom_code/widgets/index.dart';
import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:file_picker/file_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

class MBTilesMapView extends StatefulWidget {
  const MBTilesMapView({
    Key? key,
    this.width,
    this.height,
    required this.accessToken,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String accessToken;

  @override
  State<MBTilesMapView> createState() => _MBTilesMapViewState();
}

class _MBTilesMapViewState extends State<MBTilesMapView> {
  String? selectedFilePath;
  LatLngBounds? mapBounds;
  MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    print('Building MBTilesMapView widget');
    return Container(
      width: widget.width,
      height: widget.height,
      child: Column(
        children: [
          ElevatedButton(
            onPressed: _pickFile,
            child: Text('Select .mbtiles file'),
          ),
          Expanded(
            child: selectedFilePath != null
                ? Stack(
                    children: [
                      FlutterMap(
                        mapController: mapController,
                        options: MapOptions(
                          initialCenter: mapBounds?.center ?? ll.LatLng(0, 0),
                          initialZoom: 3,
                        ),
                        children: [
                          TileLayer(
                            tileProvider:
                                MBTilesTileProvider(selectedFilePath!),
                            errorImage: NetworkImage(
                                'https://via.placeholder.com/256x256.png?text=Tile+Not+Found'),
                            errorTileCallback: (tile, error, stackTrace) {
                              print('Error loading tile: $tile, error: $error');
                              print(stackTrace);
                            },
                          ),
                        ],
                      ),
                      if (selectedFilePath == null)
                        Center(child: Text('No file selected')),
                    ],
                  )
                : Center(child: Text('No file selected')),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFile() async {
    print('Starting file picker');
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );

      if (result != null) {
        String? filePath = result.files.single.path;
        print('File selected: $filePath');
        if (filePath != null && filePath.toLowerCase().endsWith('.mbtiles')) {
          setState(() {
            selectedFilePath = filePath;
          });
          _loadMBTilesBounds();
        } else {
          print('Selected file is not an .mbtiles file');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please select a .mbtiles file')),
          );
        }
      }
    } catch (e) {
      print('Error picking file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  Future<void> _loadMBTilesBounds() async {
    if (selectedFilePath == null) {
      print('No file selected for loading bounds');
      return;
    }

    if (!await File(selectedFilePath!).exists()) {
      print('MBTiles file not found: $selectedFilePath');
      return;
    }

    print('Loading MBTiles bounds from: $selectedFilePath');
    final db = await openDatabase(selectedFilePath!);

    try {
      final List<Map> metadata = await db.query('metadata');
      print('Metadata fetched: $metadata');
      final boundsString = metadata
          .firstWhere((row) => row['name'] == 'bounds')['value'] as String?;

      ll.LatLng center;
      double zoom = 10.0; // Default zoom level

      if (boundsString != null) {
        final bounds = boundsString.split(',').map(double.parse).toList();
        setState(() {
          mapBounds = LatLngBounds(
            ll.LatLng(bounds[1], bounds[0]),
            ll.LatLng(bounds[3], bounds[2]),
          );
        });
        center = mapBounds!.center;
        print('Map bounds loaded: $mapBounds');
      } else {
        center = ll.LatLng(14.5995, 120.9842);
        print('Bounds not found in metadata, defaulting to Manila');
      }

      mapController.move(center, zoom);
      print(
          'Map centered at: ${center.latitude}, ${center.longitude}, zoom: $zoom');
    } catch (e) {
      print('Error loading MBTiles bounds: $e');
      final center = ll.LatLng(14.5995, 120.9842);
      mapController.move(center, 10.0);
      print('Error occurred, defaulting to Manila');
    } finally {
      await db.close();
      print('Database closed after loading bounds');
    }
  }
}

class MBTilesTileProvider extends TileProvider {
  final String mbtilesPath;

  MBTilesTileProvider(this.mbtilesPath);

  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) {
    print(
        'Fetching tile image for: z=${coordinates.z}, x=${coordinates.x}, y=${coordinates.y}');
    return MBTilesImage(mbtilesPath, coordinates);
  }
}

class MBTilesImage extends ImageProvider<MBTilesImage> {
  final String mbtilesPath;
  final TileCoordinates coordinates;

  MBTilesImage(this.mbtilesPath, this.coordinates);

  @override
  Future<MBTilesImage> obtainKey(ImageConfiguration configuration) {
    return Future.value(this);
  }

  @override
  ImageStreamCompleter load(MBTilesImage key, ImageDecoderCallback decode) {
    return OneFrameImageStreamCompleter(_loadAsync(key, decode));
  }

  Future<ImageInfo> _loadAsync(
      MBTilesImage key, ImageDecoderCallback decode) async {
    assert(key == this);

    print(
        'Starting to load tile: z=${coordinates.z}, x=${coordinates.x}, y=${coordinates.y}');
    final db = await openDatabase(mbtilesPath);
    try {
      print('Database opened successfully');
      final List<Map> result = await db.query(
        'tiles',
        columns: ['tile_data'],
        where: 'zoom_level = ? AND tile_column = ? AND tile_row = ?',
        whereArgs: [
          coordinates.z,
          coordinates.x,
          (1 << coordinates.z) - 1 - coordinates.y // Flip Y for TMS
        ],
      );
      print('Query executed. Number of results: ${result.length}');

      if (result.isNotEmpty) {
        final tileData = result.first['tile_data'] as Uint8List;
        print(
            'Tile found: z=${coordinates.z}, x=${coordinates.x}, y=${coordinates.y}, size=${tileData.length} bytes');

        if (tileData.isEmpty) {
          print('Tile data is empty.');
          throw Exception('Tile data is empty.');
        }

        // Try creating buffer and decoding
        try {
          final buffer = await ui.ImmutableBuffer.fromUint8List(tileData);
          print('Buffer created from tile data, size: ${tileData.length}');
          final codec = await decode(buffer);
          print('Codec created from buffer, frame count: ${codec.frameCount}');
          final frame = await codec.getNextFrame();
          print(
              'Frame obtained from codec with image size: ${frame.image.width}x${frame.image.height}');
          return ImageInfo(image: frame.image);
        } catch (decodeError) {
          print('Error decoding tile data: $decodeError');
          throw Exception('Failed to decode tile image.');
        }
      } else {
        print(
            'Tile not found in database: z=${coordinates.z}, x=${coordinates.x}, y=${coordinates.y}');
        throw Exception('Tile not found');
      }
    } catch (e) {
      print(
          'Error loading tile: z=${coordinates.z}, x=${coordinates.x}, y=${coordinates.y}, error: $e');
      rethrow;
    } finally {
      await db.close();
      print('Database closed');
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is MBTilesImage &&
        other.mbtilesPath == mbtilesPath &&
        other.coordinates == coordinates;
  }

  @override
  int get hashCode => Object.hash(mbtilesPath, coordinates);
}

// // Automatic FlutterFlow imports
// import '/backend/schema/structs/index.dart';
// import '/backend/supabase/supabase.dart';
// import '/backend/sqlite/sqlite_manager.dart';
// import '/actions/actions.dart' as action_blocks;
// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '/custom_code/widgets/index.dart'; // Imports other custom widgets
// import '/custom_code/actions/index.dart'; // Imports custom actions
// import '/flutter_flow/custom_functions.dart'; // Imports custom functions
// import 'package:flutter/material.dart';
// // Begin custom widget code
// // DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
// import 'dart:io';

// class MBTilesMapView extends StatefulWidget {
//   const MBTilesMapView({Key? key, this.width, this.height, this.accessToken})
//       : super(key: key);

//   final double? width;
//   final double? height;
//   final String? accessToken;

//   @override
//   State<MBTilesMapView> createState() => _MBTilesMapViewState();
// }

// class _MBTilesMapViewState extends State<MBTilesMapView> {
//   String? selectedFilePath;
//   LatLngBounds? mapBounds;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: widget.width,
//       height: widget.height,
//       child: Column(
//         children: [
//           ElevatedButton(
//             onPressed: _pickFile,
//             child: Text('Select .mbtiles file'),
//           ),
//           Expanded(
//             child: selectedFilePath != null
//                 ? FlutterMap(
//                     options: MapOptions(
//                       bounds: mapBounds,
//                       boundsOptions:
//                           FitBoundsOptions(padding: EdgeInsets.all(8.0)),
//                     ),
//                     children: [
//                       TileLayer(
//                         urlTemplate:
//                             'file://${selectedFilePath}/{z}/{x}/{y}.png',
//                         tileProvider: MBTilesTileProvider(selectedFilePath!),
//                       ),
//                     ],
//                   )
//                 : Center(child: Text('No file selected')),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['mbtiles'],
//     );

//     if (result != null) {
//       setState(() {
//         selectedFilePath = result.files.single.path;
//       });
//       _loadMBTilesBounds();
//     }
//   }

//   Future<void> _loadMBTilesBounds() async {
//     if (selectedFilePath == null) return;

//     if (!await File(selectedFilePath!).exists()) {
//       print('MBTiles file not found: $selectedFilePath');
//       return;
//     }

//     final db = await openDatabase(selectedFilePath!);

//     try {
//       final List<Map> metadata = await db.query('metadata');
//       final boundsString = metadata
//           .firstWhere((row) => row['name'] == 'bounds')['value'] as String;
//       final bounds = boundsString.split(',').map(double.parse).toList();

//       setState(() {
//         mapBounds = LatLngBounds(
//           LatLng(bounds[1], bounds[0]),
//           LatLng(bounds[3], bounds[2]),
//         );
//       });
//     } catch (e) {
//       print('Error loading MBTiles bounds: $e');
//     } finally {
//       await db.close();
//     }
//   }
// }

// class MBTilesTileProvider extends TileProvider {
//   final String mbtilesPath;

//   MBTilesTileProvider(this.mbtilesPath);

//   @override
//   Future<Tile> getTile(int x, int y, int z) async {
//     final db = await openDatabase(mbtilesPath);
//     try {
//       final List<Map> result = await db.query(
//         'tiles',
//         columns: ['tile_data'],
//         where: 'zoom_level = ? AND tile_column = ? AND tile_row = ?',
//         whereArgs: [z, x, (1 << z) - 1 - y],
//       );

//       if (result.isNotEmpty) {
//         final tileData = result.first['tile_data'] as List<int>;
//         return Tile.byteData(x, y, z, Uint8List.fromList(tileData));
//       }
//     } catch (e) {
//       print('Error fetching tile: $e');
//     } finally {
//       await db.close();
//     }

//     return Tile.empty(x, y, z);
//   }
// }
