import 'package:flutter/material.dart';

// Define un enum con los tipos de tarjetas
enum CardType { error, warning, info, success,load }

// Define un mapa para los colores asociados a cada tipo de tarjeta
const Map<CardType, Color> _cardColor = {
  CardType.error: Colors.red,
  CardType.warning: Colors.orange,
  CardType.info: Colors.blue,
  CardType.success: Colors.green,
  CardType.load:Colors.cyan
};

// Define un mapa para los iconos asociados a cada tipo de tarjeta
const Map<CardType, IconData> _cardIcon = {
  CardType.error: Icons.error_outline,
  CardType.warning: Icons.warning_amber_outlined,
  CardType.info: Icons.info_outline,
  CardType.success: Icons.check_circle_outline,
  CardType.load: Icons.connecting_airports,
};

// Crea un widget personalizado para tu tarjeta
class StarlinkCard extends StatelessWidget {
  final CardType type;
  final String title;
  final String message;

  const StarlinkCard({
    Key? key,
    required this.type,
    required this.title,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        color: _cardColor[type],
        child: ListTile(
          leading: Icon(
            _cardIcon[type],
            color: Colors.white,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
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
    );
  }
}
