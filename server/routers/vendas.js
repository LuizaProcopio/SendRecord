const express = require('express');
const router = express.Router();
const db = require('../db');
const util = require('util');

const multer = require('multer');
const path = require('path');     
const fs = require('fs'); 

const query = util.promisify(db.query).bind(db);
const queueService = require('../../queue/services/queueService');

const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        const uploadDir = path.join(__dirname, '../../provas_embalagem');
        
        if (!fs.existsSync(uploadDir)) {
            fs.mkdirSync(uploadDir, { recursive: true });
        }
        
        cb(null, uploadDir);
    },
    filename: function (req, file, cb) {
        const pedidoId = req.params.id;
        const timestamp = Date.now();
        const ext = path.extname(file.originalname);
        cb(null, `pedido_${pedidoId}_${timestamp}${ext}`);
    }
});

const upload = multer({
    storage: storage,
    limits: { fileSize: 5 * 1024 * 1024 },
    fileFilter: function (req, file, cb) {
        const allowedTypes = /jpeg|jpg|png|gif/;
        const extname = allowedTypes.test(path.extname(file.originalname).toLowerCase());
        const mimetype = allowedTypes.test(file.mimetype);
        
        if (mimetype && extname) {
            return cb(null, true);
        } else {
            cb(new Error('Apenas imagens são permitidas'));
        }
    }
});

function verificarAutenticacao(req, res, next) {
    if (!req.session.usuario) {
        return res.redirect('/login');
    }
    next();
}

router.get('/', verificarAutenticacao, async (req, res) => {
    try {
        const { busca } = req.query;

        console.log('==================');
        console.log('Session usuario:', req.session.usuario);
        console.log('Session nome:', req.session.nome);
        console.log('Session tipo_acesso:', req.session.tipo_acesso);
        console.log('===================');

        let sqlQuery = `
            SELECT 
                p.id,
                p.order_id as numero_pedido,
                p.created_at as data_venda,
                p.customer_name as nome_completo,
                c.cpf_cnpj as nf,
                p.status as situacao,
                p.valor_total,
                p.source
            FROM pedidos p
            LEFT JOIN clientes c ON p.cliente_id = c.id
            WHERE 1=1
        `;

        const params = [];

        if (busca && busca.trim() !== '') {
            sqlQuery += ` AND (
                p.order_id LIKE ? OR 
                p.customer_name LIKE ? OR
                c.cpf_cnpj LIKE ?
            )`;
            const searchTerm = `%${busca.trim()}%`;
            params.push(searchTerm, searchTerm, searchTerm);
        }

        sqlQuery += ` ORDER BY p.created_at DESC LIMIT 100`;

        const vendas = await query(sqlQuery, params);

        res.render('vendas', {
            nome: req.session.nome || req.session.usuario || 'Usuário',
            tipo_acesso: req.session.tipo_acesso || 'operador',
            currentPage: 'vendas',
            vendas: vendas,
            busca: busca || ''
        });

    } catch (error) {
        console.error('Erro ao carregar vendas:', error);
        res.render('vendas', {
            nome: req.session.nome || req.session.usuario || 'Usuário',
            tipo_acesso: req.session.tipo_acesso || 'operador',
            currentPage: 'vendas',
            vendas: [],
            erro: 'Erro ao carregar os pedidos: ' + error.message,
            busca: ''
        });
    }
});

