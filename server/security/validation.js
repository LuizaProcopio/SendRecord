class InputValidator {
  constructor() {
    this.patterns = {
      email: /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/,
      cpf: /^\d{3}\.\d{3}\.\d{3}-\d{2}$/,
      cnpj: /^\d{2}\.\d{3}\.\d{3}\/\d{4}-\d{2}$/
    };

    this.sqlBlacklist = [
      'DROP TABLE', 'DROP DATABASE', 'DELETE FROM', 'TRUNCATE',
      'ALTER TABLE', 'EXEC(', 'EXECUTE(', 'UNION SELECT',
      'OR 1=1', '<script', 'javascript:', 'onerror='
    ];
  }

  sanitizeString(input) {
    if (typeof input !== 'string') return input;

    let sanitized = input.replace(/<[^>]*>/g, '');
    sanitized = sanitized
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#x27;');

    return sanitized.trim();
  }

  validateEmail(email) {
    if (!email || typeof email !== 'string') {
      return { valid: false, error: 'Email é obrigatório' };
    }

    const sanitized = this.sanitizeString(email.toLowerCase());
    
    if (!this.patterns.email.test(sanitized)) {
      return { valid: false, error: 'Email inválido' };
    }

    return { valid: true, value: sanitized };
  }

  validatePassword(password, options = {}) {
    const { minLength = 8 } = options;

    if (!password) {
      return { valid: false, error: 'Senha é obrigatória' };
    }

    if (password.length < minLength) {
      return { valid: false, error: `Senha deve ter no mínimo ${minLength} caracteres` };
    }

    return { valid: true };
  }

  detectSQLInjection(input) {
    if (typeof input !== 'string') return false;
    const upperInput = input.toUpperCase();
    return this.sqlBlacklist.some(dangerous => upperInput.includes(dangerous));
  }

  validateInput(input, fieldName = 'campo') {
    if (input === null || input === undefined) {
      return { valid: true, value: input };
    }

    if (typeof input === 'string') {
      if (this.detectSQLInjection(input)) {
        return { 
          valid: false, 
          error: `${fieldName} contém caracteres não permitidos`,
          threat: 'SQL_INJECTION_DETECTED'
        };
      }
      return { valid: true, value: this.sanitizeString(input) };
    }

    return { valid: true, value: input };
  }

  sanitizeObject(obj) {
    if (obj === null || obj === undefined) return obj;
    if (typeof obj === 'string') return this.sanitizeString(obj);
    
    if (Array.isArray(obj)) {
      return obj.map(item => this.sanitizeObject(item));
    }

    if (typeof obj === 'object') {
      const sanitized = {};
      for (const [key, value] of Object.entries(obj)) {
        sanitized[key] = this.sanitizeObject(value);
      }
      return sanitized;
    }

    return obj;
  }
}

module.exports = InputValidator;