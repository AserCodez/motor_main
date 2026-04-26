class CalculateFillTimeUseCase {
  const CalculateFillTimeUseCase();

  double call({
    required double capacityLiters,
    required double currentLiters,
    required double flowRateLitersPerMinute,
  }) {
    if (flowRateLitersPerMinute <= 0) {
      return double.infinity;
    }

    final remainingLiters = (capacityLiters - currentLiters)
        .clamp(0.0, capacityLiters)
        .toDouble();

    return remainingLiters / flowRateLitersPerMinute;
  }
}
