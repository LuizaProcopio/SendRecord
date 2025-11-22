const express = require('express');
const path = require('path');
const session = require('express-session');
const cors = require('cors');

const Logger = require('./config/logger');
const AuthenticationSystem = require('./security/authi');
const RBACSystem = require('./security/rbac');
const AuditSystem = require('./security/audit');
const InputValidator = require('./security/validation');
const securityAuthRoutes = require('./routers/securityAuth');
const securityUserRoutes = require('./routers/securityUsers');
const securityAuditRoutes = require('./routers/securityAudit');
const authRouter = require('./routers/auth');
const homeRouter = require('./routers/home');
const vendasRouter = require('./routers/vendas');
const relatoriosRouter = require('./routers/relatorios');
const configRouter = require('./routers/config');

const app = express();
const PORT = 4040;

app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, '../renderer/views'));
app.use(express.static(path.join(__dirname, '../renderer/public')));
app.use(express.urlencoded({ extended: false }));
app.use(cors({ origin: process.env.FRONTEND_URL || 'http://localhost:5173', credentials: true }));
app.use(express.json());
app.use(session({ secret: 'segredo-super-seguro', resave: false, saveUninitialized: false }));
app.use('/provas_embalagem', express.static(path.join(__dirname, '../provas_embalagem')));

app.use((req, res, next) => {
  res.setHeader('X-Content-Type-Options', 'nosniff');
  res.setHeader('X-Frame-Options', 'DENY');
  res.setHeader('X-XSS-Protection', '1; mode=block');
  res.setHeader('Strict-Transport-Security', 'max-age=31536000; includeSubDomains');
  next();
});

const auth = new AuthenticationSystem();
const rbac = new RBACSystem();
const audit = new AuditSystem();
const validator = new InputValidator();
Logger.success('Sistemas de segurança inicializados');

const conexao = require('./db');

app.use(async (req, res, next) => {
  let token = req.headers['authorization']?.replace('Bearer ', '');

  if (!token && req.session && req.session.usuario) {
    const userName = req.session.usuario.nome || req.session.usuario.usuario || req.session.usuario.name;

    if (userName && !req.session.usuario.id) {
      try {
        const [usuarios] = await new Promise((resolve, reject) => {
          conexao.query(
            'SELECT id FROM usuarios WHERE nome = ? LIMIT 1',
            [userName],
            (error, results) => {
              if (error) reject(error);
              else resolve([results]);
            }
          );
        });

        if (usuarios && usuarios.length > 0) {
          const userId = usuarios[0].id;
          req.session.usuario.id = userId;
          req.usuarioLogado = {
            id: userId,
            nome: userName,
            email: req.session.usuario.email || userName,
            tipoAcesso: req.session.usuario.tipo_acesso
          };
        }
      } catch (error) {
        console.error('Erro ao buscar ID do usuário:', error);
      }
    } else if (userName && req.session.usuario.id) {
      req.usuarioLogado = {
        id: req.session.usuario.id,
        nome: userName,
        email: req.session.usuario.email || userName,
        tipoAcesso: req.session.usuario.tipo_acesso
      };
    }
  } else if (token) {
    const validation = auth.validateSession(token);
    if (validation.valid && validation.session) {
      req.usuarioLogado = {
        id: validation.session.userId,
        nome: validation.session.nome,
        email: validation.session.email,
        tipoAcesso: validation.session.tipoAcesso
      };
    }
  }

  next();
});

app.use((req, res, next) => {
  if (req.path.startsWith('/static') || req.path.includes('.css') || req.path.includes('.js') || req.path.includes('.png') || req.path.includes('.jpg')) {
    return next();
  }
  const ipAddress = req.ip || req.connection.remoteAddress || '127.0.0.1';
  if (req.usuarioLogado) {
    Logger.api(req.method, req.path, req.usuarioLogado.id, req.usuarioLogado.nome, ipAddress);
  }
  next();
});

setInterval(() => {
  const before = auth.activeSessions.size;
  auth.cleanupExpiredSessions();
  const after = auth.activeSessions.size;
  if (before !== after) {
    console.log(`${before - after} sessões expiradas removidas`);
  }
}, 5 * 60 * 1000);

app.use((req, res, next) => {
  const pathPart = req.path.split('/')[1] || 'home';
  res.locals.currentPage = pathPart;
  res.locals.usuario = req.session.usuario;
  next();
});

app.get('/health', (req, res) => {
  res.json({
    status: 'OK',
    timestamp: new Date().toISOString(),
    activeSessions: auth.activeSessions.size
  });
});

app.use('/api/security/auth', securityAuthRoutes(auth, validator));
app.use('/api/security/users', securityUserRoutes(auth, rbac, audit, validator));
app.use('/api/security/audit', securityAuditRoutes(auth, rbac, audit));
app.use('/', authRouter);
app.use('/home', homeRouter);
app.use('/vendas', vendasRouter);
app.use('/config', configRouter);
app.use('/relatorios', relatoriosRouter);

app.use((req, res) => {
  if (req.path.startsWith('/api/')) {
    return res.status(404).json({ success: false, message: 'Rota não encontrada' });
  }
  res.status(404).send('Página não encontrada');
});

app.use((err, req, res, next) => {
  Logger.erro('Erro no servidor', err);
  console.error('Erro capturado:', err);
  console.error('Stack:', err.stack);

  if (req.path.startsWith('/api/')) {
    return res.status(500).json({
      success: false,
      message: 'Erro interno do servidor',
      error: process.env.NODE_ENV === 'development' ? err.message : undefined
    });
  }

  res.status(500).send('Erro interno do servidor');
});

app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
  console.log(`Health check: http://localhost:${PORT}/health`);
  console.log(`API Segurança: http://localhost:${PORT}/api/security`);
});

module.exports = app;