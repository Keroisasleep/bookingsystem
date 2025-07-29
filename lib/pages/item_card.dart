import 'package:flutter/material.dart';
import 'book.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ItemCard extends StatefulWidget {
  final Book book;
  final VoidCallback onDeleted;

  const ItemCard({super.key, required this.book, required this.onDeleted});

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  bool showDelete = false;

  Future<void> deleteBook() async {
    final url = Uri.parse('http://192.168.1.13:3000/books/${widget.book.id}');
    final response = await http.delete(url);

    if (response.statusCode == 204) {
      widget.onDeleted();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete book')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (showDelete) {
            setState(() {
              showDelete = false;
            });
          }
        },
        onLongPress: () {
          setState(() {
            showDelete = true;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              child: Card(
                color: showDelete ? Colors.red.withOpacity(0.45) : Colors.white,
                margin: const EdgeInsets.all(0),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.book.title,
                        style: GoogleFonts.quicksand(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.indigoAccent,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.book.author,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (showDelete)
              IconButton(
                icon: const Icon(Icons.delete, size: 36, color: Colors.red),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Book'),
                      content: const Text('Are you sure you want to delete this book?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Delete', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    deleteBook();
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
