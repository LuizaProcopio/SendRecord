const express = require('express');
const router = express.Router();

module.exports = (auth, validator) => {
  router.post('/login', async (req, res) => {
    try {
      const { email, password } = req.body;
      const emailValidation = validator.validateEmail(email);
      if (!emailValidation.valid) {
        return res.status(400).json({
          success: false,
          message: emailValidation.error
        });
      }
      const passwordValidation = validator.validatePassword(password);
      if (!passwordValidation.valid) {
        return res.status(400).json({
          success: false,
          message: passwordValidation.error
        });
      }
      const sanitized = validator.sanitizeObject({ email, password });
      const ipAddress = req.ip || req.connection.remoteAddress || '127.0.0.1';
      const result = await auth.login(
        sanitized.email,
        sanitized.password,
        ipAddress
      );
      res.json(result);
    } catch (error) {
      res.status(401).json({
        success: false,
        message: error.message
      });
    }
  });

  router.post('/logout', async (req, res) => {
    try {
      const token = req.headers['authorization']?.replace('Bearer ', '');
      if (!token) {
        return res.status(400).json({
          success: false,
          message: 'Token não fornecido'
        });
      }
      await auth.logout(token);
      res.json({
        success: true,
        message: 'Logout realizado com sucesso'
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: error.message
      });
    }
  });

  router.post('/change-password', async (req, res) => {
    try {
      const token = req.headers['authorization']?.replace('Bearer ', '');
      const validation = auth.validateSession(token);
      if (!validation.valid) {
        return res.status(401).json({
          success: false,
          message: validation.reason
        });
      }
      const { oldPassword, newPassword } = req.body;
      const passValidation = validator.validatePassword(newPassword, { minLength: 8 });
      if (!passValidation.valid) {
        return res.status(400).json({
          success: false,
          message: passValidation.error
        });
      }
      const result = await auth.changePassword(
        validation.session.userId,
        oldPassword,
        newPassword
      );
      res.json(result);
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  });

  router.get('/validate', (req, res) => {
    try {
      const token = req.headers['authorization']?.replace('Bearer ', '');
      if (!token) {
        return res.status(401).json({
          success: false,
          valid: false,
          message: 'Token não fornecido'
        });
      }
      const validation = auth.validateSession(token);
      if (!validation.valid) {
        return res.status(401).json({
          success: false,
          valid: false,
          message: validation.reason
        });
      }
      res.json({
        success: true,
        valid: true,
        user: {
          id: validation.session.userId,
          nome: validation.session.nome,
          email: validation.session.email,
          tipoAcesso: validation.session.tipoAcesso
        }
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: error.message
      });
    }
  });

  return router;
};
