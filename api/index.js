const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

// Подключение к PostgreSQL с использованием pg-promise
const pgp = require('pg-promise')();
const db = pgp({
  connectionString: 'postgresql://root:1337@0.0.0.0:5432/users_db',
});

// Обработка JSON входящих данных
app.use(express.json());

app.get('/api/products', async (req, res) => {
  try {
    const products = await db.any('SELECT * FROM products');
    res.json(products);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Ошибка при получении продуктов' });
  }
});

app.listen(port, () => {
  console.log(`Сервер запущен на порту ${port}`);
});
