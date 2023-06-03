import 'package:exams_absentes/Entities/Etudiant.dart';
import 'package:exams_absentes/Entities/Examen.dart';

class Pv {
  final PvId id;
  final Etudiant etudiant;
  final Examen examen;
  final bool presence;

  Pv({
    required this.id,
    required this.etudiant,
    required this.examen,
    required this.presence,
  });

  factory Pv.fromJson(Map<String, dynamic> json) {
    return Pv(
      id: PvId.fromJson(json['id']),
      etudiant: Etudiant.fromJson(json['etudiant']),
      examen: Examen.fromJson(json['examen']),
      presence: json['presence'] ?? false,
    );
  }
}

class PvId {
  final int etudiants;
  final int examens;

  PvId({
    required this.etudiants,
    required this.examens,
  });

  factory PvId.fromJson(Map<String, dynamic> json) {
    return PvId(
      etudiants: json['etudiants'],
      examens: json['examens'],
    );
  }
}
