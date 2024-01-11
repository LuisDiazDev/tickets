import 'package:flutter/material.dart';

class ScanQRButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ScanQRButton({super.key, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Activar ticket virtual",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        // divider
        const SizedBox(height: 10.0),
        Column(
          children: [
            Container(
              width: 100.0, // Tamaño del botón
              height: 100.0,
              decoration: BoxDecoration(
                color: Colors.cyan, // Color de fondo del botón
                shape: BoxShape.rectangle, // Forma del botón
                borderRadius: BorderRadius.circular(10), // Radio del borde
              ), // Tamaño del botón
              child: IconButton(
                icon: const Icon(Icons.qr_code_scanner), // Icono de escaneo QR
                iconSize: 70.0, // Tamaño del icono
                onPressed: onPressed, // Usa la función proporcionada en el constructor
              ),
            ),
          ],
        ),
      ],
    );
  }
}
