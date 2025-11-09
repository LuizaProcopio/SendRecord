const conexao = require('../db.js');

class Logger {
  static salvarLog(opcoes) {
    const {
      usuarioId = null,
      usuarioNome = 'System',
      acao = 'SELECT',
      descricao = '',
      ip = '127.0.0.1',
      sucesso = 1,
      erro = null
    } = opcoes;

    const query = `
      INSERT INTO logs_sistema 
      (usuario_mysql, usuario_app_id, usuario_app_nome, acao, 
       query_executada, ip_address, navegador, data_hora, sucesso, mensagem_erro)
      VALUES ('app', ?, ?, ?, ?, ?, 'Electron App', NOW(), ?, ?)
    `;

    conexao.query(query, [
      usuarioId,
      usuarioNome,
      acao,
      descricao,
      ip,
      sucesso,
      erro
    ], (error) => {
      if (error) {
        console.error('Erro ao salvar log:', error.message);
      } else {
        console.log('Log salvo:', { usuario: usuarioNome, acao, descricao });
      }
    });
  }

  static salvarAuditoria(opcoes) {
    const {
      usuarioId,
      acao,
      descricao,
      tabela = null,
      registroId = null,
      ip = '127.0.0.1',
      dadosAnteriores = null,
      dadosNovos = null
    } = opcoes;

    const query = `
      INSERT INTO auditoria_sistema 
      (usuario_id, acao, descricao, tabela_afetada, registro_id,
       ip_address, dados_anteriores, dados_novos, data_hora)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())
    `;

    conexao.query(query, [
      usuarioId,
      acao,
      descricao,
      tabela,
      registroId,
      ip,
      dadosAnteriores ? JSON.stringify(dadosAnteriores) : null,
      dadosNovos ? JSON.stringify(dadosNovos) : null
    ], (error) => {
      if (error) {
        console.error('Erro ao salvar auditoria:', error.message);
      } else {
        console.log('Auditoria salva:', { usuario: usuarioId, acao, descricao });
      }
    });
  }

  static login(usuarioId, usuarioNome, ip) {
    this.salvarLog({
      usuarioId,
      usuarioNome,
      acao: 'LOGIN',
      descricao: `Login: ${usuarioNome}`,
      ip,
      sucesso: 1
    });

    this.salvarAuditoria({
      usuarioId,
      acao: 'LOGIN',
      descricao: `Usuário ${usuarioNome} fez login`,
      ip
    });
  }

  static logout(usuarioId, usuarioNome, ip) {
    this.salvarLog({
      usuarioId,
      usuarioNome,
      acao: 'LOGOUT',
      descricao: `Logout: ${usuarioNome}`,
      ip,
      sucesso: 1
    });

    this.salvarAuditoria({
      usuarioId,
      acao: 'LOGOUT',
      descricao: `Usuário ${usuarioNome} fez logout`,
      ip
    });
  }

  static erro(descricao, erro) {
    this.salvarLog({
      acao: 'ERROR',
      descricao,
      sucesso: 0,
      erro: erro?.message || String(erro)
    });
  }

  static api(metodo, caminho, usuarioId, usuarioNome, ip) {
    this.salvarLog({
      usuarioId,
      usuarioNome: usuarioNome || 'Anônimo',
      acao: 'SELECT',
      descricao: `${metodo} ${caminho}`,
      ip
    });
  }

  static success(message) {
    console.log(message);
  }

  static error(message, erro) {
    console.error(message);
    if (erro) console.error(erro);
  }

  static info(message) {
    console.log(message);
  }
}

module.exports = Logger;
