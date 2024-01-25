
import 'package:flutter/material.dart';


class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
        child:Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        )
    );
  }
}

