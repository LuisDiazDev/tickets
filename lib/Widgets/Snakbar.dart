import 'package:flutter/material.dart';

import '../Core/Values/Colors.dart';

class SnackBarCustom {
  static snackBarCustom(
      {required String title,
        required Function onTap,
        required String titleAction}) {
    return SnackBar(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(title),
          const Spacer(),
          ElevatedButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.zero),
            ),
            onPressed: () => onTap(),
            child: Text(titleAction),
          )
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9),
      ),
    );
  }

  static snackBarStatusCustom({
    required String title,
    required Function onTap,
    required String subtitle,
    required Function hideSnackBar,
  }) {
    return SnackBar(
      padding: EdgeInsets.zero,
      content: ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 3.5, color: ColorsApp.secondary),
            ),
          ),
          child: ListTile(
            onTap: () {
              hideSnackBar();
              onTap();
            },
            contentPadding: const EdgeInsets.all(12),
            minVerticalPadding: 0,
            title: Text(
              title,
              style: const TextStyle(color: Colors.black),
            ),
            subtitle: Text(
              subtitle,
              style: const TextStyle(
                  color: Colors.black45, fontFamily: 'SourceSansPro'),
            ),
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                const SizedBox(
                    width: 60,
                    child: Center(
                        child: Icon(
                          Icons.safety_check_rounded,
                          color: ColorsApp.alert,
                        ))),
              ],
            ),
            trailing: Column(
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9),
      ),
    );
  }
}
