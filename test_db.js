const { Client } = require('pg');
require('dotenv').config();

const client = new Client({
  host: 'your-db-instance.xxxxxx.us-east-1.rds.amazonaws.com',
  user: 'your-username',
  password: 'your-password',
  database: 'your-database',
});

client.connect((err) => {
  if (err) {
    console.error('Error connecting to the database:', err.message);
    return;
  }
  console.log('Connected to the database!');
  connection.end(); // Close the connection after testing
});
