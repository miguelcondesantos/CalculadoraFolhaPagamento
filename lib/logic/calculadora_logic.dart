import '../utils/formatadores.dart';

class CalculadoraLogic {
  // -------------------------------
  // INPUTS
  // -------------------------------
  double salBase = 0;
  double salMin = 0;
  double incentivo = 0;
  double descontosFalta = 0;
  double outrosDescontos = 0;

  // Horas Extras (entrada pode ser valor ou horas)
  double he50Input = 0;
  double he100Input = 0;

  // Configurações
  double jornada = 200;
  double quinquenio = 1;
  bool sextaParte = false;
  double insalubrePerc = 0.20;
  bool insalubreSobreBase = true;
  double dependentes = 1;

  String tipoHE50 = "Valor"; // "Valor" ou "Horas"
  String tipoHE100 = "Valor";

  // -------------------------------
  // CÁLCULOS BASE
  // -------------------------------

  double get salHora {
    if (jornada == 0) return 0;
    return arredondar(salBase / jornada);
  }

  double get valorQuinquenio =>
      arredondar(salBase * (0.05 * quinquenio));

  double get valorSextaParte =>
      sextaParte ? arredondar(salBase / 6) : 0;

  double get valorInsalubridade {
    double baseCalc = insalubreSobreBase ? salBase : salMin;
    return arredondar(baseCalc * insalubrePerc);
  }

  // -------------------------------
  // HORAS EXTRAS
  // -------------------------------

  double _calcularHE(double input, double mult, String tipo) {
    if (tipo == "Valor") return input;
    return arredondar(input * mult * salHora);
  }

  double get valorHE50Calculado =>
      _calcularHE(he50Input, 1.5, tipoHE50);

  double get valorHE100Calculado =>
      _calcularHE(he100Input, 2.0, tipoHE100);

  // -------------------------------
  // PROVENTOS
  // -------------------------------

  double get totalProventos {
    return arredondar(
      salBase +
          valorQuinquenio +
          valorSextaParte +
          valorInsalubridade +
          incentivo +
          valorHE50Calculado +
          valorHE100Calculado,
    );
  }

  // -------------------------------
  // BASES
  // -------------------------------

  double get baseINSS {
    double base =
        salBase + valorQuinquenio + incentivo - descontosFalta;
    return arredondar(base < 0 ? 0 : base);
  }

  double get baseIRRF {
    double somaProventos =
        salBase +
            valorQuinquenio +
            valorSextaParte +
            valorInsalubridade +
            incentivo +
            valorHE50Calculado +
            valorHE100Calculado;

    double deducaoDependentes = dependentes * 189.59;

    double base =
        somaProventos - descINSS - deducaoDependentes - descontosFalta;

    return arredondar(base < 0 ? 0 : base);
  }

  // -------------------------------
  // DESCONTOS
  // -------------------------------

  double get descINSS {
    double b = baseINSS;

    if (b <= 1621.00) return arredondar(b * 0.075);
    if (b <= 2902.84) return arredondar((b * 0.09) - 24.32);
    if (b <= 4354.27) return arredondar((b * 0.12) - 111.4);
    if (b <= 8475.55) return arredondar((b * 0.14) - 198.49);

    return 988.07;
  }

  double get descIRRF {
    double b = baseIRRF;

    if (b <= 5000.00) return 0;

    if (b <= 7350.00) {
      double v = 0.275 * b - 908.73 - (978.62 - (0.133145 * b));
      return arredondar(v < 0 ? 0 : v);
    }

    double v = 0.275 * b - 908.73;
    return arredondar(v < 0 ? 0 : v);
  }

  // -------------------------------
  // RESULTADO FINAL
  // -------------------------------

  double get totalLiquido {
    return arredondar(
      totalProventos -
          descINSS -
          descIRRF -
          descontosFalta -
          outrosDescontos,
    );
  }

  // -------------------------------
  // HELPERS (IMPORTANTE PRA UI)
  // -------------------------------

  double horasParaValor(double horas, double mult) {
    return arredondar(horas * mult * salHora);
  }

  double valorParaHoras(double valor, double mult) {
    if (salHora == 0) return 0;
    return arredondar(valor / (mult * salHora));
  }
}