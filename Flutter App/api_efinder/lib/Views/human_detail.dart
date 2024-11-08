import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HumanDetailScreen extends StatefulWidget {
  final int id;

  HumanDetailScreen({required this.id});

  @override
  _HumanDetailScreenState createState() => _HumanDetailScreenState();
}

class _HumanDetailScreenState extends State<HumanDetailScreen> {
  Map<String, dynamic>? human;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchHumanDetail();
  }

  Future<void> fetchHumanDetail() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.242/api/get_human_detail.php?id=${widget.id}'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'Loaded') {
          setState(() {
            human = data['data'];
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = data['message'] ?? 'Failed to load details';
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
        errorMessage = 'Failed to load details: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Human Details', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF3A405A),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); // Pop the current screen from the stack
          },
          icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
        ),
      ),

      backgroundColor: Color(0xFFF5F5F5),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Color(0xFF3A405A)))
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage, style: TextStyle(color: Colors.red, fontSize: 16)))
          : human != null
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Human Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3A405A),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Table(
                  border: TableBorder(
                    horizontalInside: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  columnWidths: {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(2),
                  },
                  children: [
                    _buildTableRow('ID', human!['id'].toString()),
                    _buildTableRow('Name', human!['name']),
                    _buildTableRow('Details', human!['details']),
                  ],
                ),
              ],
            ),
          ),
        ),
      )
          : Center(child: Text('No data available')),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF3A405A),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            value,
            style: TextStyle(color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