router.post('/novo', verificarAutenticacao, async (req, res) => {
    try {
        const {
            order_id,
            source,
            customer_name,
            cpf_cnpj,
            telefone,
            email,
            cep,
            logradouro,
            numero,
            complemento,
            bairro,
            cidade,
            estado,
            observacoes
        } = req.body;

        console.log('Criando novo pedido:', { order_id, customer_name, source });

        const usuarios = await query('SELECT id FROM usuarios WHERE nome = ?', [req.session.nome]);
        const usuarioId = usuarios.length > 0 ? usuarios[0].id : null;

        if (!usuarioId) {
            return res.redirect('/vendas?erro=' + encodeURIComponent('Usuário não encontrado'));
        }

        const pedidoExiste = await query('SELECT id FROM pedidos WHERE order_id = ?', [order_id]);
        if (pedidoExiste.length > 0) {
            return res.redirect('/vendas?erro=' + encodeURIComponent('Order ID já existe no sistema'));
        }

        let clienteId = null;
        
        if (cpf_cnpj && cpf_cnpj.trim() !== '') {
            const cpfCnpjLimpo = cpf_cnpj.replace(/\D/g, '');
            const clienteExistente = await query(
                'SELECT id FROM clientes WHERE cpf_cnpj = ?',
                [cpfCnpjLimpo]
            );

            if (clienteExistente.length > 0) {
                clienteId = clienteExistente[0].id;
                
                await query(`
                    UPDATE clientes 
                    SET nome = ?, email = ?, telefone = ?, ultima_compra = CURDATE(), total_pedidos = total_pedidos + 1
                    WHERE id = ?
                `, [customer_name, email || null, telefone || null, clienteId]);
            }
        }

        if (!clienteId) {
            const clientePorNome = await query(
                'SELECT id FROM clientes WHERE nome = ? LIMIT 1',
                [customer_name]
            );

            if (clientePorNome.length > 0) {
                clienteId = clientePorNome[0].id;
                
                await query(`
                    UPDATE clientes 
                    SET email = COALESCE(?, email), 
                        telefone = COALESCE(?, telefone),
                        cpf_cnpj = COALESCE(?, cpf_cnpj),
                        ultima_compra = CURDATE(),
                        total_pedidos = total_pedidos + 1
                    WHERE id = ?
                `, [email, telefone, cpf_cnpj ? cpf_cnpj.replace(/\D/g, '') : null, clienteId]);
            }
        }

        if (!clienteId) {
            const tipoCliente = cpf_cnpj && cpf_cnpj.replace(/\D/g, '').length > 11 ? 'pessoa_juridica' : 'pessoa_fisica';
            
            const resultCliente = await query(`
                INSERT INTO clientes (nome, cpf_cnpj, email, telefone, tipo_cliente, ultima_compra, total_pedidos)
                VALUES (?, ?, ?, ?, ?, CURDATE(), 1)
            `, [
                customer_name,
                cpf_cnpj ? cpf_cnpj.replace(/\D/g, '') : null,
                email || null,
                telefone || null,
                tipoCliente
            ]);
            
            clienteId = resultCliente.insertId;
            console.log('Novo cliente criado. ID:', clienteId);
        }

        if (cep && logradouro && cidade && estado) {
            const cepLimpo = cep.replace(/\D/g, '');
            const enderecoExistente = await query(
                'SELECT id FROM enderecos_clientes WHERE cliente_id = ? AND principal = TRUE',
                [clienteId]
            );

            if (enderecoExistente.length > 0) {
                await query(`
                    UPDATE enderecos_clientes
                    SET cep = ?, logradouro = ?, numero = ?, complemento = ?,
                        bairro = ?, cidade = ?, estado = ?, tipo_endereco = 'principal'
                    WHERE id = ?
                `, [
                    cepLimpo,
                    logradouro,
                    numero || 'S/N',
                    complemento || null,
                    bairro || '',
                    cidade,
                    estado,
                    enderecoExistente[0].id
                ]);
            } else {
                await query(`
                    INSERT INTO enderecos_clientes 
                    (cliente_id, tipo_endereco, cep, logradouro, numero, complemento, bairro, cidade, estado, principal)
                    VALUES (?, 'principal', ?, ?, ?, ?, ?, ?, ?, TRUE)
                `, [
                    clienteId,
                    cepLimpo,
                    logradouro,
                    numero || 'S/N',
                    complemento || null,
                    bairro || '',
                    cidade,
                    estado
                ]);
            }
        }

        let sourceFormatado = source;
        const sourceMap = {
            'loja_fisica': 'Manual',
            'whatsapp': 'Manual',
            'marketplace': 'Mercado_Livre',
            'site': 'Wix',
            'wix': 'Wix',
            'mercado_livre': 'Mercado_Livre',
            'manual': 'Manual'
        };
        
        sourceFormatado = sourceMap[source.toLowerCase()] || 'Manual';

        const resultPedido = await query(`
            INSERT INTO pedidos (
                order_id,
                source,
                cliente_id,
                customer_name,
                item_count,
                valor_total,
                status,
                observacoes,
                usuario_criacao_id,
                created_at
            ) VALUES (?, ?, ?, ?, 0, 0.00, 'Pendente', ?, ?, NOW())
        `, [
            order_id.toUpperCase(),
            sourceFormatado,
            clienteId,
            customer_name,
            observacoes || null,
            usuarioId
        ]);

        const pedidoId = resultPedido.insertId;

        await query(`
            INSERT INTO auditoria_sistema (usuario_id, acao, descricao, tabela_afetada, registro_id)
            VALUES (?, 'CRIAR_PEDIDO', ?, 'pedidos', ?)
        `, [
            usuarioId,
            `Pedido ${order_id.toUpperCase()} criado manualmente via sistema`,
            pedidoId
        ]);

        console.log('Pedido criado com sucesso! ID:', pedidoId);
        
        queueService.addTask({
            tipo: 'embalagem',
            descricao: `Embalar pedido #${order_id.toUpperCase()} - Cliente: ${customer_name}`,
            dados: {
                pedido_id: pedidoId,
                order_id: order_id.toUpperCase(),
                cliente: customer_name,
                origem: sourceFormatado,
                cpf_cnpj: cpf_cnpj || null,
                telefone: telefone || null
            },
            prioridade: 'alta',
            usuario_id: usuarioId
        }, (error) => {
            if (error) {
                console.error('Erro ao adicionar na fila:', error);
            }
        });

        console.log('Pedido adicionado na fila de embalagem');
        
        res.redirect(`/vendas/detalhes/${pedidoId}?success=1`);

    } catch (error) {
        console.error('Erro ao criar pedido:', error);
        res.redirect('/vendas?erro=' + encodeURIComponent('Erro ao criar pedido: ' + error.message));
    }
});

