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
import 'package:signature/signature.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class CustomSignature extends StatefulWidget {
  //
  const CustomSignature({
    Key? key,
    this.width,
    this.height,
    required this.taskId,
    this.signatureFor,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String taskId;
  final String? signatureFor;

  @override
  State<CustomSignature> createState() => _CustomSignatureState();
}

class _CustomSignatureState extends State<CustomSignature>
    with AutomaticKeepAliveClientMixin {
  late SignatureController _controller;
  Uint8List? _signatureData;
  final ImagePicker _picker = ImagePicker();
  String _statusMessage = '';
  bool _isLoading = false;
  bool _isDisposed = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    debugPrint('CustomSignature: initState called');
    _controller = SignatureController(
      penStrokeWidth: 2,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadExistingSignature();
      }
    });
  }

  void setStateIfMounted(VoidCallback fn) {
    if (mounted && !_isDisposed) setState(fn);
  }

  Future<void> _loadExistingSignature() async {
    debugPrint('CustomSignature: Loading existing signature');
    if (_isDisposed) return;
    setStateIfMounted(() => _isLoading = true);
    try {
      List<SelectPpirFormsRow> ppirForms =
          await SQLiteManager.instance.selectPpirForms(
        taskId: widget.taskId,
      );

      if (_isDisposed) return;

      if (ppirForms.isNotEmpty) {
        String? signatureBlob = widget.signatureFor == 'insured'
            ? ppirForms.first.ppirSigInsured
            : ppirForms.first.ppirSigIuia;

        if (signatureBlob != null && signatureBlob.isNotEmpty) {
          try {
            final decodedData = base64.decode(signatureBlob);
            if (decodedData.isNotEmpty) {
              // Validate the image data
              await precacheImage(MemoryImage(decodedData), context);
              setStateIfMounted(() {
                _signatureData = decodedData;
                _statusMessage = 'Existing signature loaded';
              });
            } else {
              throw Exception('Decoded signature data is empty');
            }
          } catch (e) {
            debugPrint('Error decoding or validating signature data: $e');
            setStateIfMounted(() {
              _signatureData = null;
              _statusMessage =
                  'Failed to load existing signature: invalid data';
            });
          }
        } else {
          setStateIfMounted(() {
            _signatureData = null;
            _statusMessage = 'No existing signature found';
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading existing signature: $e');
      setStateIfMounted(() {
        _signatureData = null;
        _statusMessage = 'Failed to load existing signature: ${e.toString()}';
      });
    } finally {
      setStateIfMounted(() => _isLoading = false);
    }
  }

  Future<void> _saveSignatureToDatabase(String base64Signature) async {
    debugPrint('CustomSignature: Saving signature to database');
    if (_isDisposed) return;
    try {
      // Update SQLite
      if (widget.signatureFor == 'insured') {
        await SQLiteManager.instance.updatePPIRFormINSUREDSignatureBlob(
          taskId: widget.taskId,
          signatureBlob: base64Signature,
        );
      } else {
        await SQLiteManager.instance.updatePPIRFormIUIASignatureBlob(
          taskId: widget.taskId,
          signatureBlob: base64Signature,
        );
      }

      // Update Supabase if online
      if (FFAppState().ONLINE) {
        await PpirFormsTable().update(
          data: {
            widget.signatureFor == 'insured'
                ? 'ppir_sig_insured'
                : 'ppir_sig_iuia': base64Signature,
            'updated_at': DateTime.now().toIso8601String(),
            'is_dirty': false,
          },
          matchingRows: (rows) => rows.eq(
            'task_id',
            widget.taskId,
          ),
        );
      }

      setStateIfMounted(() {
        _signatureData = base64.decode(base64Signature);
        _statusMessage = 'Signature saved successfully';
      });
    } catch (e) {
      debugPrint('Error saving signature: $e');
      setStateIfMounted(() {
        _statusMessage = 'Failed to save signature: ${e.toString()}';
      });
    }
  }

  Future<void> _clearSignature() async {
    debugPrint('CustomSignature: Clearing signature');
    if (_isDisposed) return;
    _controller.clear();
    setStateIfMounted(() {
      _signatureData = null;
      _statusMessage = 'Signature cleared';
    });

    _controller = SignatureController(
      penStrokeWidth: 2,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );

    try {
      // Clear SQLite
      if (widget.signatureFor == 'insured') {
        await SQLiteManager.instance.updatePPIRFormINSUREDSignatureBlob(
          taskId: widget.taskId,
          signatureBlob: null,
        );
      } else {
        await SQLiteManager.instance.updatePPIRFormIUIASignatureBlob(
          taskId: widget.taskId,
          signatureBlob: null,
        );
      }

      // Clear Supabase if online
      if (FFAppState().ONLINE) {
        await PpirFormsTable().update(
          data: {
            widget.signatureFor == 'insured'
                ? 'ppir_sig_insured'
                : 'ppir_sig_iuia': null,
            'updated_at': DateTime.now().toIso8601String(),
            'is_dirty': false,
          },
          matchingRows: (rows) => rows.eq(
            'task_id',
            widget.taskId,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error clearing signature: $e');
      setStateIfMounted(() {
        _statusMessage =
            'Failed to clear signature from database: ${e.toString()}';
      });
    }
  }

  Future<void> _pickImageAndConvertToBase64() async {
    debugPrint('CustomSignature: Picking image');
    if (_isDisposed) return;
    setStateIfMounted(() => _isLoading = true);
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) {
        debugPrint('No image selected');
        return;
      }

      final Uint8List imageBytes = await image.readAsBytes();
      if (imageBytes.isEmpty) {
        throw Exception('Selected image is empty');
      }

      final String base64String = base64.encode(imageBytes);

      if (_isDisposed) return;
      setStateIfMounted(() {
        _signatureData = imageBytes;
        _statusMessage = 'Signature image uploaded';
      });

      await _saveSignatureToDatabase(base64String);
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (!_isDisposed) {
        setStateIfMounted(() {
          _statusMessage = 'Failed to pick image: ${e.toString()}';
        });
      }
    } finally {
      if (!_isDisposed) {
        setStateIfMounted(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Container(
          height: 350,
          width: widget.width ?? double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (_isLoading)
                  Center(child: CircularProgressIndicator())
                else if (_signatureData != null && _signatureData!.isNotEmpty)
                  Image.memory(
                    _signatureData!,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      debugPrint('Error loading signature image: $error');
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setStateIfMounted(() {
                          _signatureData = null;
                          _statusMessage =
                              'Failed to load signature: invalid data';
                        });
                      });
                      return Center(child: Text('Failed to load signature'));
                    },
                  )
                else
                  Signature(
                    controller: _controller,
                    backgroundColor: Colors.white,
                    width: double.infinity,
                    height: double.infinity,
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: _isLoading ? null : _clearSignature,
              child: const Text('Clear'),
            ),
            // ElevatedButton(
            //   onPressed: _isLoading ? null : _pickImageAndConvertToBase64,
            //   child: const Text('Upload Signature'),
            // ),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () async {
                      if (_controller.isNotEmpty) {
                        setStateIfMounted(() => _isLoading = true);
                        try {
                          final Uint8List? data =
                              await _controller.toPngBytes();
                          if (data != null && !_isDisposed) {
                            final String base64String = base64.encode(data);
                            await _saveSignatureToDatabase(base64String);
                            setStateIfMounted(() {
                              _signatureData = data;
                              _statusMessage = 'Drawn signature saved';
                            });
                          }
                        } catch (e) {
                          debugPrint('Error saving drawn signature: $e');
                          setStateIfMounted(() {
                            _statusMessage =
                                'Failed to save drawn signature: ${e.toString()}';
                          });
                        } finally {
                          setStateIfMounted(() => _isLoading = false);
                        }
                      } else {
                        setStateIfMounted(() {
                          _statusMessage =
                              'Please draw a signature before saving';
                        });
                      }
                    },
              child: const Text('Save Drawn Signature'),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    debugPrint('CustomSignature: dispose called');
    _isDisposed = true;
    _controller.dispose();
    super.dispose();
  }
}

//--------------OLD CODE WITH BUG INVALID IMAGE DATA ---------------//
// import 'dart:convert';
// import 'package:signature/signature.dart';
// import 'dart:typed_data';
// import 'package:image_picker/image_picker.dart';
// // import '/backend/supabase/database/tables/ppir_forms.dart';

// class CustomSignature extends StatefulWidget {
//   const CustomSignature({
//     Key? key,
//     this.width,
//     this.height,
//     required this.taskId,
//     this.signatureFor,
//   }) : super(key: key);

//   final double? width;
//   final double? height;
//   final String taskId;
//   final String? signatureFor;

//   @override
//   State<CustomSignature> createState() => _CustomSignatureState();
// }

// class _CustomSignatureState extends State<CustomSignature>
//     with AutomaticKeepAliveClientMixin {
//   late SignatureController _controller;
//   Uint8List? _signatureData;
//   final ImagePicker _picker = ImagePicker();
//   String _statusMessage = '';
//   bool _isLoading = false;
//   bool _isDisposed = false;

//   @override
//   bool get wantKeepAlive => true;

//   @override
//   void initState() {
//     super.initState();
//     debugPrint('CustomSignature: initState called');
//     _controller = SignatureController(
//       penStrokeWidth: 2,
//       penColor: Colors.black,
//       exportBackgroundColor: Colors.white,
//     );
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {
//         _loadExistingSignature();
//       }
//     });
//   }

//   void setStateIfMounted(VoidCallback fn) {
//     if (mounted && !_isDisposed) setState(fn);
//   }

//   Future<void> _loadExistingSignature() async {
//     debugPrint('CustomSignature: Loading existing signature');
//     if (_isDisposed) return;
//     setStateIfMounted(() => _isLoading = true);
//     try {
//       List<SelectPpirFormsRow> ppirForms =
//           await SQLiteManager.instance.selectPpirForms(
//         taskId: widget.taskId,
//       );

//       if (ppirForms.isNotEmpty) {
//         String? signatureBlob = widget.signatureFor == 'insured'
//             ? ppirForms.first.ppirSigInsured
//             : ppirForms.first.ppirSigIuia;

//         if (signatureBlob != null) {
//           setStateIfMounted(() {
//             _signatureData = base64.decode(signatureBlob);
//             _statusMessage = 'Existing signature loaded';
//           });
//         }
//       }
//     } catch (e) {
//       debugPrint('Error loading existing signature: $e');
//       setStateIfMounted(() {
//         _statusMessage = 'Failed to load existing signature: ${e.toString()}';
//       });
//     } finally {
//       setStateIfMounted(() => _isLoading = false);
//     }
//   }

//   Future<void> _saveSignatureToDatabase(String base64Signature) async {
//     debugPrint('CustomSignature: Saving signature to database');
//     if (_isDisposed) return;
//     try {
//       // Update SQLite
//       if (widget.signatureFor == 'insured') {
//         await SQLiteManager.instance.updatePPIRFormINSUREDSignatureBlob(
//           taskId: widget.taskId,
//           signatureBlob: base64Signature,
//         );
//       } else {
//         await SQLiteManager.instance.updatePPIRFormIUIASignatureBlob(
//           taskId: widget.taskId,
//           signatureBlob: base64Signature,
//         );
//       }

//       // Update Supabase if online
//       if (FFAppState().ONLINE) {
//         await PpirFormsTable().update(
//           data: {
//             widget.signatureFor == 'insured'
//                 ? 'ppir_sig_insured'
//                 : 'ppir_sig_iuia': base64Signature,
//             'updated_at': DateTime.now().toIso8601String(),
//             'is_dirty': false,
//           },
//           matchingRows: (rows) => rows.eq(
//             'task_id',
//             widget.taskId,
//           ),
//         );
//       }

//       setStateIfMounted(() {
//         _statusMessage = 'Signature saved successfully';
//       });
//     } catch (e) {
//       debugPrint('Error saving signature: $e');
//       setStateIfMounted(() {
//         _statusMessage = 'Failed to save signature: ${e.toString()}';
//       });
//     }
//   }

//   Future<void> _clearSignature() async {
//     debugPrint('CustomSignature: Clearing signature');
//     if (_isDisposed) return;
//     _controller.clear();
//     setStateIfMounted(() {
//       _signatureData = null;
//       _statusMessage = 'Signature cleared';
//     });

//     try {
//       // Clear SQLite
//       if (widget.signatureFor == 'insured') {
//         await SQLiteManager.instance.updatePPIRFormINSUREDSignatureBlob(
//           taskId: widget.taskId,
//           signatureBlob: null,
//         );
//       } else {
//         await SQLiteManager.instance.updatePPIRFormIUIASignatureBlob(
//           taskId: widget.taskId,
//           signatureBlob: null,
//         );
//       }

//       // Clear Supabase if online
//       if (FFAppState().ONLINE) {
//         await PpirFormsTable().update(
//           data: {
//             widget.signatureFor == 'insured'
//                 ? 'ppir_sig_insured'
//                 : 'ppir_sig_iuia': null,
//             'updated_at': DateTime.now().toIso8601String(),
//             'is_dirty': false,
//           },
//           matchingRows: (rows) => rows.eq(
//             'task_id',
//             widget.taskId,
//           ),
//         );
//       }
//     } catch (e) {
//       debugPrint('Error clearing signature: $e');
//       setStateIfMounted(() {
//         _statusMessage =
//             'Failed to clear signature from database: ${e.toString()}';
//       });
//     }
//   }

//   Future<void> _pickImageAndConvertToBase64() async {
//     debugPrint('CustomSignature: Picking image');
//     if (_isDisposed) return;
//     setStateIfMounted(() => _isLoading = true);
//     try {
//       final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//       if (image == null) {
//         debugPrint('No image selected');
//         return;
//       }

//       final Uint8List imageBytes = await image.readAsBytes();
//       final String base64String = base64.encode(imageBytes);

//       if (_isDisposed) return;
//       setStateIfMounted(() {
//         _signatureData = imageBytes;
//         _statusMessage = 'Signature image uploaded';
//       });

//       await _saveSignatureToDatabase(base64String);
//     } catch (e) {
//       debugPrint('Error picking image: $e');
//       setStateIfMounted(() {
//         _statusMessage = 'Failed to pick image: ${e.toString()}';
//       });
//     } finally {
//       setStateIfMounted(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return Column(
//       children: [
//         Container(
//           height: 230,
//           width: widget.width ?? double.infinity,
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(8),
//             child: Stack(
//               fit: StackFit.expand,
//               children: [
//                 if (_isLoading)
//                   Center(child: CircularProgressIndicator())
//                 else if (_signatureData != null)
//                   Image.memory(
//                     _signatureData!,
//                     fit: BoxFit.cover,
//                     width: double.infinity,
//                     height: double.infinity,
//                   )
//                 else
//                   Signature(
//                     controller: _controller,
//                     backgroundColor: Colors.white,
//                     width: double.infinity,
//                     height: double.infinity,
//                   ),
//                 Positioned(
//                   bottom: 0,
//                   left: 0,
//                   right: 0,
//                   child: Container(
//                     color: Colors.black.withOpacity(0.5),
//                     padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                     child: Text(
//                       _statusMessage,
//                       style: TextStyle(color: Colors.white),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(height: 20),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             ElevatedButton(
//               onPressed: _isLoading ? null : _clearSignature,
//               child: const Text('Clear'),
//             ),
//             ElevatedButton(
//               onPressed: _isLoading ? null : _pickImageAndConvertToBase64,
//               child: const Text('Upload Signature'),
//             ),
//             ElevatedButton(
//               onPressed: _isLoading
//                   ? null
//                   : () async {
//                       if (_controller.isNotEmpty) {
//                         setStateIfMounted(() => _isLoading = true);
//                         try {
//                           final Uint8List? data =
//                               await _controller.toPngBytes();
//                           if (data != null && !_isDisposed) {
//                             final String base64String = base64.encode(data);
//                             await _saveSignatureToDatabase(base64String);
//                             setStateIfMounted(() {
//                               _signatureData = data;
//                               _statusMessage = 'Drawn signature saved';
//                             });
//                           }
//                         } catch (e) {
//                           debugPrint('Error saving drawn signature: $e');
//                           setStateIfMounted(() {
//                             _statusMessage =
//                                 'Failed to save drawn signature: ${e.toString()}';
//                           });
//                         } finally {
//                           setStateIfMounted(() => _isLoading = false);
//                         }
//                       } else {
//                         setStateIfMounted(() {
//                           _statusMessage =
//                               'Please draw a signature before saving';
//                         });
//                       }
//                     },
//               child: const Text('Save Drawn Signature'),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   @override
//   void dispose() {
//     debugPrint('CustomSignature: dispose called');
//     _isDisposed = true;
//     _controller.dispose();
//     super.dispose();
//   }
// }
