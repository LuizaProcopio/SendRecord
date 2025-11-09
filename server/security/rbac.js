class RBACSystem {
  constructor() {
    this.permissions = {
      admin: [
        'users.create', 'users.read', 'users.update', 'users.delete',
        'products.create', 'products.read', 'products.update', 'products.delete',
        'orders.create', 'orders.read', 'orders.update', 'orders.delete', 'orders.pack',
        'customers.create', 'customers.read', 'customers.update', 'customers.delete',
        'reports.view', 'reports.export',
        'audit.view', 'audit.export',
        'settings.read', 'settings.update',
        'api.configure'
      ],
      gerente: [
        'users.read', 'users.update',
        'products.create', 'products.read', 'products.update', 'products.delete',
        'orders.create', 'orders.read', 'orders.update', 'orders.pack',
        'customers.create', 'customers.read', 'customers.update',
        'reports.view', 'reports.export',
        'audit.view',
        'settings.read'
      ],
      supervisor: [
        'products.read', 'products.update',
        'orders.create', 'orders.read', 'orders.update', 'orders.pack',
        'customers.read', 'customers.update',
        'reports.view',
        'audit.view'
      ],
      operador: [
        'products.read',
        'orders.read', 'orders.pack',
        'customers.read'
      ]
    };
  }

  hasPermission(userRole, permission) {
    if (!this.permissions[userRole]) {
      console.error(`Role inválida: ${userRole}`);
      return false;
    }
    return this.permissions[userRole].includes(permission);
  }

  requirePermission(permission) {
    return (req, res, next) => {
      const userRole = req.session?.tipoAcesso;
      
      if (!userRole) {
        return res.status(401).json({
          success: false,
          message: 'Usuário não autenticado'
        });
      }

      if (!this.hasPermission(userRole, permission)) {
        return res.status(403).json({
          success: false,
          message: 'Acesso negado: permissão insuficiente',
          required: permission,
          userRole: userRole
        });
      }

      next();
    };
  }

  requireMinRole(minRole) {
    const roleHierarchy = {
      operador: 1,
      supervisor: 2,
      gerente: 3,
      admin: 4
    };

    return (req, res, next) => {
      const userRole = req.session?.tipoAcesso;
      
      if (!userRole) {
        return res.status(401).json({
          success: false,
          message: 'Usuário não autenticado'
        });
      }

      const userLevel = roleHierarchy[userRole] || 0;
      const requiredLevel = roleHierarchy[minRole] || 99;

      if (userLevel < requiredLevel) {
        return res.status(403).json({
          success: false,
          message: 'Acesso negado: nível de acesso insuficiente',
          required: minRole,
          userRole: userRole
        });
      }

      next();
    };
  }
}

module.exports = RBACSystem;