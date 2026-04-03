// Helper para potência de 10
double pow10(int n) {
  double r = 1;
  for (int i = 0; i < n; i++) r *= 10;
  return r;
}

// -------------------------------
// FORMATAÇÃO
// -------------------------------

// Formata número com separador de milhares (.) e decimais (,)
String formatNumber(double value, {int decimals = 2}) {
  final sign = value < 0 ? '-' : '';
  final absValue = value.abs();
  final factor = pow10(decimals);

  final rounded = (absValue * factor).roundToDouble() / factor;
  final parts = rounded.toStringAsFixed(decimals).split('.');

  String intPart = parts[0];
  String decPart = parts.length > 1 ? parts[1] : '00';

  final buffer = StringBuffer();
  int count = 0;

  for (int i = intPart.length - 1; i >= 0; i--) {
    buffer.write(intPart[i]);
    count++;

    if (count == 3 && i != 0) {
      buffer.write('.');
      count = 0;
    }
  }

  final intWithDots = buffer.toString().split('').reversed.join();

  return '$sign$intWithDots,${decPart.padRight(decimals, '0')}';
}

String formatCurrency(double v) {
  return 'R\$ ${formatNumber(v, decimals: 2)}';
}

// -------------------------------
// PARSE
// -------------------------------

double parseCurrency(String texto) {
  if (texto.isEmpty) return 0;

  String t = texto.replaceAll('R\$', '').replaceAll(' ', '');
  t = t.replaceAll('.', '').replaceAll(',', '.');

  return double.tryParse(t) ?? 0;
}

// Para campos tipo "horas" (ex: 10,50)
double parseDecimal(String texto) {
  if (texto.isEmpty) return 0;
  return double.tryParse(texto.replaceAll(',', '.')) ?? 0;
}

// -------------------------------
// ARREDONDAMENTO
// -------------------------------

double arredondar(double valor) =>
    (valor * 100).roundToDouble() / 100;

// -------------------------------
// INPUT FORMAT HELPERS
// -------------------------------

// Remove tudo que não for número
String apenasNumeros(String valor) {
  return valor.replaceAll(RegExp(r'[^0-9]'), '');
}

// Formata entrada financeira (digitando 1234 -> 12,34)
String formatarEntradaFinanceira(String valor) {
  String nums = apenasNumeros(valor);
  double v = (double.tryParse(nums) ?? 0) / 100;
  return formatNumber(v, decimals: 2);
}

// Formata entrada decimal (para horas, mesmo comportamento)
String formatarEntradaDecimal(String valor) {
  String nums = apenasNumeros(valor);
  double v = (double.tryParse(nums) ?? 0) / 100;
  return formatNumber(v, decimals: 2);
}