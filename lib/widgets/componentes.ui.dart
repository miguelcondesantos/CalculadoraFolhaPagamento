import 'package:flutter/material.dart';
import '../utils/formatadores.dart';

// Títulos das seções (Entradas, Menus, etc)
class SectionHeader extends StatelessWidget {
  final String title;
  final Color color;

  const SectionHeader({super.key, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}

// Campo de entrada de texto customizado
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
        onChanged: onChanged,
      ),
    );
  }
}

// Menu Dropdown customizado
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
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }
}

// Linha do Resumo Final
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