router.get('/detalhes/:id', verificarAutenticacao, async (req, res) => {
    try {
        const pedidoId = req.params.id;

        console.log('Buscando detalhes do pedido:', pedidoId);

        const pedidos = await query(`
            SELECT 
                p.*,
                c.nome as cliente_nome,
                c.cpf_cnpj,
                c.email as cliente_email,
                c.telefone as cliente_telefone,
                c.tipo_cliente,
                e.logradouro,
                e.numero,
                e.complemento,
                e.bairro,
                e.cidade,
                e.estado,
                e.cep,
                u_criacao.nome as criado_por,
                u_empacotamento.nome as empacotado_por,
                pe.image_path as imagem_prova,
                pe.video_path as video_prova,
                pe.observacoes as observacoes_prova
            FROM pedidos p
            LEFT JOIN clientes c ON p.cliente_id = c.id
            LEFT JOIN enderecos_clientes e ON c.id = e.cliente_id AND e.principal = TRUE
            LEFT JOIN usuarios u_criacao ON p.usuario_criacao_id = u_criacao.id
            LEFT JOIN usuarios u_empacotamento ON p.usuario_empacotamento_id = u_empacotamento.id
            LEFT JOIN provas_embalagem pe ON p.id = pe.pedido_id
            WHERE p.id = ?
        `, [pedidoId]);

        if (pedidos.length === 0) {
            return res.status(404).send('Pedido não encontrado');
        }

        const pedido = pedidos[0];

        const provas = await query(`
            SELECT * FROM provas_embalagem WHERE pedido_id = ?
        `, [pedidoId]);

        const prova = provas.length > 0 ? provas[0] : null;

        const itens = await query(`
            SELECT 
                ip.*,
                p.nome as produto_nome,
                p.sku as produto_sku,
                vp.cor,
                vp.tamanho
            FROM itens_pedido ip
            LEFT JOIN produtos p ON ip.produto_id = p.id
            LEFT JOIN variacoes_produto vp ON ip.variacao_id = vp.id
            WHERE ip.pedido_id = ?
            ORDER BY ip.id
        `, [pedidoId]);

        const historico = await query(`
            SELECT 
                he.*,
                u.nome as usuario_nome,
                ip.product_name
            FROM historico_escaneamento he
            LEFT JOIN usuarios u ON he.usuario_id = u.id
            LEFT JOIN itens_pedido ip ON he.item_pedido_id = ip.id
            WHERE he.pedido_id = ?
            ORDER BY he.data_hora DESC
            LIMIT 20
        `, [pedidoId]);

        const totalItens = itens.reduce((sum, item) => sum + item.quantity_required, 0);
        const itensEscaneados = itens.reduce((sum, item) => sum + item.quantity_scanned, 0);
        const progresso = totalItens > 0 ? Math.round((itensEscaneados / totalItens) * 100) : 0;

        res.render('vendas-detalhes', {
            nome: req.session.nome || req.session.usuario || 'Usuário',
            tipo_acesso: req.session.tipo_acesso || 'operador',
            currentPage: 'vendas',
            pedido: pedido,
            prova: prova,
            itens: itens,
            historico: historico,
            progresso: progresso,
            totalItens: totalItens,
            itensEscaneados: itensEscaneados,
            success: req.query.success || null,
            erro: req.query.erro || null
        });

    } catch (error) {
        console.error('Erro ao carregar detalhes do pedido:', error);
        res.status(500).send('Erro ao carregar detalhes do pedido: ' + error.message);
    }
});

