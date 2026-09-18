import 'package:flutter/material.dart';

ValueNotifier<bool> temaEscuro = ValueNotifier(false);

void trocarTema() {
  temaEscuro.value = !temaEscuro.value;
}
