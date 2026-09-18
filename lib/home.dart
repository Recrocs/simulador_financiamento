import 'package:flutter/material.dart';
import 'models/financiamento.dart';
import 'services/storage_service.dart';
import 'simulacao.dart';
import 'theme_controller.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Financiamento> financiamentos = [];

  final StorageService storageService = StorageService();

  @override
  void initState() {
    super.initState();

    carregarFinanciamentos();
  }

  Future<void> carregarFinanciamentos() async {
    List<Financiamento> lista =
        await storageService.buscarFinanciamentos();

    setState(() {
      financiamentos = lista;
    });
  }

  Future<void> abrirSimulacao() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Simulacao(),
      ),
    );

    carregarFinanciamentos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Simulador de Financiamentos',
        ),
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.account_balance,
                    size: 50,
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Simulador de Financiamentos',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(
                Icons.home,
              ),
              title: const Text(
                'Início',
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ValueListenableBuilder<bool>(
              valueListenable: temaEscuro,
              builder: (context, escuro, child) {
                return ListTile(
                  leading: Icon(
                    escuro
                        ? Icons.light_mode
                        : Icons.dark_mode,
                  ),

                  title: Text(
                    escuro
                        ? 'Modo claro'
                        : 'Modo escuro',
                  ),

                  onTap: () {
                    trocarTema();

                    Navigator.pop(context);
                  },
                );
              },
            ),

            ListTile(
              leading: const Icon(
                Icons.calculate,
              ),
              title: const Text(
                'Nova simulação',
              ),
              onTap: () {
                Navigator.pop(context);

                abrirSimulacao();
              },
            ),
          ],
        ),
      ),

      body: financiamentos.isEmpty
          ? const Center(
              child: Text(
                'Nenhuma simulação cadastrada.',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: financiamentos.length,
              itemBuilder: (context, index) {
                Financiamento financiamento =
                    financiamentos[index];

                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(
                        Icons.calculate,
                      ),
                    ),

                    title: Text(
                      'R\$ '
                      '${financiamento.valor.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    subtitle: Text(
                      '${financiamento.parcelas} parcelas\n'
                      'Parcela: R\$ '
                      '${financiamento.valorParcela.toStringAsFixed(2)}\n'
                      'Taxa: '
                      '${financiamento.taxa.toStringAsFixed(2)}%',
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: abrirSimulacao,
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}

