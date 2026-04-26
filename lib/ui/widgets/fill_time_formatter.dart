String formatFillTime(double fillTimeMinutes) {
  if (fillTimeMinutes.isInfinite || fillTimeMinutes.isNaN) {
    return 'Unavailable';
  }

  if (fillTimeMinutes <= 0) {
    return 'Tank Full';
  }

  final roundedMinutes = fillTimeMinutes.round();
  if (roundedMinutes >= 60) {
    final duration = Duration(minutes: roundedMinutes);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '$hours h $minutes m';
  }

  return '${fillTimeMinutes.toStringAsFixed(1)} min';
}
