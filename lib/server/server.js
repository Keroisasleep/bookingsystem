// server.js
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
app.use(cors());
app.use(bodyParser.json());

let books = []; // In-memory book list

// GET all books
app.get('/books', (req, res) => {
  console.log('➡️ GET /books');
  res.json(books);
});

// POST a new book
app.post('/books', (req, res) => {
  console.log('➡️ POST /books');
  console.log('📦 Payload:', req.body);

  const { title, author } = req.body;
  if (!title || !author) {
    console.log('❌ Missing title or author');
    return res.status(400).json({ error: 'Title and author required' });
  }

  const newBook = { id: Date.now(), title, author };
  books.push(newBook);

  console.log('✅ Book added:', newBook);
  res.status(201).json(newBook);
});

// DELETE a book
app.delete('/books/:id', (req, res) => {
  const bookId = parseInt(req.params.id);
  console.log(`🗑️ DELETE /books/${bookId}`);

  books = books.filter(book => book.id !== bookId);
  res.status(204).send();
});

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`🚀 Server is running on http://localhost:${PORT}`);
});
