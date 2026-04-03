import 'package:flutter/material.dart';
import '../utils/formatadores.dart';

// -------------------------------
// SECTION HEADER
// -------------------------------
class SectionHeader extends StatelessWidget {
  final String title;
  final Color color;

  const SectionHeader({
    super.key,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

// -------------------------------
// INPUT CUSTOM
// -------------------------------
class InputTrabalhista extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isMoney;
  final bool decimalShift;
  final Function(String) onChanged;

  const InputTrabalhista({
    super.key,
    required this.label,
    required this.controller,
    this.isMoney = false,
    this.decimalShift = false,
    required this.onChanged,
  });

  void _handleChange(String value) {
    String novoTexto = value;

    if (isMoney) {
      novoTexto = formatarEntradaFinanceira(value);
    } else if (decimalShift) {
      novoTexto = formatarEntradaDecimal(value);
    }

    // evita loop infinito
    if (controller.text != novoTexto) {
      controller.value = TextEditingValue(
        text: novoTexto,
        selection: TextSelection.collapsed(offset: novoTexto.length),
      );
    }

    onChanged(novoTexto);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          prefixText: isMoney ? "R\$ " : null,
          border: const OutlineInputBorder(),
        ),
        onChanged: _handleChange,
      ),
    );
  }
}

// -------------------------------
// DROPDOWN
// -------------------------------
class DropdownTrabalhista extends StatelessWidget {
  final String label;
  final List<String> items;
  final String value;
  final Function(String?) onChanged;

  const DropdownTrabalhista({
    super.key,
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

// -------------------------------
// RESUMO LINE
// -------------------------------
class ResumoLine extends StatelessWidget {
  final String label;
  final double valor;
  final Color cor;
  final bool bold;

  const ResumoLine({
    super.key,
    required this.label,
    required this.valor,
    required this.cor,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: cor,
            ),
          ),
          Text(
            formatCurrency(valor),
            style: TextStyle(
              fontSize: 16,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: cor,
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------
// BOX DE RESUMO (REUTILIZÁVEL)
// -------------------------------
class ResumoBox extends StatelessWidget {
  final List<Widget> children;

  const ResumoBox({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blueGrey.shade200),
      ),
      child: Column(children: children),
    );
  }
}