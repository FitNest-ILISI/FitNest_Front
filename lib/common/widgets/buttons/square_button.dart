import 'package:fitnest/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class SquareButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final String? image; // Image optionnelle

  SquareButton({
    required this.text,
    required this.icon,
    required this.onPressed,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Prend toute la largeur possible
      height: 150,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFF8F8F8), // Fond couleur blanc cassé
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding:
              EdgeInsets.zero, // Pas de padding pour utiliser tout l'espace
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  File(image!),
                  fit: BoxFit.cover, // Remplit tout l'espace du bouton
                ),
              ),
            if (image == null)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: Colors.blue,
                    size: 20,
                  ),
                  SizedBox(height: MySizes.sm),
                  Text(
                    text,
                    style: TextStyle(color: Colors.black), // Texte en noir
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
