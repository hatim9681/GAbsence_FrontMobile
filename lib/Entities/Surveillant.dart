// ignore_for_file: file_names

class Surveillant {
  final int id;
  final String nom;
  final String prenom;
  final String email;
  final String telephone;
  final String password;
  final String imageUrl;
  const Surveillant({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.telephone,
    required this.imageUrl,
    required this.password,
  });
  factory Surveillant.fromJson(Map<String, dynamic> json) {
    return Surveillant(
        id: json['id'],
        nom: json['nom'],
        prenom: json['prenom'],
        email: json['email'],
        telephone: json['telephone'],
        imageUrl: json['imageUrl'],
        password: json['password']);
  }
}
