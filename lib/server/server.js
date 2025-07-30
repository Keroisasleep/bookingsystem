const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');

const app = express();
app.use(cors());
app.use(bodyParser.json());

// ✅ CONNECT TO MONGODB
mongoose.connect('mongodb://127.0.0.1:27017/bookingsystem', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});
const db = mongoose.connection;
db.on('error', console.error.bind(console, '❌ MongoDB connection error:'));
db.once('open', () => {
  console.log('✅ Connected to MongoDB');
});

// ✅ DEFINE BOOK SCHEMA & MODEL
const bookSchema = new mongoose.Schema({
  title: String,
  author: String,
});
const Book = mongoose.model('Book', bookSchema);

// 📚 GET all books
app.get('/books', async (req, res) => {
  try {
    const books = await Book.find();
    res.json(books);
  } catch (err) {
    console.error('❌ Fetch error:', err);
    res.status(500).json({ error: 'Failed to fetch books' });
  }
});

// ➕ POST a new book
app.post('/books', async (req, res) => {
  const { title, author } = req.body;
  if (!title || !author) {
    return res.status(400).json({ error: 'Title and author required' });
  }

  try {
    const newBook = new Book({ title, author });
    await newBook.save();
    console.log('✅ Book saved:', newBook);
    res.status(201).json(newBook);
  } catch (err) {
    console.error('❌ Error saving book:', err);
    res.status(500).json({ error: 'Failed to save book' });
  }
});

// ❌ DELETE a book
app.delete('/books/:id', async (req, res) => {
  try {
    await Book.findByIdAndDelete(req.params.id);
    console.log('🗑️ Deleted book with ID:', req.params.id);
    res.status(204).send();
  } catch (err) {
    console.error('❌ Delete error:', err);
    res.status(500).json({ error: 'Delete failed' });
  }
});

const PORT = 3000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Server running at http://0.0.0.0:${PORT}`);
});
