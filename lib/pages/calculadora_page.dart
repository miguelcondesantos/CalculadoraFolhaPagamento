import 'package:flutter/material.dart';
import '../logic/calculadorea_logic.dart';
import '../utils/formatadores.dart';
import '../widgets/componentes.ui.dart';

class CalculadoraPage extends StatefulWidget {
  const CalculadoraPage({super.key});

  @override
  State<CalculadoraPage> createState() => _CalculadoraPageState();
}

class _CalculadoraPageState extends State<CalculadoraPage> {
  final CalculadoraLogic logic = CalculadoraLogic();

  // Controllers para capturar o texto dos inputs
  final TextEditingController _ctrlSalBase = TextEditingController(text: "0,00");
  final TextEditingController _ctrlSalMin = TextEditingController(text: "0,00");
  final TextEditingController _ctrlIncentivo = TextEditingController(text: "0,00");
  final TextEditingController _ctrlDescontosFalta = TextEditingController(text: "0,00");
  final TextEditingController _ctrlOutrosDescontos = TextEditingController(text: "0,00");
  final TextEditingController _ctrlHE50 = TextEditingController(text: "0,00");
  final TextEditingController _ctrlHE100 = TextEditingController(text: "0,00");

  void _atualizarCalculos() {
    setState(() {
      logic.salBase = parseCurrency(_ctrlSalBase.text);
      logic.salMin = parseCurrency(_ctrlSalMin.text);
      logic.incentivo = parseCurrency(_ctrlIncentivo.text);
      logic.descontosFalta = parseCurrency(_ctrlDescontosFalta.text);
      logic.outrosDescontos = parseCurrency(_ctrlOutrosDescontos.text);
      
      // Lógica simplificada para HE (pode ser expandida conforme a necessidade do seu pai)
      logic.he50ValorInput = logic.tipoHE50 == "Valor" 
          ? parseCurrency(_ctrlHE50.text) 
          : double.tryParse(_ctrlHE50.text.replaceAll(',', '.')) ?? 0;
          
      logic.he100ValorInput = logic.tipoHE100 == "Valor" 
          ? parseCurrency(_ctrlHE100.text) 
          : double.tryParse(_ctrlHE100.text.replaceAll(',', '.')) ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calculadora Trabalhista"), backgroundColor: Colors.blueGrey),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: "Entradas", color: Colors.blue),
            InputTrabalhista(label: "Salário Base", controller: _ctrlSalBase, isMoney: true, onChanged: (_) => _atualizarCalculos()),
            InputTrabalhista(label: "Salário Mínimo", controller: _ctrlSalMin, isMoney: true, onChanged: (_) => _atualizarCalculos()),
            InputTrabalhista(label: "Incentivo", controller: _ctrlIncentivo, isMoney: true, onChanged: (_) => _atualizarCalculos()),
            InputTrabalhista(label: "Descontos Falta/DSR", controller: _ctrlDescontosFalta, isMoney: true, onChanged: (_) => _atualizarCalculos()),
            InputTrabalhista(label: "Outros Descontos", controller: _ctrlOutrosDescontos, isMoney: true, onChanged: (_) => _atualizarCalculos()),

            const SectionHeader(title: "Opções", color: Colors.blue),
            DropdownTrabalhista(
              label: "Jornada", 
              items: const ["220", "200", "180"], 
              value: logic.jornada.toInt().toString(), 
              onChanged: (v) => setState(() { logic.jornada = double.parse(v!); _atualizarCalculos(); })
            ),
            
            const SectionHeader(title: "Resumo Final", color: Colors.blueGrey),
            _buildResumoBox(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildResumoBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blueGrey.shade200)
      ),
      child: Column(
        children: [
          ResumoLine(label: "Salário Base", valor: logic.salBase, cor: Colors.black),
          ResumoLine(label: "Inss", valor: logic.descINSS, cor: Colors.red),
          const Divider(),
          ResumoLine(label: "Total Líquido", valor: logic.totalLiquido, cor: Colors.blue, bold: true),
        ],
      ),
    );
  }
}