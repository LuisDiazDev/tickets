import 'package:flutter/material.dart';

import '../../../Widgets/starlink/colors.dart';
import '../../../Widgets/starlink/section_title.dart';

class ScanVirtualTicketButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ScanVirtualTicketButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const StarlinkSectionTitle(
          title: "ACTIVAR TICKET VIRTUAL",
          alignment: Alignment.center,
        ),
        // divider
        const SizedBox(height: 10.0),
        Column(
          children: [
            Container(
              width: 100.0, // Tamaño del botón
              height: 100.0,
              decoration: BoxDecoration(
                color: StarlinkColors.midDarkGray, // Color de fondo del botón
                shape: BoxShape.rectangle, // Forma del botón
                borderRadius: BorderRadius.circular(10), // Radio del borde
              ), // Tamaño del botón
              child: IconButton(
                icon: const Icon(
                  Icons.qr_code_scanner,
                  color: StarlinkColors.white,
                ), // Icono de escaneo QR
                iconSize: 70.0, // Tamaño del icono
                onPressed:
                    onPressed, // Usa la función proporcionada en el constructor
              ),
            ),
          ],
        ),
      ],
    );
  }
}
