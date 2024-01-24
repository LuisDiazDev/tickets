import 'package:flutter/material.dart';

import 'colors.dart';



// Crea un widget personalizado para tu tarjeta
class StarlinkCard extends StatelessWidget {
  final InfoContextType type;
  final String title;
  final String message;

  const StarlinkCard({
    super.key,
    required this.type,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(
            color: boxDecorationColor[type]!,
            width: 2.0, // Ajusta el grosor del borde
          ),
        ),
        child: Card(
          margin: EdgeInsets.zero,
          borderOnForeground: false,
          semanticContainer: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.0), // Valor más pequeño para menos redondeo
          ),
          color: cardColor[type],
          child: ListTile(
            leading: Icon(
              cardIcon[type],
              color: boxDecorationColor[type]!,
              weight: 20.0,
            ),
            title: Text(
              title.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: textColor[type]!,
                fontFamily: 'DDIN-Bold',
              ),
            ),
            subtitle: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'DDIN',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
