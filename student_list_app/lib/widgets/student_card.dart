import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentCard extends StatelessWidget {
  final Student student;

  const StudentCard({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              student.fullName,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 8.0),
            _buildInfoRow(Icons.class_, 'Classe:', student.classe),
            _buildInfoRow(Icons.badge, 'Matricule:', student.matricule),
            _buildInfoRow(Icons.email, 'Email:', student.email),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 18.0, color: Colors.grey[700]),
          const SizedBox(width: 8.0),
          Text(
            '$label ',
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.grey[700],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}