router.post('/detalhes/:id/status', verificarAutenticacao, async (req, res) => {
    try {
        const pedidoId = req.params.id;
        const { novoStatus, observacoes } = req.body;

        const usuarios = await query('SELECT id FROM usuarios WHERE nome = ?', [req.session.nome]);
        const usuarioId = usuarios.length > 0 ? usuarios[0].id : null;

        if (!usuarioId) {
            return res.status(401).json({ erro: 'Usuário não encontrado' });
        }

        const statusValidos = ['Pendente', 'Em_Separacao', 'Empacotado', 'Erro', 'Cancelado'];
        if (!statusValidos.includes(novoStatus)) {
            return res.status(400).json({ erro: 'Status inválido' });
        }

        let updateQuery = 'UPDATE pedidos SET status = ?, observacoes = ?';
        let updateParams = [novoStatus, observacoes || null];

        if (novoStatus === 'Empacotado') {
            updateQuery += ', usuario_empacotamento_id = ?, packed_at = NOW()';
            updateParams.push(req.session.usuario.id);
        }

        updateQuery += ' WHERE id = ?';
        updateParams.push(pedidoId);

        await query(updateQuery, updateParams);

        await query(`
            INSERT INTO auditoria_sistema (usuario_id, acao, descricao, tabela_afetada, registro_id)
            VALUES (?, 'ATUALIZAR_STATUS', ?, 'pedidos', ?)
        `, [
            req.session.usuario.id,
            `Status alterado para ${novoStatus}`,
            pedidoId
        ]);

        res.json({ sucesso: true, mensagem: 'Status atualizado com sucesso' });

    } catch (error) {
        console.error('Erro ao atualizar status:', error);
        res.status(500).json({ erro: 'Erro ao atualizar status do pedido' });
    }
});

router.post('/detalhes/:id/escanear', verificarAutenticacao, async (req, res) => {
    try {
        const pedidoId = req.params.id;
        const { barcode, itemPedidoId } = req.body;

        const itens = await query(
            'SELECT * FROM itens_pedido WHERE id = ? AND pedido_id = ?',
            [itemPedidoId, pedidoId]
        );

        if (itens.length === 0) {
            return res.status(404).json({ erro: 'Item não encontrado' });
        }

        const item = itens[0];
        const codigoCorreto = item.barcode === barcode;

        if (codigoCorreto && item.quantity_scanned < item.quantity_required) {
            const novaQuantidade = item.quantity_scanned + 1;
            const verificado = novaQuantidade >= item.quantity_required;

            await query(
                'UPDATE itens_pedido SET quantity_scanned = ?, verified = ? WHERE id = ?',
                [novaQuantidade, verificado, itemPedidoId]
            );

            await query(`
                INSERT INTO historico_escaneamento 
                (item_pedido_id, pedido_id, usuario_id, barcode_escaneado, sucesso, mensagem)
                VALUES (?, ?, ?, ?, TRUE, 'Item escaneado com sucesso')
            `, [itemPedidoId, pedidoId, req.session.usuario.id, barcode]);

            res.json({
                sucesso: true,
                mensagem: `Item escaneado (${novaQuantidade}/${item.quantity_required})`,
                verificado: verificado
            });

        } else if (item.quantity_scanned >= item.quantity_required) {
            res.status(400).json({ erro: 'Item já está completamente verificado' });
        } else {
            await query(`
                INSERT INTO historico_escaneamento 
                (item_pedido_id, pedido_id, usuario_id, barcode_escaneado, sucesso, mensagem)
                VALUES (?, ?, ?, ?, FALSE, 'Código de barras incorreto')
            `, [itemPedidoId, pedidoId, req.session.usuario.id, barcode]);

            res.status(400).json({ erro: 'Código de barras incorreto' });
        }

    } catch (error) {
        console.error('Erro ao registrar escaneamento:', error);
        res.status(500).json({ erro: 'Erro ao processar escaneamento' });
    }
});

