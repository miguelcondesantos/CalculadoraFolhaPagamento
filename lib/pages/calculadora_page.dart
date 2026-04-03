import 'package:flutter/material.dart';
import '../logic/calculadora_logic.dart';
import '../utils/formatadores.dart';
import '../widgets/componentes.ui.dart';

class CalculadoraPage extends StatefulWidget {
  const CalculadoraPage({super.key});

  @override
  State<CalculadoraPage> createState() => _CalculadoraPageState();
}

class _CalculadoraPageState extends State<CalculadoraPage> {
  final CalculadoraLogic logic = CalculadoraLogic();

  // Controllers
  final _ctrlSalBase = TextEditingController(text: "0,00");
  final _ctrlSalMin = TextEditingController(text: "0,00");
  final _ctrlIncentivo = TextEditingController(text: "0,00");
  final _ctrlDescontosFalta = TextEditingController(text: "0,00");
  final _ctrlOutrosDescontos = TextEditingController(text: "0,00");
  final _ctrlHE50 = TextEditingController(text: "0,00");
  final _ctrlHE100 = TextEditingController(text: "0,00");

  @override
  void initState() {
    super.initState();
    _atualizarCalculos();
  }

  void _atualizarCalculos() {
    logic.salBase = parseCurrency(_ctrlSalBase.text);
    logic.salMin = parseCurrency(_ctrlSalMin.text);
    logic.incentivo = parseCurrency(_ctrlIncentivo.text);
    logic.descontosFalta = parseCurrency(_ctrlDescontosFalta.text);
    logic.outrosDescontos = parseCurrency(_ctrlOutrosDescontos.text);

    // HE 50
    logic.he50Input = logic.tipoHE50 == "Valor"
        ? parseCurrency(_ctrlHE50.text)
        : parseDecimal(_ctrlHE50.text);

    // HE 100
    logic.he100Input = logic.tipoHE100 == "Valor"
        ? parseCurrency(_ctrlHE100.text)
        : parseDecimal(_ctrlHE100.text);

    setState(() {});
  }

  Widget _buildHE(String label, bool is50) {
    final ctrl = is50 ? _ctrlHE50 : _ctrlHE100;
    final tipo = is50 ? logic.tipoHE50 : logic.tipoHE100;
    final mult = is50 ? 1.5 : 2.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: tipo,
                items: ["Horas", "Valor"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  if (v == null) return;

                  setState(() {
                    // 🔁 sincroniza os dois (igual monolito)
                    logic.tipoHE50 = v;
                    logic.tipoHE100 = v;
                  });

                  _atualizarCalculos();
                },
                decoration: InputDecoration(
                  labelText: "H.E $label",
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: InputTrabalhista(
                label: tipo == "Valor" ? "Valor" : "Qtd Horas",
                controller: ctrl,
                isMoney: tipo == "Valor",
                decimalShift: tipo == "Horas",
                onChanged: (_) => _atualizarCalculos(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          "Resultado $label: ${_converterHE(tipo, ctrl.text, mult)}",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  String _converterHE(String tipo, String valorInput, double mult) {
    if (tipo == "Horas") {
      double horas = parseDecimal(valorInput);
      double valor = logic.horasParaValor(horas, mult);
      return formatCurrency(valor);
    } else {
      double valor = parseCurrency(valorInput);
      double horas = logic.valorParaHoras(valor, mult);
      return "${formatNumber(horas)} h";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculadora Trabalhista"),
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: "Entradas", color: Colors.blue),

            InputTrabalhista(
              label: "Salário Base",
              controller: _ctrlSalBase,
              isMoney: true,
              onChanged: (_) => _atualizarCalculos(),
            ),

            InputTrabalhista(
              label: "Salário Mínimo",
              controller: _ctrlSalMin,
              isMoney: true,
              onChanged: (_) => _atualizarCalculos(),
            ),

            InputTrabalhista(
              label: "Incentivo",
              controller: _ctrlIncentivo,
              isMoney: true,
              onChanged: (_) => _atualizarCalculos(),
            ),

            InputTrabalhista(
              label: "Descontos Falta/DSR",
              controller: _ctrlDescontosFalta,
              isMoney: true,
              onChanged: (_) => _atualizarCalculos(),
            ),

            InputTrabalhista(
              label: "Outros Descontos",
              controller: _ctrlOutrosDescontos,
              isMoney: true,
              onChanged: (_) => _atualizarCalculos(),
            ),

            const SectionHeader(title: "Opções", color: Colors.blue),

            DropdownTrabalhista(
              label: "Jornada",
              items: const ["220", "200", "180"],
              value: logic.jornada.toInt().toString(),
              onChanged: (v) {
                logic.jornada = double.parse(v!);
                _atualizarCalculos();
              },
            ),

            DropdownTrabalhista(
              label: "Quinquênios",
              items: const ["0", "1", "2", "3", "4", "5", "6", "7"],
              value: logic.quinquenio.toInt().toString(),
              onChanged: (v) {
                logic.quinquenio = double.parse(v!);
                _atualizarCalculos();
              },
            ),

            DropdownTrabalhista(
              label: "Insalubre (%)",
              items: const ["0", "10", "20", "40"],
              value: (logic.insalubrePerc * 100).toInt().toString(),
              onChanged: (v) {
                logic.insalubrePerc = double.parse(v!) / 100;
                _atualizarCalculos();
              },
            ),

            DropdownTrabalhista(
              label: "Sobre",
              items: const ["Base", "Mínimo"],
              value: logic.insalubreSobreBase ? "Base" : "Mínimo",
              onChanged: (v) {
                logic.insalubreSobreBase = v == "Base";
                _atualizarCalculos();
              },
            ),

            DropdownTrabalhista(
              label: "Sexta Parte",
              items: const ["Sim", "Não"],
              value: logic.sextaParte ? "Sim" : "Não",
              onChanged: (v) {
                logic.sextaParte = v == "Sim";
                _atualizarCalculos();
              },
            ),

            DropdownTrabalhista(
              label: "Dependentes",
              items: const ["0", "1", "2", "3", "4", "5"],
              value: logic.dependentes.toInt().toString(),
              onChanged: (v) {
                logic.dependentes = double.parse(v!);
                _atualizarCalculos();
              },
            ),

            const SizedBox(height: 10),

            Text(
              "Salário/Hora: ${formatCurrency(logic.salHora)}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),

            const SectionHeader(title: "Horas Extras", color: Colors.blue),

            _buildHE("50%", true),
            _buildHE("100%", false),

            const SectionHeader(title: "Resumo Final", color: Colors.blueGrey),

            ResumoBox(
              children: [
                ResumoLine(
                  label: "Salário Base",
                  valor: logic.salBase,
                  cor: Colors.black,
                ),
                ResumoLine(
                  label: "Quinquênio",
                  valor: logic.valorQuinquenio,
                  cor: Colors.black,
                ),
                ResumoLine(
                  label: "INSS",
                  valor: logic.descINSS,
                  cor: Colors.red,
                ),
                ResumoLine(
                  label: "IRRF",
                  valor: logic.descIRRF,
                  cor: Colors.red,
                ),
                const Divider(),
                ResumoLine(
                  label: "Total Líquido",
                  valor: logic.totalLiquido,
                  cor: Colors.blue,
                  bold: true,
                ),
              ],
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
