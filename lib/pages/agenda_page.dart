import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/background.dart';
import '../widgets/logo.dart';

// Simulação de API (substitua por fetch real)
Future<List<Map<String, dynamic>>> fetchShows() async {
  await Future.delayed(const Duration(milliseconds: 600));
  return [
    {
      'id': 1,
      'data': DateTime.now().add(const Duration(days: 3)),
      'titulo': 'Show de Talentos',
      'local': 'Barueri',
      'descricao': 'Banda RockWave, 21h'
    },
    {
      'id': 2,
      'data': DateTime.now().add(const Duration(days: 8)),
      'titulo': 'Festival Street',
      'local': 'São Paulo',
      'descricao': 'Banda Street, 16h'
    },
  ];
}

Future<void> salvarShow(Map<String, dynamic> novoShow) async {
  await Future.delayed(const Duration(milliseconds: 600));
}

class AgendaPage extends StatefulWidget {
  const AgendaPage({Key? key}) : super(key: key);

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  late Future<List<Map<String, dynamic>>> _showsFuture;

  @override
  void initState() {
    super.initState();
    _showsFuture = fetchShows();
  }

  void _abrirNovoShowDialog() async {
    final resultado = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => _NovoShowDialog(),
    );
    if (resultado != null) {
      await salvarShow(resultado);
      setState(() {
        _showsFuture = fetchShows();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Show agendado com sucesso!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 18),
              const StreetLogo(height: 65, white: false),
              const SizedBox(height: 12),
              Text(
                "Agenda de Shows",
                style: TextStyle(
                  color: Colors.purple[800],
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _showsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final shows = snapshot.data ?? [];
                    if (shows.isEmpty) {
                      return const Center(child: Text("Nenhum show agendado ainda."));
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      itemBuilder: (ctx, i) {
                        final show = shows[i];
                        return Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          elevation: 3,
                          margin: EdgeInsets.zero,
                          child: ListTile(
                            title: Text(
                              show['titulo'],
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF8C27F7)),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Data: ${DateFormat('dd/MM/y').format(show['data'])}",
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text("Local: ${show['local']}"),
                                Text("Descrição: ${show['descricao']}"),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit, color: Colors.purple),
                              onPressed: () {
                                // Poderia abrir um modal de edição
                              },
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (ctx, i) => const SizedBox(height: 13),
                      itemCount: shows.length,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 22, top: 12),
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[700],
                      foregroundColor: Colors.white,
                      elevation: 4,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text("Agendar Show", style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: _abrirNovoShowDialog,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NovoShowDialog extends StatefulWidget {
  @override
  State<_NovoShowDialog> createState() => _NovoShowDialogState();
}

class _NovoShowDialogState extends State<_NovoShowDialog> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _dataSelecionada;
  final _tituloController = TextEditingController();
  final _localController = TextEditingController();
  final _descricaoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Novo Show",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: "Título do show"),
                validator: (v) => v!.trim().isEmpty ? "Campo obrigatório" : null,
              ),
              const SizedBox(height: 13),
              TextFormField(
                controller: _localController,
                decoration: const InputDecoration(labelText: "Local"),
                validator: (v) => v!.trim().isEmpty ? "Campo obrigatório" : null,
              ),
              const SizedBox(height: 13),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: "Descrição (opcional)"),
              ),
              const SizedBox(height: 13),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _dataSelecionada == null
                          ? "Selecione a data"
                          : "Data: ${DateFormat('dd/MM/y').format(_dataSelecionada!)}",
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today, color: Colors.purple),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(const Duration(days: 1)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setState(() => _dataSelecionada = picked);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 12),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate() && _dataSelecionada != null) {
                    Navigator.pop(context, {
                      'titulo': _tituloController.text.trim(),
                      'local': _localController.text.trim(),
                      'descricao': _descricaoController.text.trim(),
                      'data': _dataSelecionada,
                    });
                  }
                },
                child: const Text("Salvar Show", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}