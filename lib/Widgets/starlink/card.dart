import 'package:flutter/material.dart';

// Define un enum con los tipos de tarjetas
enum CardType { error, warning, info, success }

// Define un mapa para los colores asociados a cada tipo de tarjeta
const Map<CardType, Color> _cardColor = {
  CardType.error: Color.fromARGB(100, 120, 30, 35),
  CardType.warning: Color.fromARGB(100, 120, 90, 36),
  CardType.info: Color.fromARGB(100, 0, 60, 120),
  CardType.success: Color.fromARGB(100, 0, 120, 0),
};

const Map<CardType, Color> _cardDecorationColor = {
  CardType.error: Color.fromARGB(255, 191, 52, 61),
  CardType.warning: Color.fromARGB(200, 210, 166, 51),
  CardType.info: Color.fromARGB(200, 0, 122, 255),
  CardType.success: Color.fromARGB(150, 0, 255, 0),
};

const Map<CardType, Color> _textColor = {
  CardType.error: Color.fromARGB(255, 255, 240, 240),
  CardType.warning: Color.fromARGB(255, 255, 255, 240),
  CardType.info: Color.fromARGB(255, 245, 245, 255),
  CardType.success: Color.fromARGB(255, 240, 255, 240),
};

// Define un mapa para los iconos asociados a cada tipo de tarjeta
const Map<CardType, IconData> _cardIcon = {
  CardType.error: Icons.warning_amber_outlined,
  CardType.warning: Icons.error_outline,
  CardType.info: Icons.info_outline,
  CardType.success: Icons.check_circle_outline,
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
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(
            color: _cardDecorationColor[type]!,
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
          color: _cardColor[type],
          child: ListTile(
            leading: Icon(
              _cardIcon[type],
              color: _cardDecorationColor[type]!,
              weight: 20.0,
            ),
            title: Text(
              title.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _textColor[type]!,
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
