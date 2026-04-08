class ForecastDay {
  const ForecastDay({
    required this.date,
    required this.minTemp,
    required this.maxTemp,
    required this.condition,
  });

  final DateTime date;
  final double minTemp;
  final double maxTemp;
  final String condition;
}
