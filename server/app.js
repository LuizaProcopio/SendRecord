const express = require('express')
const path = require('path')
const session = require('express-session')
const app = express()
require('dotenv').config()

app.set('view engine', 'ejs')
app.set('views', path.join(__dirname, '../renderer/views'))
app.use(express.static(path.join(__dirname, '../renderer/public')))
app.use(express.urlencoded({extended: false}))

app.use(session({
    secret: 'segredo-super-seguro',
    resave: false,
    saveUninitialized: false,
}))

app.use('/provas_embalagem', express.static(path.join(__dirname, '../provas_embalagem')));

app.use((req, res, next) => {
    // pega só a primeira parte da URL (ex: "/home" -> "home")
    const pathPart = req.path.split('/')[1] || 'home'
    res.locals.currentPage = pathPart
    res.locals.usuario = req.session.usuario
    next()
})

// Registrar as rotas DEPOIS dos middlewares
const authRouter = require('./routers/auth')
const homeRouter = require('./routers/home')
const vendasRouter = require('./routers/vendas')
const configRouter = require('./routers/config')

app.use('/', authRouter)
app.use('/home', homeRouter)
app.use('/vendas', vendasRouter)
app.use('/config', configRouter)

app.listen(4040, () => {
    console.log('Servidor inicializado em http://localhost:4040')
})