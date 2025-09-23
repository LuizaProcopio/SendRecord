const express = require('express')
const path = require('path')
const session = require('express-session')
const app = express()
require('dotenv').config()

app.set('view engine' ,'ejs')
app.set('views', path.join(__dirname, '../renderer/views'))
app.use(express.static(path.join(__dirname, '../renderer/public')))
app.use(express.urlencoded({extended: false}))

app.use(session({
    secret: 'segredo-super-seguro',
    resave: false,
    saveUninitialized: false,
}))

const authRouter = require('./routers/auth')
const homeGerenteRouter = require('./routers/homeGerente')

app.use('/', authRouter)
app.use('/homeGerente', homeGerenteRouter)


app.listen(4040, ()=>{
    console.log('Servidor inicializado em http://localhost:4040')
})