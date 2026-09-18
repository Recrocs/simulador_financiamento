import 'dart:convert';
import 'package:http/http.dart' as http;

class BcbService {
  Future<double?> buscarTaxa() async {
    final url = Uri.parse(
      'https://api.bcb.gov.br/dados/serie/bcdata.sgs.4391/dados?formato=json',
    );

    final resposta = await http.get(url);

    if (resposta.statusCode == 200) {
      final dados = jsonDecode(resposta.body);

      if (dados.isNotEmpty) {
        double taxa = double.parse(
          dados.last['valor'].toString(),
        );

        return taxa;
      }
    }

    return null;
  }
}