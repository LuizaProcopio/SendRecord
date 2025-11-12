const mysql = require('mysql2')



const conexao = mysql.createConnection({

    host: process.env.host,
    user: process.env.user,
    password: process.env.password,
    database: process.env.database

})



conexao.connect((err)=>{
    if (err) throw err
    console.log('Conectado ao Mysql!')
})

module.exports = conexao