import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'add_book_page.dart';
import 'book.dart';
import 'item_card.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Book> books = [];

  Future<void> fetchBooks() async {
    final response = await http.get(Uri.parse('http://192.168.1.13:3000/books'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      setState(() {
        books = data.map((json) => Book.fromJson(json)).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[700],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddBookPage()),
          );
          fetchBooks();
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Text(
              'Book',
              style: GoogleFonts.quicksand(
                fontSize: 44,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: Colors.white,
              ),
            ),
            Text(
              'Collection',
              style: GoogleFonts.quicksand(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: books.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 2 / 2,
                  ),
                  itemBuilder: (context, index) {
                    return ItemCard(
                      book: books[index],
                      onDeleted: fetchBooks, // 👈 refresh list after delete
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}