import mysql from 'mysql2/promise.js';

const pool = mysql.createPool({
    host: '127.0.0.1',
    user: 'root',
    password: '',
    database: 'threeas_kitchendb',
    decimalNumbers: true,   // return DECIMAL columns as JS numbers (avoids NaN from string concat)
});

export default pool;
