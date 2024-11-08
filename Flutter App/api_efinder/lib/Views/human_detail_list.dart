import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'human_detail.dart';

class HumanListScreen extends StatefulWidget {
  @override
  _HumanListScreenState createState() => _HumanListScreenState();
}

class _HumanListScreenState extends State<HumanListScreen> {
  List humans = [];
  bool isLoading = true;
  String errorMessage = '';
  String searchQuery = ''; // Store the search query

  @override
  void initState() {
    super.initState();
    fetchHumans(); // Fetch the initial list
  }

  // Update the fetchHumans method to accept a search query
  Future<void> fetchHumans({String query = ''}) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      // Create the search URL with query parameters
      final url = Uri.parse('http://192.168.1.242/api/get_human_list.php?name=$query');
      final response = await http.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'Loaded') {
          setState(() {
            humans = data['data'];
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = data['message'];
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Error fetching data. Status: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load humans: $e';
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Human List', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF3A405A),
        elevation: 0,
      ),
      backgroundColor: Color(0xFFF5F5F5), // Light background for contrast
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
                fetchHumans(query: query); // Fetch data with the new search query
              },
              decoration: InputDecoration(
                labelText: 'Search by Name ',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator(color: Color(0xFF3A405A)))
                : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage, style: TextStyle(color: Colors.red, fontSize: 16)))
                : ListView.builder(
              itemCount: humans.length,
              padding: const EdgeInsets.all(8.0),
              itemBuilder: (context, index) {
                final human = humans[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(
                      human['name'],
                      style: TextStyle(
                        color: Color(0xFF3A405A),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      'ID: ${human['id']}',
                      style: TextStyle(color: Colors.black54),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, color: Color(0xFF3A405A)),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) {
                            return HumanDetailScreen(id: int.parse(human['id']));
                          },
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.easeInOut;

                            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);

                            return SlideTransition(position: offsetAnimation, child: child);
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
