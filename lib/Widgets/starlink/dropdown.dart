import 'package:flutter/material.dart';

import 'colors.dart';

class StarlinkDropdown extends StatelessWidget {
  final void Function(String?) onChanged;
  final List<String> values;
  final String? initialValue;

  const StarlinkDropdown({
    Key? key,
    required this.onChanged,
    required this.values,
    this.initialValue, // Parámetro adicional para el valor inicial
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? selectedValue = initialValue ??
        values
            .first; // Usa el valor inicial si está proporcionado, si no, el primer elemento de la lista
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.all(9),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: StarlinkColors.gray, // Color de fondo del dropdown
          borderRadius: BorderRadius.circular(5), // Bordes redondeados
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            dropdownColor: StarlinkColors.gray,
            // Color de fondo de la lista desplegable
            value: selectedValue,
            // Valor actual seleccionado
            icon: Icon(Icons.arrow_drop_down, color: StarlinkColors.white),
            // Icono del dropdown
            onChanged: (String? newValue) {
              onChanged(newValue);
            },
            items: values.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: SizedBox(
                  width: MediaQuery.of(context).size.height*.28,
                  child: Text(
                    value,
                    overflow: TextOverflow.fade,
                    style: const TextStyle(
                      color: StarlinkColors.white,
                      fontFamily: 'DDIN-Bold',
                    ), // Estilo de texto de los items
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
