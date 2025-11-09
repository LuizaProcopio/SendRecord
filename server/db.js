const mysql = require('mysql2')

const conexao = mysql.createPool({
    host: 'localhost',
    user: 'root',
    password: 'Luhar2923',
    database: 'banco_pi'
})

module.exports = conexao