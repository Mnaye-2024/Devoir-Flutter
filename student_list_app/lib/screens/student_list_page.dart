// lib/screens/student_list_page.dart
import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/api_service.dart';
import '../widgets/student_card.dart'; // Nous allons créer ce widget ensuite

class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key});

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  final ApiService _apiService = ApiService();
  late Future<List<Student>> _studentsFuture;
  Future<List<String>>? _classesFuture; // Pour le dropdown des classes

  String? _selectedClasse; // Classe actuellement sélectionnée pour le filtre
  List<String> _availableClasses = ["Toutes les classes"]; // Liste des classes pour le dropdown

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    _studentsFuture = _apiService.getInscriptions(); // Charge tous les étudiants au début
    _classesFuture = _apiService.getDistinctClasses().then((classes) {
      if (mounted) {
        setState(() {
          _availableClasses = classes;
          if (_availableClasses.isNotEmpty) {
             _selectedClasse = _availableClasses.first; // "Toutes les classes" par défaut
          }
        });
      }
      return classes;
    }).catchError((error) {
       if (mounted) {
        setState(() {
          // Gérer l'erreur de chargement des classes si nécessaire
          _availableClasses = ["Toutes les classes"];
           _selectedClasse = _availableClasses.first;
        });
      }
      print("Error loading classes: $error");
      return <String>["Toutes les classes"];
    });
  }

  void _filterStudents(String? classe) {
    setState(() {
      _selectedClasse = classe;
      _studentsFuture = _apiService.getInscriptions(
          classe: (classe == "Toutes les classes" || classe == null) ? null : classe);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Étudiants Inscrits'),
        backgroundColor: Colors.blueAccent,
        elevation: 2,
      ),
      body: Column(
        children: [
          _buildFilterDropdown(),
          Expanded(
            child: FutureBuilder<List<Student>>(
              future: _studentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Erreur: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red)));
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final students = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      return StudentCard(student: students[index]);
                    },
                  );
                } else {
                  return const Center(child: Text('Aucun étudiant trouvé.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return FutureBuilder<List<String>>(
      future: _classesFuture, // Utilise le future pour les classes
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && _availableClasses.length <=1) {
          // Affiche un loader minimaliste si les classes ne sont pas encore chargées
          // et que _availableClasses n'a que "Toutes les classes"
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: SizedBox(height: 20, width:20, child: CircularProgressIndicator(strokeWidth: 2.0)),
          );
        }
        // Si erreur de chargement des classes, on a au moins "Toutes les classes"
        // Si données chargées, _availableClasses est mis à jour dans le .then() de _loadInitialData
        
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Filtrer par classe',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            value: _selectedClasse,
            isExpanded: true,
            icon: const Icon(Icons.filter_list),
            items: _availableClasses.map((String classe) {
              return DropdownMenuItem<String>(
                value: classe,
                child: Text(classe, overflow: TextOverflow.ellipsis),
              );
            }).toList(),
            onChanged: (String? newValue) {
              _filterStudents(newValue);
            },
          ),
        );
      },
    );
  }
}