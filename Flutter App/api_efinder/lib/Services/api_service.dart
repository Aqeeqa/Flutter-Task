import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Models/human.dart';

class ApiService {
  final String baseUrl = 'http://192.168.1.242/api/';

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login.php'), // Make sure the URL is correct
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final Map<String, dynamic> responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      return responseData;
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<Map<String, dynamic>> signup(String name, String phone, String email, String password) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'signup.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'phone': phone,
        'email': email,
        'password': password,
      }),
    );
    return jsonDecode(response.body);
  }

  // Method to fetch a list of humans
  // Method to fetch a list of humans
  Future<List<Human>> getHumans() async {
    final url = Uri.parse('$baseUrl/get_human_list.php');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data['status'] == 'Loaded') {
        List<dynamic> humansData = data['data'];
        return humansData.map((json) => Human.fromJson(json)).toList();
      } else {
        throw Exception(data['message'] ?? 'No data loaded');
      }
    } else {
      throw Exception('Failed to load humans');
    }
  }

  // Method to fetch details of a specific human
  Future<Human> getHumanDetail(int id) async {
    final url = Uri.parse('$baseUrl/get_human_detail.php?id=$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return Human.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Failed to load human details');
    }
  }}