router.post('/upload-imagem/:id', verificarAutenticacao, upload.single('imagem'), async (req, res) => {
    try {
        const pedidoId = req.params.id;
        const observacoes = req.body.observacoes || '';
        
        const usuarios = await query('SELECT id FROM usuarios WHERE nome = ?', [req.session.nome]);
        const usuarioId = usuarios.length > 0 ? usuarios[0].id : null;
        
        if (!usuarioId) {
            return res.status(401).json({ erro: 'Usuário não encontrado' });
        }
        
        if (!req.file) {
            return res.status(400).json({ erro: 'Nenhuma imagem foi enviada' });
        }
        
        const imagePath = `/provas_embalagem/${req.file.filename}`;
        
        const provasExistentes = await query(
            'SELECT id FROM provas_embalagem WHERE pedido_id = ?',
            [pedidoId]
        );
        
        if (provasExistentes.length > 0) {
            await query(`
                UPDATE provas_embalagem 
                SET image_path = ?, observacoes = ?, usuario_id = ?, created_at = NOW()
                WHERE pedido_id = ?
            `, [imagePath, observacoes, usuarioId, pedidoId]);
        } else {
            await query(`
                INSERT INTO provas_embalagem (pedido_id, image_path, usuario_id, observacoes)
                VALUES (?, ?, ?, ?)
            `, [pedidoId, imagePath, usuarioId, observacoes]);
        }
        
        await query(`
            UPDATE pedidos 
            SET status = 'Empacotado', 
                usuario_empacotamento_id = ?, 
                packed_at = NOW()
            WHERE id = ?
        `, [usuarioId, pedidoId]);
        
        await query(`
            INSERT INTO auditoria_sistema (usuario_id, acao, descricao, tabela_afetada, registro_id)
            VALUES (?, 'UPLOAD_PROVA', ?, 'provas_embalagem', ?)
        `, [usuarioId, 'Prova de embalagem enviada', pedidoId]);
        
        console.log('Prova salva com sucesso!');
        res.redirect('/vendas?sucesso=Prova enviada com sucesso!');
        
    } catch (error) {
        console.error('Erro ao fazer upload:', error);
        
        if (req.file) {
            const filePath = path.join(__dirname, '../../provas_embalagem', req.file.filename);
            if (fs.existsSync(filePath)) {
                fs.unlinkSync(filePath);
            }
        }
        
        res.status(500).json({ erro: 'Erro ao fazer upload: ' + error.message });
    }
});

router.get('/galeria/:id', verificarAutenticacao, async (req, res) => {
    try {
        const pedidoId = req.params.id;
        
        const pedidos = await query('SELECT * FROM pedidos WHERE id = ?', [pedidoId]);
        
        if (pedidos.length === 0) {
            return res.status(404).send('Pedido não encontrado');
        }
        
        const pedido = pedidos[0];
        
        const provas = await query(`
            SELECT 
                pe.*,
                u.nome as usuario_nome
            FROM provas_embalagem pe
            LEFT JOIN usuarios u ON pe.usuario_id = u.id
            WHERE pe.pedido_id = ?
            ORDER BY pe.created_at DESC
        `, [pedidoId]);
        
        res.render('vendas-galeria', {
            nome: req.session.nome || req.session.usuario || 'Usuário',
            tipo_acesso: req.session.tipo_acesso || 'operador',
            currentPage: 'vendas',
            pedido: pedido,
            provas: provas
        });
        
    } catch (error) {
        console.error('Erro ao carregar galeria:', error);
        res.status(500).send('Erro ao carregar galeria: ' + error.message);
    }
});

module.exports = router;