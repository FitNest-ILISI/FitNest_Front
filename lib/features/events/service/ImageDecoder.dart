import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class ImageDecoder extends StatelessWidget {
  final String base64String;

  ImageDecoder({required this.base64String});

  @override
  Widget build(BuildContext context) {
    // Décodage de la chaîne en base64 en une liste d'octets
    Uint8List imageBytes = base64Decode(base64String);

    return Image.memory(imageBytes);
  }
}
