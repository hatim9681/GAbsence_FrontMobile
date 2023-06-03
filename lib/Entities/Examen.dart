class Examen {
  final int id;
  final String dateExamen;
  final String heureD;
  final String salle;
  String matiere;
  Examen({
    required this.id,
    required this.dateExamen,
    required this.heureD,
    required this.matiere,
    required this.salle,
  });
  factory Examen.fromJson(Map<String, dynamic> json) {
    return Examen(
        id: json['id'],
        dateExamen: json['dateExamen'],
        heureD: json['heureDebut'],
        matiere: json['matiere'],
        salle: json['salle']);
  }
}
