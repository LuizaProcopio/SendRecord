const mysql = require('mysql2')



const conexao = mysql.createConnection({

    host: process.env.localhost,
    user: process.env.root,
    password: process.env.Luhar2923,
    database: process.env.banco_pi

})



conexao.connect((err)=>{
    if (err) throw err
    console.log('Conectado ao Mysql!')
})

module.exports = conexao