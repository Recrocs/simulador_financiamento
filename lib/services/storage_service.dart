import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/financiamento.dart';

class StorageService {
  Future<void> salvarFinanciamento(
      Financiamento financiamento) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> financiamentosSalvos =
        prefs.getStringList('financiamentos') ?? [];

    financiamentosSalvos.add(
      jsonEncode(financiamento.toMap()),
    );

    await prefs.setStringList(
      'financiamentos',
      financiamentosSalvos,
    );
  }

  Future<List<Financiamento>> buscarFinanciamentos() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> financiamentosSalvos =
        prefs.getStringList('financiamentos') ?? [];

    List<Financiamento> financiamentos = [];

    for (String financiamentoSalvo in financiamentosSalvos) {
      Map<String, dynamic> dados =
          jsonDecode(financiamentoSalvo);

      financiamentos.add(
        Financiamento.fromMap(dados),
      );
    }

    return financiamentos;
  }
}