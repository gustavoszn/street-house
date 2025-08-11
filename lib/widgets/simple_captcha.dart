import 'package:flutter/material.dart';
import 'dart:math';

class SimpleCaptcha extends StatefulWidget {
  final ValueChanged<bool> onVerified;

  const SimpleCaptcha({Key? key, required this.onVerified}) : super(key: key);

  @override
  _SimpleCaptchaState createState() => _SimpleCaptchaState();
}

class _SimpleCaptchaState extends State<SimpleCaptcha> {
  bool _checked = false;
  bool _verified = false;
  late int _num1;
  late int _num2;
  final TextEditingController _answerController = TextEditingController();

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  void _generateQuestion() {
    final rnd = Random();
    _num1 = rnd.nextInt(10) + 1;
    _num2 = rnd.nextInt(10) + 1;
  }

  void _onCheckboxChanged(bool? value) {
    if (value == true) {
      _generateQuestion();
    } else {
      _verified = false;
      _answerController.clear();
      widget.onVerified(false);
    }
    setState(() {
      _checked = value ?? false;
    });
  }

  void _checkAnswer() {
    final userAnswer = int.tryParse(_answerController.text.trim());
    if (userAnswer != null && userAnswer == (_num1 + _num2)) {
      setState(() {
        _verified = true;
      });
      widget.onVerified(true);
    } else {
      setState(() {
        _verified = false;
      });
      widget.onVerified(false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Resposta incorreta, tente novamente.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Checkbox "Não sou um robô"
        Row(
          children: [
            Checkbox(
              value: _checked,
              onChanged: _onCheckboxChanged,
            ),
            const Text(
              'Não sou um robô',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        // Exibe o desafio somente se checkbox marcado
        if (_checked)
          Padding(
            padding: const EdgeInsets.only(left: 40, top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quanto é $_num1 + $_num2 ?',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    SizedBox(
                      width: 70,
                      child: TextField(
                        controller: _answerController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Resposta',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _checkAnswer,
                      child: const Text('Verificar'),
                    ),
                  ],
                ),
                if (_verified)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: const [
                        Icon(Icons.check_circle, color: Colors.green, size: 20),
                        SizedBox(width: 6),
                        Text(
                          'Verificado',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
