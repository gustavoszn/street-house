import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/background_widget.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final telController = TextEditingController();
  final cpfController = TextEditingController();
  final enderecoController = TextEditingController();
  final nascimentoController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  bool isLoading = false;
  bool captcha = false;

  void cadastrar() async {
    if (_formKey.currentState?.validate() ?? false && captcha) {
      setState(() => isLoading = true);
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro realizado com sucesso!', style: TextStyle(color: Colors.white))),
      );
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 10))],
                ),
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Image.asset('lib/assets/logo.png', width: 120, semanticLabel: 'Street House — logo'),
                      const SizedBox(height: 16),
                      Text("Cadastro", style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: nomeController,
                        decoration: InputDecoration(
                          labelText: 'Nome completo *',
                          labelStyle: GoogleFonts.inter(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                        style: GoogleFonts.inter(),
                        validator: (v) => v == null || v.isEmpty ? 'Campo obrigatório' : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: telController,
                        decoration: InputDecoration(
                          labelText: 'Telefone *',
                          labelStyle: GoogleFonts.inter(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                        style: GoogleFonts.inter(),
                        keyboardType: TextInputType.phone,
                        validator: (v) => v == null || v.isEmpty ? 'Campo obrigatório' : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: cpfController,
                        decoration: InputDecoration(
                          labelText: 'CPF *',
                          labelStyle: GoogleFonts.inter(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                        style: GoogleFonts.inter(),
                        keyboardType: TextInputType.number,
                        validator: (v) => v == null || v.isEmpty ? 'Campo obrigatório' : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: enderecoController,
                        decoration: InputDecoration(
                          labelText: 'Endereço',
                          labelStyle: GoogleFonts.inter(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                        style: GoogleFonts.inter(),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: nascimentoController,
                        decoration: InputDecoration(
                          labelText: 'Data de nascimento',
                          labelStyle: GoogleFonts.inter(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        style: GoogleFonts.inter(),
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2000),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            nascimentoController.text = '${picked.day}/${picked.month}/${picked.year}';
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'E-mail *',
                          labelStyle: GoogleFonts.inter(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                        style: GoogleFonts.inter(),
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) => v == null || v.isEmpty ? 'Campo obrigatório' : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: senhaController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Senha *',
                          labelStyle: GoogleFonts.inter(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                        style: GoogleFonts.inter(),
                        validator: (v) => v == null || v.length < 6 ? 'Mínimo 6 caracteres' : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Checkbox(
                            value: captcha,
                            onChanged: (v) => setState(() => captcha = v ?? false),
                          ),
                          Text("Não sou um robô", style: GoogleFonts.inter()),
                        ],
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                          elevation: 4,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700),
                        ),
                        onPressed: isLoading ? null : cadastrar,
                        child: isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : Text('Concluído', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(height: 10),
                      Text("Seus dados estão protegidos e não serão compartilhados.", style: GoogleFonts.inter(fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}