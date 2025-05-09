class Student {
  final int id;
  final String nom;
  final String prenom;
  final String classe;
  final String matricule;
  final String email;

  Student({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.classe,
    required this.matricule,
    required this.email,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? 0, // Au cas où l'id ne serait pas présent
      nom: json['nom'] ?? 'N/A',
      prenom: json['prenom'] ?? 'N/A',
      classe: json['classe'] ?? 'N/A',
      matricule: json['matricule'] ?? 'N/A',
      email: json['email'] ?? 'N/A',
    );
  }

  // Utile si vous deviez renvoyer des données au serveur
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'classe': classe,
      'matricule': matricule,
      'email': email,
    };
  }

  String get fullName => '$prenom $nom';
}