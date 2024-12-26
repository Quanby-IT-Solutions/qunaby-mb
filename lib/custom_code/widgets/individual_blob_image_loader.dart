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

import 'dart:convert';
import 'dart:typed_data';

class IndividualBlobImageLoader extends StatefulWidget {
  const IndividualBlobImageLoader({
    Key? key,
    this.width,
    this.height,
    this.imageBlob,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String? imageBlob;

  @override
  State<IndividualBlobImageLoader> createState() =>
      _IndividualBlobImageLoaderState();
}

class _IndividualBlobImageLoaderState extends State<IndividualBlobImageLoader> {
  Uint8List? _decodedImageData;
  String? _message;

  @override
  void initState() {
    super.initState();
    _decodeImage();
  }

  @override
  void didUpdateWidget(IndividualBlobImageLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageBlob != oldWidget.imageBlob) {
      _decodeImage();
    }
  }

  void _decodeImage() {
    setState(() {
      _decodedImageData = null;
      _message = null;
    });

    if (widget.imageBlob == null ||
        widget.imageBlob!.isEmpty ||
        widget.imageBlob!.toLowerCase() == 'no value') {
      setState(() {
        _message = 'No image';
      });
      return;
    }

    try {
      final decodedData = base64.decode(widget.imageBlob!);
      if (decodedData.isEmpty) {
        setState(() {
          _message = 'No image';
        });
      } else {
        setState(() {
          _decodedImageData = decodedData;
        });
      }
    } catch (e) {
      print('Error decoding image: $e');
      setState(() {
        _message = 'No image';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? 230,
      width: widget.width ?? double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (_message != null) {
      return Center(child: Text(_message!));
    }

    if (_decodedImageData != null) {
      return Image.memory(
        _decodedImageData!,
        fit: BoxFit.contain,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          print('Error displaying image: $error');
          return const Center(child: Text('No image'));
        },
      );
    }

    return const Center(child: CircularProgressIndicator());
  }
}
