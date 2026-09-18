import 'package:flutter/material.dart';
import 'splash.dart';
import 'theme_controller.dart';

void main() {
  runApp(const MeuAplicativo());
}

class MeuAplicativo extends StatelessWidget {
  const MeuAplicativo({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: temaEscuro,
      builder: (context, escuro, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Simulador de Financiamentos',

          theme: ThemeData(
            brightness: Brightness.light,
            colorSchemeSeed: Colors.blue,
          ),

          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorSchemeSeed: Colors.blue,
          ),

          themeMode:
              escuro ? ThemeMode.dark : ThemeMode.light,

          home: const Splash(),
        );
      },
    );
  }
}

