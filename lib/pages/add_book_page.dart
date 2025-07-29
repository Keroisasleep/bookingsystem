import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  Future<void> submitBook() async {
    final response = await http.post(
      Uri.parse('http://192.168.1.13:3000/books'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': _titleController.text,
        'author': _authorController.text,
      }),
    );

    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == 201) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add book')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[700],
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Add Your Book',
                    style: GoogleFonts.quicksand(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _titleController,
                        maxLength: 20,
                        decoration: const InputDecoration(labelText: 'Title'),
                        validator: (value) => value!.isEmpty ? 'Enter title' : null,
                      ),
                      TextFormField(
                        controller: _authorController,
                        maxLength: 20,
                        decoration: const InputDecoration(labelText: 'Author'),
                        validator: (value) => value!.isEmpty ? 'Enter author' : null,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              submitBook();
                            }
                          },
                          child: const Text(
                            'Submit',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
