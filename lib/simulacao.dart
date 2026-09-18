import 'package:flutter/material.dart';
import 'models/financiamento.dart';
import 'services/bcb_service.dart';
import 'services/storage_service.dart';

class Simulacao extends StatefulWidget {
  const Simulacao({super.key});

  @override
  State<Simulacao> createState() => _SimulacaoState();
}

class _SimulacaoState extends State<Simulacao> {
  final valorController = TextEditingController();
  final parcelasController = TextEditingController();

  final BcbService bcbService = BcbService();
  final StorageService storageService = StorageService();

  double? taxa;
  double? montante;
  double? valorParcela;

  bool carregando = false;

  Future<void> calcular() async {
    if (valorController.text.isEmpty ||
        parcelasController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Preencha o valor e o número de parcelas.',
          ),
        ),
      );

      return;
    }

    double? valor = double.tryParse(
      valorController.text.replaceAll(',', '.'),
    );

    int? parcelas = int.tryParse(
      parcelasController.text,
    );

    if (valor == null || parcelas == null || parcelas <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Digite valores válidos.',
          ),
        ),
      );

      return;
    }

    setState(() {
      carregando = true;
    });

    double? taxaApi = await bcbService.buscarTaxa();

    if (taxaApi == null) {
      setState(() {
        carregando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não foi possível consultar a taxa.',
          ),
        ),
      );

      return;
    }

    double taxaMensal = taxaApi / 100;

    double resultadoMontante =
        valor * (1 + taxaMensal * parcelas);

    double resultadoParcela =
        resultadoMontante / parcelas;

    setState(() {
      taxa = taxaApi;
      montante = resultadoMontante;
      valorParcela = resultadoParcela;
      carregando = false;
    });
  }

  Future<void> salvar() async {
    if (taxa == null ||
        montante == null ||
        valorParcela == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Faça a simulação antes de salvar.',
          ),
        ),
      );

      return;
    }

    double valor = double.parse(
      valorController.text.replaceAll(',', '.'),
    );

    int parcelas = int.parse(
      parcelasController.text,
    );

    Financiamento financiamento = Financiamento(
      valor: valor,
      parcelas: parcelas,
      taxa: taxa!,
      montante: montante!,
      valorParcela: valorParcela!,
    );

    await storageService.salvarFinanciamento(
      financiamento,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Simulação salva com sucesso!',
          ),
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    valorController.dispose();
    parcelasController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nova Simulação',
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch,

          children: [
            TextField(
              controller: valorController,
              keyboardType:
                  const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Valor desejado',
                prefixText: 'R\$ ',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: parcelasController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Número de parcelas',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: carregando ? null : calcular,
              icon: const Icon(Icons.calculate),
              label: const Text(
                'Calcular financiamento',
              ),
            ),

            const SizedBox(height: 25),

            if (carregando)
              const Center(
                child: CircularProgressIndicator(),
              ),

            if (taxa != null) ...[
              const Text(
                'Resultado da simulação',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Taxa mensal: '
                        '${taxa!.toStringAsFixed(2)}%',
                      ),

                      const SizedBox(height: 10),

                      Text(
                        'Montante: R\$ '
                        '${montante!.toStringAsFixed(2)}',
                      ),

                      const SizedBox(height: 10),

                      Text(
                        'Valor da parcela: R\$ '
                        '${valorParcela!.toStringAsFixed(2)}',
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: salvar,
                icon: const Icon(Icons.save),
                label: const Text(
                  'Salvar simulação',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}