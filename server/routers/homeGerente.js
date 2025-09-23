const express = require('express')
const router = express.Router()

router.get('/',(req,res)=>{
    res.render('homeGerente',{
        usuario: req.session.usuario,
        nome: req.session.nome // Certifique-se de que está armazenando o nome na sessão
    })
})

module.exports = router