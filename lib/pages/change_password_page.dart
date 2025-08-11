import 'package:flutter/material.dart';
import '../widgets/logo_widget.dart';
import '../widgets/background_widget.dart';
import '../theme/design_tokens.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final passController = TextEditingController();
  final confirmController = TextEditingController();
  bool showPassword = false;
  bool isLoading = false;
  String strength = 'Fraca';
  String? errorText;

  void updateStrength(String value) {
    setState(() {
      if (value.length >= 8 && RegExp(r'[A-Z]').hasMatch(value) && RegExp(r'[0-9]').hasMatch(value)) {
        strength = 'Forte';
      } else if (value.length >= 6) {
        strength = 'Média';
      } else {
        strength = 'Fraca';
      }
    });
  }

  Future<void> save() async {
    setState(() {
      isLoading = true;
      errorText = null;
    });
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => isLoading = false);

    if (passController.text != confirmController.text) {
      setState(() => errorText = "As senhas não coincidem");
      return;
    }
    if (strength == 'Fraca') {
      setState(() => errorText = "Por favor, escolha uma senha mais forte.");
      return;
    }
    // Suponha que a alteração de senha foi bem sucedida via API.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Senha alterada com sucesso!', style: TextStyle(color: Colors.white))),
    );
    Navigator.of(context).pushReplacementNamed('/login');
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
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  boxShadow: AppShadows.card,
                ),
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LogoWidget(size: 120),
                    const SizedBox(height: 16),
                    Text("Alteração de senha:", style: AppTextStyles.h2),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: passController,
                      obscureText: !showPassword,
                      onChanged: updateStrength,
                      decoration: InputDecoration(
                        labelText: 'Digite sua senha',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.input),
                          borderSide: BorderSide(color: AppColors.lightGray),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => showPassword = !showPassword),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: confirmController,
                      obscureText: !showPassword,
                      decoration: InputDecoration(
                        labelText: 'Confirme a sua senha',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.input),
                          borderSide: BorderSide(color: AppColors.lightGray),
                        ),
                      ),
                    ),
                    if (errorText != null) ...[
                      const SizedBox(height: 8),
                      Text(errorText!, style: const TextStyle(color: Colors.red)),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: strength == 'Forte' ? 1 : (strength == 'Média' ? 0.6 : 0.3),
                            color: strength == 'Forte'
                                ? AppColors.success
                                : (strength == 'Média' ? AppColors.orange : AppColors.error),
                            backgroundColor: AppColors.lightGray,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(strength, style: AppTextStyles.caption),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orange,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                      ),
                      onPressed: isLoading ? null : save,
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Text('Salvar', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}