class AhpReport {
  final Map<String, dynamic> criteriaWeights;
  final double cr;
  final List<dynamic> matrices;
  final List<dynamic> alternativeWeights;
  final List<dynamic> finalScores;
  final String best;

  AhpReport({
    required this.criteriaWeights,
    required this.cr,
    required this.matrices,
    required this.alternativeWeights,
    required this.finalScores,
    required this.best,
  });

  factory AhpReport.fromJson(Map<String, dynamic> json) {
    return AhpReport(
      criteriaWeights: json['criteriaWeights'],
      cr: json['cr'],
      matrices: json['matrices'],
      alternativeWeights: json['alternativeWeights'],
      finalScores: json['finalScores'],
      best: json['best'],
    );
  }
}