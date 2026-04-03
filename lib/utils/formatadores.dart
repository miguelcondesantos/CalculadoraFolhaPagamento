// Helper para potência de 10
double pow10(int n) {
  double r = 1;
  for (int i = 0; i < n; i++) r *= 10;
  return r;
}

// Formata número com separador de milhares (ponto) e decimais com vírgula
String formatNumber(double value, {int decimals = 2}) {
  final sign = value < 0 ? '-' : '';
  final absValue = value.abs();
  final factor = pow10(decimals);
  final rounded = (absValue * factor).roundToDouble() / factor;
  final parts = rounded.toStringAsFixed(decimals).split('.');
  String intPart = parts[0];
  String decPart = parts.length > 1 ? parts[1] : '00';
  
  // inserir pontos a cada 3 dígitos da parte inteira
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

double parseCurrency(String texto) {
  if (texto.isEmpty) return 0;
  String t = texto.replaceAll('R\$', '').replaceAll(' ', '');
  t = t.replaceAll('.', '').replaceAll(',', '.');
  return double.tryParse(t) ?? 0;
}

double arredondar(double valor) => (valor * 100).roundToDouble() / 100;