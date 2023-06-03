import 'package:exams_absentes/Entities/Examen.dart';

class Etudiant {
  final int id;
  final String nom;
  final String prenom;
  final String email;
  final String telephone;
  final String filiere;
  final String cne;
  final String num_appo;
  final List<Examen> examens;
  const Etudiant({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.telephone,
    required this.filiere,
    required this.cne,
    required this.num_appo,
    required this.examens,
  });
  factory Etudiant.fromJson(Map<String, dynamic> json) {
    List<Examen> parsedExams = [];
    if (json['examens'] != null) {
      for (var examen in json['examens']) {
        parsedExams.add(Examen(
          id: examen['id'],
          dateExamen: examen['dateExamen'],
          heureD: examen['heureDebut'],
          matiere: examen['matiere'],
          salle: examen['salle'],
        ));
      }
    }
    return Etudiant(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      telephone: json['telephone'],
      filiere: json['filiere'],
      cne: json['cne'],
      num_appo: json['num_appo'],
      examens: parsedExams,
    );
  }
}
