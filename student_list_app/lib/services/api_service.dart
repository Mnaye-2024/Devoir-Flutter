import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student.dart'; 

class ApiService {


  static const String _baseUrl = 'http://10.0.2.2:3000';



  Future<List<Student>> getInscriptions({String? classe}) async {
    String endpoint = '/inscription';
    if (classe != null && classe.isNotEmpty && classe != "Toutes les classes") {
      endpoint += '?classe=${Uri.encodeComponent(classe)}';
    }

    try {
      final response = await http.get(Uri.parse('$_baseUrl$endpoint'));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        List<Student> students = body
            .map((dynamic item) => Student.fromJson(item as Map<String, dynamic>))
            .toList();
        return students;
      } else {
        print('Failed to load inscriptions. Status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load inscriptions (status: ${response.statusCode})');
      }
    } catch (e) {
      print('Error fetching inscriptions: $e');
      throw Exception('Failed to load inscriptions: $e');
    }
  }

  Future<List<String>> getDistinctClasses() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/inscription'));
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        Set<String> classes = body
            .map((dynamic item) => (item as Map<String, dynamic>)['classe'] as String? ?? 'N/A') 
            .toSet();
        var sortedClasses = classes.toList()..sort();
        return ["Toutes les classes", ...sortedClasses];
      } else {
        print('Failed to load classes. Status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load classes (status: ${response.statusCode})');
      }
    } catch (e) {
      print('Error fetching distinct classes: $e');
      throw Exception('Failed to load classes: $e');
    }
  }
}
