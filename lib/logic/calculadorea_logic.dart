import '../utils/formatadores.dart';

class CalculadoraLogic {
  // Valores puros que virão da tela
  double salBase = 0;
  double salMin = 0;
  double incentivo = 0;
  double descontosFalta = 0;
  double outrosDescontos = 0;
  
  // Horas Extras (valores ou horas dependendo do tipo)
  double he50ValorInput = 0;
  double he100ValorInput = 0;

  // Configurações dos Dropdowns
  double jornada = 200;
  double quinquenio = 1;
  String sextaParte = "Não";
  double insalubrePerc = 0.20; // 20%
  String sobre = "Base";
  double dependentes = 1;
  String tipoHE50 = "Valor";
  String tipoHE100 = "Valor";

  // --- CÁLCULOS ---
  
  double get salHora {
    if (jornada == 0) return 0;
    return arredondar(salBase / jornada);
  }

  double get valorQuinquenio => arredondar(salBase * (0.05 * quinquenio));

  double get valorSextaParte => sextaParte == "Não" ? 0 : arredondar(salBase / 6);

  double get valorInsalubridade {
    double baseCalc = sobre == "Base" ? salBase : salMin;
    return arredondar(baseCalc * insalubrePerc);
  }

  double get valorHE50Calculado {
    if (tipoHE50 == "Valor") return he50ValorInput;
    return arredondar(he50ValorInput * 1.5 * salHora);
  }

  double get valorHE100Calculado {
    if (tipoHE100 == "Valor") return he100ValorInput;
    return arredondar(he100ValorInput * 2.0 * salHora);
  }

  double get totalProventos {
    return arredondar(salBase +
        valorQuinquenio +
        valorSextaParte +
        valorInsalubridade +
        incentivo +
        valorHE50Calculado +
        valorHE100Calculado);
  }

  double get baseINSS {
    double base = salBase + valorQuinquenio + incentivo - descontosFalta;
    return arredondar(base < 0 ? 0 : base);
  }

  double get baseIRRF {
    double somaProventos = salBase + valorQuinquenio + valorSextaParte + 
                           valorInsalubridade + incentivo + 
                           valorHE50Calculado + valorHE100Calculado;
    double deducaoDependentes = dependentes * 189.59;
    double base = somaProventos - descINSS - deducaoDependentes - descontosFalta;
    return arredondar(base < 0 ? 0 : base);
  }

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

  double get totalLiquido => arredondar(totalProventos - descINSS - descIRRF - descontosFalta - outrosDescontos);
}