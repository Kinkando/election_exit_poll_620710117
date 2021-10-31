class Candidate {
  final int number;
  final String displayName;
  final int score;

  Candidate({
    required this.number,
    required this.displayName,
    this.score = 0
  });

  factory Candidate.fromJson(Map<String, dynamic> json) {
    return Candidate(
      number: json['number'],
      displayName: json['displayName'],
    );
  }

  factory Candidate.fromJson2(Map<String, dynamic> json) {
    return Candidate(
      number: json['number'],
      displayName: json['displayName'],
      score: json['score'],
    );
  }
}