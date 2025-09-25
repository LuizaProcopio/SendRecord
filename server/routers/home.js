const express = require('express')
const router = express.Router()

router.get('/',(req,res)=>{
    res.render('home',{
        usuario: req.session.usuario,
        nome: req.session.nome,
        tipo_acesso: req.session.tipo_acesso
    })
})

module.exports = router