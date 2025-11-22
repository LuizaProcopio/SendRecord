-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: localhost    Database: banco_pi
-- ------------------------------------------------------
-- Server version	8.0.41

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `api_credentials`
--

DROP TABLE IF EXISTS `api_credentials`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `api_credentials` (
  `id` int NOT NULL AUTO_INCREMENT,
  `service_name` enum('Wix','Mercado_Livre','Bling') NOT NULL,
  `base_url` varchar(255) DEFAULT NULL,
  `encrypted_key` text,
  `encrypted_secret` text,
  `token_expiry` timestamp NULL DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `ultima_sincronizacao` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `service_name` (`service_name`),
  KEY `idx_service` (`service_name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_credentials`
--

LOCK TABLES `api_credentials` WRITE;
/*!40000 ALTER TABLE `api_credentials` DISABLE KEYS */;
INSERT INTO `api_credentials` VALUES (1,'Wix','https://www.wixapis.com',NULL,NULL,NULL,1,NULL),(2,'Mercado_Livre','https://api.mercadolibre.com',NULL,NULL,NULL,1,NULL),(3,'Bling','https://www.bling.com.br/Api/v3',NULL,NULL,NULL,1,NULL);
/*!40000 ALTER TABLE `api_credentials` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auditoria_sistema`
--

DROP TABLE IF EXISTS `auditoria_sistema`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auditoria_sistema` (
  `id` int NOT NULL AUTO_INCREMENT,
  `usuario_id` int NOT NULL,
  `usuario_nome` varchar(300) DEFAULT NULL,
  `acao` varchar(100) NOT NULL,
  `descricao` text,
  `tabela_afetada` varchar(50) DEFAULT NULL,
  `registro_id` int DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `dados_anteriores` json DEFAULT NULL,
  `dados_novos` json DEFAULT NULL,
  `data_hora` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_usuario` (`usuario_id`),
  KEY `idx_acao` (`acao`),
  KEY `idx_data` (`data_hora`),
  CONSTRAINT `auditoria_sistema_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auditoria_sistema`
--

LOCK TABLES `auditoria_sistema` WRITE;
/*!40000 ALTER TABLE `auditoria_sistema` DISABLE KEYS */;
INSERT INTO `auditoria_sistema` VALUES (1,1,NULL,'UPLOAD_PROVA','Prova de embalagem enviada','provas_embalagem',1,NULL,NULL,NULL,'2025-11-10 22:56:03'),(2,2,NULL,'UPLOAD_PROVA','Prova de embalagem enviada','provas_embalagem',2,NULL,NULL,NULL,'2025-11-11 01:08:28'),(3,1,NULL,'CRIAR_PEDIDO','Pedido 50 criado manualmente via sistema','pedidos',6,NULL,NULL,NULL,'2025-11-12 23:02:00'),(4,1,NULL,'UPLOAD_PROVA','Prova de embalagem enviada','provas_embalagem',5,NULL,NULL,NULL,'2025-11-12 23:08:13'),(5,1,NULL,'CRIAR_PEDIDO','Pedido 100 criado manualmente via sistema','pedidos',7,NULL,NULL,NULL,'2025-11-12 23:09:44'),(6,1,NULL,'CRIAR_PEDIDO','Pedido 123 criado manualmente via sistema','pedidos',8,NULL,NULL,NULL,'2025-11-13 23:26:15'),(7,1,NULL,'CRIAR_PEDIDO','Pedido 1233 criado manualmente via sistema','pedidos',9,NULL,NULL,NULL,'2025-11-13 23:35:49'),(8,1,NULL,'CRIAR_PEDIDO','Pedido WD1DW1 criado manualmente via sistema','pedidos',10,NULL,NULL,NULL,'2025-11-13 23:38:07'),(9,1,NULL,'UPLOAD_PROVA','Prova de embalagem enviada','provas_embalagem',10,NULL,NULL,NULL,'2025-11-13 23:40:34'),(10,1,NULL,'CRIAR_PEDIDO','Pedido 123456 criado manualmente via sistema','pedidos',11,NULL,NULL,NULL,'2025-11-14 16:15:19'),(11,1,NULL,'CRIAR_PEDIDO','Pedido 2542432 criado manualmente via sistema','pedidos',12,NULL,NULL,NULL,'2025-11-14 23:48:33'),(12,1,NULL,'UPLOAD_PROVA','Prova de embalagem enviada','provas_embalagem',6,NULL,NULL,NULL,'2025-11-15 00:46:44'),(13,1,NULL,'EDITAR_USUARIO','Usuário João Oliveira (ID: 4) atualizado','usuarios',NULL,NULL,NULL,NULL,'2025-11-15 01:16:51'),(14,1,NULL,'CRIAR_USUARIO','Usuário maria Luiza criado com tipo operador','usuarios',NULL,NULL,NULL,NULL,'2025-11-15 01:17:32'),(15,9,NULL,'UPLOAD_PROVA','Prova de embalagem enviada','provas_embalagem',11,NULL,NULL,NULL,'2025-11-15 01:20:17'),(16,1,NULL,'EDITAR_USUARIO','Usuário João Oliveira (ID: 4) atualizado','usuarios',NULL,NULL,NULL,NULL,'2025-11-15 01:29:16'),(17,1,NULL,'UPLOAD_PROVA','Prova de embalagem enviada','provas_embalagem',12,NULL,NULL,NULL,'2025-11-15 01:35:19'),(18,1,NULL,'EDITAR_USUARIO','Usuário maria Luiza (ID: 9) atualizado','usuarios',NULL,NULL,NULL,NULL,'2025-11-15 01:37:27'),(19,1,NULL,'EDITAR_USUARIO','Usuário fernando (ID: 8) atualizado','usuarios',NULL,NULL,NULL,NULL,'2025-11-15 02:25:15'),(20,1,NULL,'EDITAR_USUARIO','Usuário fernando (ID: 8) atualizado','usuarios',NULL,NULL,NULL,NULL,'2025-11-15 02:26:06'),(21,1,NULL,'EDITAR_USUARIO','Usuário fernando (ID: 8) atualizado','usuarios',NULL,NULL,NULL,NULL,'2025-11-15 02:27:20'),(22,1,NULL,'EDITAR_USUARIO','Usuário maria Luiza (ID: 9) atualizado','usuarios',NULL,NULL,NULL,NULL,'2025-11-15 02:28:49'),(23,1,NULL,'EDITAR_USUARIO','Usuário maria Luiza (ID: 9) atualizado','usuarios',NULL,NULL,NULL,NULL,'2025-11-15 02:29:14'),(24,1,NULL,'EDITAR_USUARIO','Usuário fernando (ID: 8) atualizado','usuarios',NULL,NULL,NULL,NULL,'2025-11-15 02:36:16'),(25,1,NULL,'EDITAR_USUARIO','Usuário Admin (ID: 1) atualizado','usuarios',NULL,NULL,NULL,NULL,'2025-11-15 02:36:31'),(26,1,NULL,'EDITAR_USUARIO','Usuário fernando (ID: 8) atualizado','usuarios',NULL,NULL,NULL,NULL,'2025-11-15 02:39:38'),(27,8,NULL,'EDITAR_USUARIO','Usuário fernando (ID: 8) atualizado','usuarios',NULL,NULL,NULL,NULL,'2025-11-15 02:42:36'),(28,8,NULL,'UPLOAD_PROVA','Prova de embalagem enviada','provas_embalagem',9,NULL,NULL,NULL,'2025-11-15 02:58:33'),(29,1,NULL,'UPLOAD_PROVA','Prova de embalagem enviada','provas_embalagem',8,NULL,NULL,NULL,'2025-11-15 14:53:54'),(30,1,NULL,'EDITAR_USUARIO','Usuário Ana Costa (ID: 5) atualizado','usuarios',NULL,NULL,NULL,NULL,'2025-11-22 01:31:43'),(31,5,NULL,'EDITAR_USUARIO','Usuário Carlos Silva (ID: 2) atualizado','usuarios',NULL,NULL,NULL,NULL,'2025-11-22 01:32:24'),(32,5,NULL,'EDITAR_USUARIO','Usuário fernando (ID: 8) atualizado','usuarios',NULL,NULL,NULL,NULL,'2025-11-22 01:32:33'),(33,5,NULL,'EDITAR_USUARIO','Usuário Juliana Alves (ID: 7) atualizado','usuarios',NULL,NULL,NULL,NULL,'2025-11-22 01:32:42'),(34,5,'Ana Costa','CRIAR_USUARIO','Usuário Felipe silva criado com tipo operador','usuarios',NULL,NULL,NULL,NULL,'2025-11-22 01:40:29'),(35,5,'Ana Costa','EDITAR_USUARIO','Usuário Felipe silva (ID: 10) atualizado','usuarios',10,'::1','{\"nome\": \"Felipe silva\", \"ativo\": 1, \"email\": \"Felipesilva@gmai.com\", \"tipo_acesso\": \"operador\"}','{\"nome\": \"Felipe silva\", \"ativo\": 1, \"email\": \"Felipesilva@gmai.com\", \"tipo_acesso\": \"operador\"}','2025-11-22 01:42:47');
/*!40000 ALTER TABLE `auditoria_sistema` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(150) NOT NULL,
  `cpf_cnpj` varchar(18) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `tipo_cliente` enum('pessoa_fisica','pessoa_juridica') DEFAULT 'pessoa_fisica',
  `data_cadastro` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ultima_compra` date DEFAULT NULL,
  `total_pedidos` int DEFAULT '0',
  `ativo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cpf_cnpj` (`cpf_cnpj`),
  KEY `idx_nome` (`nome`),
  KEY `idx_cpf_cnpj` (`cpf_cnpj`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (1,'Roberto Mendes','123.456.789-00','roberto.mendes@email.com','(11) 98765-4321','pessoa_fisica','2025-11-10 22:55:19',NULL,5,1),(2,'Empresa XYZ Ltda','12.345.678/0001-90','contato@empresaxyz.com.br','(11) 3456-7890','pessoa_juridica','2025-11-10 22:55:19',NULL,15,1),(3,'Patricia Lima','987.654.321-00','patricia.lima@email.com','(11) 91234-5678','pessoa_fisica','2025-11-10 22:55:19',NULL,3,1),(4,'Loja ABC Comercio','98.765.432/0001-10','vendas@lojaabc.com.br','(11) 3333-4444','pessoa_juridica','2025-11-10 22:55:19',NULL,25,1),(5,'Fernando Rodrigues','456.789.123-00','fernando.rodrigues@email.com','(11) 99999-8888','pessoa_fisica','2025-11-10 22:55:19',NULL,2,1),(6,'Marcos Augusto','321.654.987-00','marcos.augusto@email.com','(11) 97777-6666','pessoa_fisica','2025-11-10 22:55:19',NULL,8,1),(7,'Distribuidora MegaStore','11.222.333/0001-44','compras@megastore.com.br','(11) 2222-3333','pessoa_juridica','2025-11-10 22:55:19',NULL,40,1),(8,'jota','12345678910','jota@gmail.com','(19) 99806-9565','pessoa_fisica','2025-11-12 23:02:00','2025-11-12',1,1),(9,'LUIS','45245475254','luis.@gmail.com','(19) 9556-5587','pessoa_fisica','2025-11-12 23:09:44','2025-11-14',2,1),(10,'MIGUEL VITOR','25035416542','VITOR@GMAIL.COM','(19) 54216-5444','pessoa_fisica','2025-11-13 23:26:15','2025-11-13',1,1),(11,'MARIO','14621562545','MARIO@GMAIL.COM','(25) 46546-8544','pessoa_fisica','2025-11-13 23:35:49','2025-11-13',1,1),(12,'AAAAA','52221452214','AAAA@GMAIL.COM','(21) 45652-1458','pessoa_fisica','2025-11-13 23:38:07','2025-11-13',1,1),(13,'luci','54645454544','luci@gmai.com','(19) 54598-5484','pessoa_fisica','2025-11-14 23:48:33','2025-11-14',1,1),(14,'Lucas Pereira','111.222.333-44','lucas.pereira@email.com','(11) 98888-7777','pessoa_fisica','2025-11-22 01:45:31','2025-11-21',1,1),(15,'Maria Fernanda','222.333.444-55','maria.fernanda@email.com','(11) 97777-6666','pessoa_fisica','2025-11-22 01:45:31','2025-11-21',1,1),(16,'Tech Solutions Ltda','33.444.555/0001-66','compras@techsolutions.com.br','(11) 3333-2222','pessoa_juridica','2025-11-22 01:45:31','2025-11-21',1,1),(17,'João Carlos','333.444.555-66','joao.carlos@email.com','(19) 96666-5555','pessoa_fisica','2025-11-22 01:45:31','2025-11-21',1,1),(18,'Loja Express','44.555.666/0001-77','vendas@lojaexpress.com.br','(11) 4444-3333','pessoa_juridica','2025-11-22 01:45:31','2025-11-21',1,1);
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `configuracoes_sistema`
--

DROP TABLE IF EXISTS `configuracoes_sistema`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `configuracoes_sistema` (
  `id` int NOT NULL AUTO_INCREMENT,
  `chave` varchar(100) NOT NULL,
  `valor` text,
  `tipo` enum('texto','numero','booleano','json') DEFAULT 'texto',
  `descricao` varchar(255) DEFAULT NULL,
  `editavel` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `chave` (`chave`),
  KEY `idx_chave` (`chave`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `configuracoes_sistema`
--

LOCK TABLES `configuracoes_sistema` WRITE;
/*!40000 ALTER TABLE `configuracoes_sistema` DISABLE KEYS */;
INSERT INTO `configuracoes_sistema` VALUES (1,'tolerancia_peso','50','numero','Tolerância de peso em gramas para verificação',1),(2,'tempo_alerta_pedido','120','numero','Tempo em minutos para alerta de pedido pendente',1),(3,'habilitar_camera','true','booleano','Habilitar captura de prova fotográfica',1),(4,'path_imagens','./provas_embalagem/','texto','Caminho para salvar imagens de prova',1),(5,'empresa_nome','Mount Vernon','texto','Nome da empresa',1),(6,'empresa_cnpj','12.345.678/0001-90','texto','CNPJ da empresa',1),(7,'backup_automatico','true','booleano','Realizar backup automático diário',1),(8,'horario_backup','23:00','texto','Horário do backup automático',1);
/*!40000 ALTER TABLE `configuracoes_sistema` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `enderecos_clientes`
--

DROP TABLE IF EXISTS `enderecos_clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enderecos_clientes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cliente_id` int NOT NULL,
  `tipo_endereco` enum('entrega','cobranca','principal') DEFAULT 'principal',
  `cep` varchar(10) NOT NULL,
  `logradouro` varchar(200) NOT NULL,
  `numero` varchar(10) DEFAULT NULL,
  `complemento` varchar(100) DEFAULT NULL,
  `bairro` varchar(100) DEFAULT NULL,
  `cidade` varchar(100) NOT NULL,
  `estado` char(2) NOT NULL,
  `pais` varchar(50) DEFAULT 'Brasil',
  `principal` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_cliente` (`cliente_id`),
  CONSTRAINT `enderecos_clientes_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enderecos_clientes`
--

LOCK TABLES `enderecos_clientes` WRITE;
/*!40000 ALTER TABLE `enderecos_clientes` DISABLE KEYS */;
INSERT INTO `enderecos_clientes` VALUES (1,1,'principal','01310-100','Av. Paulista','1500',NULL,'Bela Vista','São Paulo','SP','Brasil',1),(2,2,'entrega','04543-907','Av. Brigadeiro Faria Lima','3477',NULL,'Itaim Bibi','São Paulo','SP','Brasil',1),(3,3,'principal','05402-000','Rua Harmonia','234',NULL,'Vila Madalena','São Paulo','SP','Brasil',1),(4,4,'entrega','03047-000','Rua do Grito','123',NULL,'Ipiranga','São Paulo','SP','Brasil',1),(5,5,'principal','01451-000','Rua Augusta','2690',NULL,'Cerqueira César','São Paulo','SP','Brasil',1),(6,6,'principal','04567-001','Av. Ibirapuera','2927',NULL,'Moema','São Paulo','SP','Brasil',1),(7,7,'entrega','01310-200','Av. Paulista','2100',NULL,'Consolação','São Paulo','SP','Brasil',1);
/*!40000 ALTER TABLE `enderecos_clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estatisticas_pedidos`
--

DROP TABLE IF EXISTS `estatisticas_pedidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estatisticas_pedidos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `data` date NOT NULL,
  `source` enum('Wix','Mercado_Livre','Manual','Outro') NOT NULL,
  `total_pedidos` int DEFAULT '0',
  `total_itens` int DEFAULT '0',
  `valor_total` decimal(10,2) DEFAULT '0.00',
  `pedidos_com_erro` int DEFAULT '0',
  `tempo_medio_processamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_data_source` (`data`,`source`),
  KEY `idx_data` (`data`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estatisticas_pedidos`
--

LOCK TABLES `estatisticas_pedidos` WRITE;
/*!40000 ALTER TABLE `estatisticas_pedidos` DISABLE KEYS */;
/*!40000 ALTER TABLE `estatisticas_pedidos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `historico_escaneamento`
--

DROP TABLE IF EXISTS `historico_escaneamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historico_escaneamento` (
  `id` int NOT NULL AUTO_INCREMENT,
  `item_pedido_id` int NOT NULL,
  `pedido_id` int NOT NULL,
  `usuario_id` int NOT NULL,
  `barcode_escaneado` varchar(50) NOT NULL,
  `data_hora` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `sucesso` tinyint(1) DEFAULT '1',
  `mensagem` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `item_pedido_id` (`item_pedido_id`),
  KEY `idx_pedido` (`pedido_id`),
  KEY `idx_usuario` (`usuario_id`),
  KEY `idx_data` (`data_hora`),
  CONSTRAINT `historico_escaneamento_ibfk_1` FOREIGN KEY (`item_pedido_id`) REFERENCES `itens_pedido` (`id`) ON DELETE CASCADE,
  CONSTRAINT `historico_escaneamento_ibfk_2` FOREIGN KEY (`pedido_id`) REFERENCES `pedidos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `historico_escaneamento_ibfk_3` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historico_escaneamento`
--

LOCK TABLES `historico_escaneamento` WRITE;
/*!40000 ALTER TABLE `historico_escaneamento` DISABLE KEYS */;
/*!40000 ALTER TABLE `historico_escaneamento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `itens_pedido`
--

DROP TABLE IF EXISTS `itens_pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `itens_pedido` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pedido_id` int NOT NULL,
  `produto_id` int NOT NULL,
  `variacao_id` int DEFAULT NULL,
  `sku` varchar(50) NOT NULL,
  `barcode` varchar(50) DEFAULT NULL,
  `product_name` varchar(200) NOT NULL,
  `variant_info` varchar(200) DEFAULT NULL,
  `quantity_required` int NOT NULL,
  `quantity_scanned` int DEFAULT '0',
  `verified` tinyint(1) DEFAULT '0',
  `preco_unitario` decimal(10,2) DEFAULT NULL,
  `subtotal` decimal(10,2) DEFAULT NULL,
  `peso_unitario_gramas` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `variacao_id` (`variacao_id`),
  KEY `idx_pedido` (`pedido_id`),
  KEY `idx_produto` (`produto_id`),
  KEY `idx_sku` (`sku`),
  CONSTRAINT `itens_pedido_ibfk_1` FOREIGN KEY (`pedido_id`) REFERENCES `pedidos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `itens_pedido_ibfk_2` FOREIGN KEY (`produto_id`) REFERENCES `produtos` (`id`),
  CONSTRAINT `itens_pedido_ibfk_3` FOREIGN KEY (`variacao_id`) REFERENCES `variacoes_produto` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `itens_pedido`
--

LOCK TABLES `itens_pedido` WRITE;
/*!40000 ALTER TABLE `itens_pedido` DISABLE KEYS */;
INSERT INTO `itens_pedido` VALUES (1,1,1,2,'MV-SOC-001-BR-M','7891234560102','Camisa Social Branca Clássica','Cor: Branco, Tamanho: M',2,0,0,189.90,379.80,280),(2,1,2,7,'MV-SOC-002-AZ-M','7891234560202','Camisa Social Azul Royal','Cor: Azul Royal, Tamanho: M',1,0,0,189.90,189.90,280),(3,2,1,2,'MV-SOC-001-BR-M','7891234560102','Camisa Social Branca Clássica','Cor: Branco, Tamanho: M',5,0,0,189.90,949.50,280),(4,2,2,7,'MV-SOC-002-AZ-M','7891234560202','Camisa Social Azul Royal','Cor: Azul Royal, Tamanho: M',5,0,0,189.90,949.50,280),(5,3,1,2,'MV-SOC-001-BR-M','7891234560102','Camisa Social Branca Clássica','Cor: Branco, Tamanho: M',1,1,0,189.90,189.90,280),(6,3,2,7,'MV-SOC-002-AZ-M','7891234560202','Camisa Social Azul Royal','Cor: Azul Royal, Tamanho: M',1,0,0,189.90,189.90,280);
/*!40000 ALTER TABLE `itens_pedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logs_sistema`
--

DROP TABLE IF EXISTS `logs_sistema`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logs_sistema` (
  `id` int NOT NULL AUTO_INCREMENT,
  `usuario_mysql` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `usuario_app_id` int DEFAULT NULL,
  `usuario_app_nome` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `acao` enum('INSERT','UPDATE','DELETE','SELECT','LOGIN','LOGOUT','ERROR') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tabela_afetada` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `registro_id` int DEFAULT NULL,
  `campo_alterado` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `valor_anterior` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `valor_novo` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `query_executada` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `navegador` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `data_hora` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `sucesso` tinyint(1) DEFAULT '1',
  `mensagem_erro` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `idx_usuario_mysql` (`usuario_mysql`),
  KEY `idx_usuario_app` (`usuario_app_id`),
  KEY `idx_acao` (`acao`),
  KEY `idx_tabela` (`tabela_afetada`),
  KEY `idx_data_hora` (`data_hora`),
  CONSTRAINT `logs_sistema_ibfk_1` FOREIGN KEY (`usuario_app_id`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=723 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logs_sistema`
--

LOCK TABLES `logs_sistema` WRITE;
/*!40000 ALTER TABLE `logs_sistema` DISABLE KEYS */;
INSERT INTO `logs_sistema` VALUES (1,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-10 22:55:48',1,NULL),(2,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-10 22:55:51',1,NULL),(3,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas/detalhes/1','::1','Electron App','2025-11-10 22:55:53',1,NULL),(4,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /vendas/upload-imagem/1','::1','Electron App','2025-11-10 22:56:03',1,NULL),(5,'root@localhost',NULL,NULL,'UPDATE','pedidos',1,'status','Pendente','Empacotado',NULL,NULL,NULL,'2025-11-10 22:56:03',1,NULL),(6,'root@localhost',NULL,NULL,'UPDATE','pedidos',1,'packed_at','NULL','2025-11-10 19:56:03',NULL,NULL,NULL,'2025-11-10 22:56:03',1,NULL),(7,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-10 22:56:03',1,NULL),(8,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-10 22:56:50',1,NULL),(9,'app',2,'Carlos Silva','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-10 22:57:25',1,NULL),(10,'app',2,'Carlos Silva','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-10 22:57:27',1,NULL),(11,'app',2,'Carlos Silva','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-10 22:57:29',1,NULL),(12,'app',2,'Carlos Silva','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-10 22:57:33',1,NULL),(13,'app',2,'Carlos Silva','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-10 22:57:35',1,NULL),(14,'app',2,'Carlos Silva','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas/detalhes/2','::1','Electron App','2025-11-10 22:57:38',1,NULL),(15,'app',2,'Carlos Silva','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-10 23:51:01',1,NULL),(16,'app',2,'Carlos Silva','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-11 00:14:16',1,NULL),(17,'app',5,'Ana Costa','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-11 00:14:28',1,NULL),(18,'app',5,'Ana Costa','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-11 00:14:30',1,NULL),(19,'app',2,'Carlos Silva','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-11 00:37:03',1,NULL),(20,'app',2,'Carlos Silva','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-11 00:37:06',1,NULL),(21,'app',2,'Carlos Silva','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-11 00:37:25',1,NULL),(22,'app',2,'Carlos Silva','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-11 00:38:09',1,NULL),(23,'app',2,'Carlos Silva','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-11 00:39:18',1,NULL),(24,'app',2,'Carlos Silva','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-11 01:04:35',1,NULL),(25,'app',2,'Carlos Silva','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-11 01:04:36',1,NULL),(26,'app',2,'Carlos Silva','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas/detalhes/5','::1','Electron App','2025-11-11 01:04:41',1,NULL),(27,'app',2,'Carlos Silva','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-11 01:06:19',1,NULL),(28,'app',2,'Carlos Silva','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-11 01:08:12',1,NULL),(29,'app',2,'Carlos Silva','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas/detalhes/2','::1','Electron App','2025-11-11 01:08:15',1,NULL),(30,'app',2,'Carlos Silva','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /vendas/upload-imagem/2','::1','Electron App','2025-11-11 01:08:28',1,NULL),(31,'root@localhost',NULL,NULL,'UPDATE','pedidos',2,'status','Pendente','Empacotado',NULL,NULL,NULL,'2025-11-11 01:08:28',1,NULL),(32,'root@localhost',NULL,NULL,'UPDATE','pedidos',2,'packed_at','NULL','2025-11-10 22:08:28',NULL,NULL,NULL,'2025-11-11 01:08:28',1,NULL),(33,'app',2,'Carlos Silva','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-11 01:08:28',1,NULL),(34,'app',2,'Carlos Silva','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-12 22:55:32',1,NULL),(35,'app',2,'Carlos Silva','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-12 22:55:34',1,NULL),(36,'app',2,'Carlos Silva','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-12 22:55:50',1,NULL),(37,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-12 22:56:07',1,NULL),(38,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-12 22:56:09',1,NULL),(39,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/editar/6','::1','Electron App','2025-11-12 22:56:31',1,NULL),(40,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /config/editar/6','::1','Electron App','2025-11-12 22:56:42',1,NULL),(41,'root@localhost',NULL,NULL,'UPDATE','usuarios',6,NULL,'Nome: Pedro Fernandes, Tipo: operador, Ativo: 1','Nome: Pedro Fernandes, Tipo: admin, Ativo: 1',NULL,NULL,NULL,'2025-11-12 22:56:42',1,NULL),(42,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/editar/6','::1','Electron App','2025-11-12 22:56:42',1,NULL),(43,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-12 22:57:22',1,NULL),(44,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/editar/6','::1','Electron App','2025-11-12 22:57:25',1,NULL),(45,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /config/editar/6','::1','Electron App','2025-11-12 22:57:34',1,NULL),(46,'root@localhost',NULL,NULL,'UPDATE','usuarios',6,NULL,'Nome: Pedro Fernandes, Tipo: admin, Ativo: 1','Nome: Pedro Fernandes, Tipo: operador, Ativo: 1',NULL,NULL,NULL,'2025-11-12 22:57:34',1,NULL),(47,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/editar/6','::1','Electron App','2025-11-12 22:57:34',1,NULL),(48,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-12 22:57:52',1,NULL),(49,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/novo','::1','Electron App','2025-11-12 22:57:55',1,NULL),(50,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /config/criar','::1','Electron App','2025-11-12 22:58:13',1,NULL),(51,'root@localhost',NULL,NULL,'INSERT','usuarios',8,NULL,NULL,'Usuário: fernando, Tipo: operador',NULL,NULL,NULL,'2025-11-12 22:58:13',1,NULL),(52,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/novo','::1','Electron App','2025-11-12 22:58:13',1,NULL),(53,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-12 23:00:01',1,NULL),(54,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/novo','::1','Electron App','2025-11-12 23:00:08',1,NULL),(55,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-12 23:00:10',1,NULL),(56,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-12 23:00:11',1,NULL),(57,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-12 23:00:12',1,NULL),(58,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas/detalhes/5','::1','Electron App','2025-11-12 23:00:36',1,NULL),(59,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-12 23:01:23',1,NULL),(60,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /vendas/novo','::1','Electron App','2025-11-12 23:02:00',1,NULL),(61,'root@localhost',NULL,NULL,'INSERT','pedidos',6,NULL,NULL,'Order ID: 50, Cliente: jota, Status: Pendente',NULL,NULL,NULL,'2025-11-12 23:02:00',1,NULL),(62,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas/detalhes/6','::1','Electron App','2025-11-12 23:02:00',1,NULL),(63,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-12 23:03:12',1,NULL),(64,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas/detalhes/6','::1','Electron App','2025-11-12 23:03:15',1,NULL),(65,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-12 23:03:20',1,NULL),(66,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-12 23:03:22',1,NULL),(67,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-12 23:03:36',1,NULL),(68,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-12 23:05:35',1,NULL),(69,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-12 23:06:49',1,NULL),(70,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas/detalhes/5','::1','Electron App','2025-11-12 23:07:59',1,NULL),(71,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /vendas/upload-imagem/5','::1','Electron App','2025-11-12 23:08:13',1,NULL),(72,'root@localhost',NULL,NULL,'UPDATE','pedidos',5,'status','Pendente','Empacotado',NULL,NULL,NULL,'2025-11-12 23:08:13',1,NULL),(73,'root@localhost',NULL,NULL,'UPDATE','pedidos',5,'packed_at','NULL','2025-11-12 20:08:13',NULL,NULL,NULL,'2025-11-12 23:08:13',1,NULL),(74,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-12 23:08:13',1,NULL),(75,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /vendas/novo','::1','Electron App','2025-11-12 23:09:44',1,NULL),(76,'root@localhost',NULL,NULL,'INSERT','pedidos',7,NULL,NULL,'Order ID: 100, Cliente: LUIS, Status: Pendente',NULL,NULL,NULL,'2025-11-12 23:09:44',1,NULL),(77,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas/detalhes/7','::1','Electron App','2025-11-12 23:09:44',1,NULL),(78,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-12 23:09:46',1,NULL),(79,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-12 23:09:51',1,NULL),(80,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-12 23:10:16',1,NULL),(81,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-12 23:12:00',1,NULL),(82,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-13 23:25:46',1,NULL),(83,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-13 23:25:49',1,NULL),(84,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /vendas/novo','::1','Electron App','2025-11-13 23:26:15',1,NULL),(85,'root@localhost',NULL,NULL,'INSERT','pedidos',8,NULL,NULL,'Order ID: 123, Cliente: MIGUEL VITOR, Status: Pendente',NULL,NULL,NULL,'2025-11-13 23:26:15',1,NULL),(86,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas/detalhes/8','::1','Electron App','2025-11-13 23:26:15',1,NULL),(87,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-13 23:35:17',1,NULL),(88,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-13 23:35:18',1,NULL),(89,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /vendas/novo','::1','Electron App','2025-11-13 23:35:49',1,NULL),(90,'root@localhost',NULL,NULL,'INSERT','pedidos',9,NULL,NULL,'Order ID: 1233, Cliente: MARIO, Status: Pendente',NULL,NULL,NULL,'2025-11-13 23:35:49',1,NULL),(91,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas/detalhes/9','::1','Electron App','2025-11-13 23:35:49',1,NULL),(92,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-13 23:37:05',1,NULL),(93,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-13 23:37:43',1,NULL),(94,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-13 23:37:44',1,NULL),(95,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /vendas/novo','::1','Electron App','2025-11-13 23:38:07',1,NULL),(96,'root@localhost',NULL,NULL,'INSERT','pedidos',10,NULL,NULL,'Order ID: WD1DW1, Cliente: AAAAA, Status: Pendente',NULL,NULL,NULL,'2025-11-13 23:38:07',1,NULL),(97,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas/detalhes/10','::1','Electron App','2025-11-13 23:38:07',1,NULL),(98,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas/galeria/10','::1','Electron App','2025-11-13 23:40:29',1,NULL),(99,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas/detalhes/10','::1','Electron App','2025-11-13 23:40:31',1,NULL),(100,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /vendas/upload-imagem/10','::1','Electron App','2025-11-13 23:40:34',1,NULL),(101,'root@localhost',NULL,NULL,'UPDATE','pedidos',10,'status','Pendente','Empacotado',NULL,NULL,NULL,'2025-11-13 23:40:34',1,NULL),(102,'root@localhost',NULL,NULL,'UPDATE','pedidos',10,'packed_at','NULL','2025-11-13 20:40:34',NULL,NULL,NULL,'2025-11-13 23:40:34',1,NULL),(103,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-13 23:40:34',1,NULL),(104,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas/detalhes/10','::1','Electron App','2025-11-13 23:40:37',1,NULL),(105,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-13 23:41:56',1,NULL),(106,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-14 16:14:51',1,NULL),(107,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /vendas/novo','::1','Electron App','2025-11-14 16:15:19',1,NULL),(108,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas/detalhes/11','::1','Electron App','2025-11-14 16:15:19',1,NULL),(109,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 16:57:41',1,NULL),(110,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-14 16:57:50',1,NULL),(111,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-14 16:57:51',1,NULL),(112,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-14 16:57:58',1,NULL),(113,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 16:58:01',1,NULL),(114,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-14 16:58:03',1,NULL),(115,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-14 16:58:04',1,NULL),(116,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 16:58:05',1,NULL),(117,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 17:00:11',1,NULL),(118,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 17:02:44',1,NULL),(119,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /login','::1','Electron App','2025-11-14 17:02:47',1,NULL),(120,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 17:03:34',1,NULL),(121,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-14 17:03:40',1,NULL),(122,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 17:03:44',1,NULL),(123,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-14 17:07:24',1,NULL),(124,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-14 17:09:02',1,NULL),(125,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 17:10:38',1,NULL),(126,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /login','::1','Electron App','2025-11-14 17:10:41',1,NULL),(127,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 17:12:13',1,NULL),(128,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-14 17:12:16',1,NULL),(129,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-14 17:12:18',1,NULL),(130,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /login','::1','Electron App','2025-11-14 17:12:21',1,NULL),(131,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 17:16:17',1,NULL),(132,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /login','::1','Electron App','2025-11-14 17:16:18',1,NULL),(133,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 17:50:57',1,NULL),(134,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 18:03:43',1,NULL),(135,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /login','::1','Electron App','2025-11-14 18:03:48',1,NULL),(136,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 18:05:56',1,NULL),(137,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 18:12:56',1,NULL),(138,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /login','::1','Electron App','2025-11-14 18:13:06',1,NULL),(139,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 18:31:17',1,NULL),(140,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-14 18:31:25',1,NULL),(141,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-14 18:31:26',1,NULL),(142,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 18:31:27',1,NULL),(143,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 18:32:35',1,NULL),(144,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-14 18:34:42',1,NULL),(145,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 18:34:50',1,NULL),(146,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 18:37:21',1,NULL),(147,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /login','::1','Electron App','2025-11-14 18:37:30',1,NULL),(148,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /login','::1','Electron App','2025-11-14 18:37:34',1,NULL),(149,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 18:38:20',1,NULL),(150,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 18:41:01',1,NULL),(151,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 18:42:01',1,NULL),(152,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 18:45:46',1,NULL),(153,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 18:46:16',1,NULL),(154,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 18:47:12',1,NULL),(155,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-14 18:47:18',1,NULL),(156,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /login','::1','Electron App','2025-11-14 18:47:20',1,NULL),(157,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 19:30:01',1,NULL),(158,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /login','::1','Electron App','2025-11-14 19:30:02',1,NULL),(159,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 19:51:46',1,NULL),(160,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 19:51:51',1,NULL),(161,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /login','::1','Electron App','2025-11-14 19:51:51',1,NULL),(162,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 20:02:33',1,NULL),(163,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-14 20:02:34',1,NULL),(164,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-14 20:02:35',1,NULL),(165,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 20:02:36',1,NULL),(166,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /login','::1','Electron App','2025-11-14 20:02:36',1,NULL),(167,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 20:04:42',1,NULL),(168,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 20:04:44',1,NULL),(169,'app',NULL,'System','ERROR',NULL,NULL,NULL,NULL,NULL,'Erro no servidor','127.0.0.1','Electron App','2025-11-14 20:04:44',0,'C:\\Users\\Windows\\SendRecord\\renderer\\views\\relatorios.ejs:14\n    12|     \r\n    13|     <div class=\"container\">\r\n >> 14|         <%- include(\'partials/sidebar\') %>\r\n    15|         \r\n    16|         <main class=\"main-content\">\r\n    17|             <div class=\"page-header\">\r\n\nCould not find the include file \"partials/sidebar\"'),(170,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 20:07:02',1,NULL),(171,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-14 20:07:04',1,NULL),(172,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 20:07:06',1,NULL),(173,'app',NULL,'System','ERROR',NULL,NULL,NULL,NULL,NULL,'Erro no servidor','127.0.0.1','Electron App','2025-11-14 20:07:06',0,'C:\\Users\\Windows\\SendRecord\\renderer\\views\\relatorios.ejs:14\n    12|     \r\n    13|     <div class=\"container\">\r\n >> 14|         <%- include(\'partials/sidebar\') %>\r\n    15|         \r\n    16|         <main class=\"main-content\">\r\n    17|             <div class=\"page-header\">\r\n\nCould not find the include file \"partials/sidebar\"'),(174,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 20:15:46',1,NULL),(175,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 20:15:47',1,NULL),(176,'app',NULL,'System','ERROR',NULL,NULL,NULL,NULL,NULL,'Erro no servidor','127.0.0.1','Electron App','2025-11-14 20:15:47',0,'C:\\Users\\Windows\\SendRecord\\renderer\\views\\relatorios.ejs:14\n    12|     \r\n    13|     <div class=\"container\">\r\n >> 14|         <%- include(\'partials/sidebar\') %>\r\n    15|         \r\n    16|         <main class=\"main-content\">\r\n    17|             <div class=\"page-header\">\r\n\nCould not find the include file \"partials/sidebar\"'),(177,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 20:18:56',1,NULL),(178,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-14 20:18:57',1,NULL),(179,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 20:18:58',1,NULL),(180,'app',NULL,'System','ERROR',NULL,NULL,NULL,NULL,NULL,'Erro no servidor','127.0.0.1','Electron App','2025-11-14 20:18:58',0,'C:\\Users\\Windows\\SendRecord\\renderer\\views\\relatorios.ejs:118\n    116|     </div>\r\n    117| \r\n >> 118|     <%- include(\'partials/footer\') %>\r\n    119|     \r\n    120|     <!-- JAVASCRIPT INLINE -->\r\n    121|     <script>\r\n\nCould not find the include file \"partials/footer\"'),(181,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 20:23:24',1,NULL),(182,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 20:23:25',1,NULL),(183,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 20:23:27',1,NULL),(184,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 20:23:27',1,NULL),(185,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 20:28:46',1,NULL),(186,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 20:28:47',1,NULL),(187,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 20:28:48',1,NULL),(188,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 20:28:49',1,NULL),(189,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-14 20:30:57',1,NULL),(190,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 20:30:59',1,NULL),(191,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 20:30:59',1,NULL),(192,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-14 20:31:06',1,NULL),(193,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 20:32:33',1,NULL),(194,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 20:32:33',1,NULL),(195,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-14 20:37:08',1,NULL),(196,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 20:40:57',1,NULL),(197,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 20:40:58',1,NULL),(198,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 20:40:58',1,NULL),(199,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-14 20:41:25',1,NULL),(200,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 20:41:25',1,NULL),(201,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 20:41:25',1,NULL),(202,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-14 20:44:33',1,NULL),(203,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 20:46:07',1,NULL),(204,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 20:46:07',1,NULL),(205,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 20:49:02',1,NULL),(206,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 20:49:03',1,NULL),(207,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 20:49:03',1,NULL),(208,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 20:51:10',1,NULL),(209,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 20:51:11',1,NULL),(210,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 20:51:11',1,NULL),(211,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/detalhes/11','::1','Electron App','2025-11-14 20:51:19',1,NULL),(212,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 20:56:37',1,NULL),(213,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 21:02:35',1,NULL),(214,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 21:02:36',1,NULL),(215,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 21:02:36',1,NULL),(216,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 21:04:16',1,NULL),(217,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 21:04:17',1,NULL),(218,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 21:04:17',1,NULL),(219,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 21:05:04',1,NULL),(220,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 21:05:05',1,NULL),(221,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 21:05:05',1,NULL),(222,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-14 21:06:02',1,NULL),(223,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-14 21:06:26',1,NULL),(224,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-14 21:06:29',1,NULL),(225,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 21:10:26',1,NULL),(226,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 21:10:27',1,NULL),(227,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 21:10:28',1,NULL),(228,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-14 21:10:37',1,NULL),(229,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 21:10:38',1,NULL),(230,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 21:10:38',1,NULL),(231,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-14 21:12:42',1,NULL),(232,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 21:12:44',1,NULL),(233,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 21:12:44',1,NULL),(234,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 21:14:58',1,NULL),(235,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-14 21:15:00',1,NULL),(236,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 21:15:03',1,NULL),(237,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 21:15:03',1,NULL),(238,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 21:15:12',1,NULL),(239,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/detalhes/5','::1','Electron App','2025-11-14 21:15:17',1,NULL),(240,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 21:18:25',1,NULL),(241,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 21:18:44',1,NULL),(242,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 21:18:44',1,NULL),(243,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 21:18:49',1,NULL),(244,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 21:20:39',1,NULL),(245,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 21:20:41',1,NULL),(246,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 21:20:41',1,NULL),(247,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 21:22:24',1,NULL),(248,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 21:22:25',1,NULL),(249,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 21:22:25',1,NULL),(250,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-14 21:23:01',1,NULL),(251,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 21:23:02',1,NULL),(252,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 21:23:02',1,NULL),(253,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-14 21:23:04',1,NULL),(254,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 21:23:07',1,NULL),(255,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 21:23:07',1,NULL),(256,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-14 21:27:09',1,NULL),(257,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 21:27:53',1,NULL),(258,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 21:27:53',1,NULL),(259,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-14 21:27:57',1,NULL),(260,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 21:27:59',1,NULL),(261,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 21:27:59',1,NULL),(262,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-14 21:28:04',1,NULL),(263,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 21:28:05',1,NULL),(264,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-14 21:28:05',1,NULL),(265,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 21:28:07',1,NULL),(266,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 21:28:07',1,NULL),(267,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 21:28:18',1,NULL),(268,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 21:29:18',1,NULL),(269,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 21:29:20',1,NULL),(270,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 21:29:20',1,NULL),(271,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-14 21:29:22',1,NULL),(272,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 21:29:23',1,NULL),(273,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 21:29:23',1,NULL),(274,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 21:31:36',1,NULL),(275,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 21:31:37',1,NULL),(276,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 21:31:37',1,NULL),(277,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-14 21:31:40',1,NULL),(278,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 21:37:04',1,NULL),(279,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 21:37:05',1,NULL),(280,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 21:37:07',1,NULL),(281,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-14 21:37:12',1,NULL),(282,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 21:38:33',1,NULL),(283,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 21:38:34',1,NULL),(284,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 21:38:35',1,NULL),(285,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 21:39:06',1,NULL),(286,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 21:40:37',1,NULL),(287,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 21:40:37',1,NULL),(288,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 21:40:38',1,NULL),(289,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 21:41:11',1,NULL),(290,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 21:41:14',1,NULL),(291,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 21:41:15',1,NULL),(292,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-14 21:41:17',1,NULL),(293,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 21:41:18',1,NULL),(294,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 21:41:18',1,NULL),(295,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 21:41:19',1,NULL),(296,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-14 21:41:20',1,NULL),(297,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-14 21:41:25',1,NULL),(298,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 21:41:26',1,NULL),(299,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 21:41:27',1,NULL),(300,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 21:41:27',1,NULL),(301,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 21:41:28',1,NULL),(302,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 21:41:29',1,NULL),(303,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 21:41:29',1,NULL),(304,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 21:41:30',1,NULL),(305,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 21:41:32',1,NULL),(306,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 21:41:32',1,NULL),(307,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-14 21:41:33',1,NULL),(308,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-14 21:41:34',1,NULL),(309,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 21:41:34',1,NULL),(310,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-14 21:41:36',1,NULL),(311,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 21:41:39',1,NULL),(312,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 21:41:42',1,NULL),(313,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-14 21:41:48',1,NULL),(314,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 21:41:49',1,NULL),(315,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 21:41:49',1,NULL),(316,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 21:41:50',1,NULL),(317,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-14 21:41:52',1,NULL),(318,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 21:41:53',1,NULL),(319,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 21:41:59',1,NULL),(320,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-14 21:42:01',1,NULL),(321,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 21:42:02',1,NULL),(322,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 21:42:02',1,NULL),(323,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-14 21:42:04',1,NULL),(324,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 23:37:30',1,NULL),(325,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-14 23:37:36',1,NULL),(326,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 23:37:50',1,NULL),(327,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 23:47:08',1,NULL),(328,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 23:47:09',1,NULL),(329,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 23:47:09',1,NULL),(330,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-14 23:47:23',1,NULL),(331,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 23:47:25',1,NULL),(332,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 23:47:25',1,NULL),(333,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-14 23:47:26',1,NULL),(334,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /vendas/novo','::1','Electron App','2025-11-14 23:48:33',1,NULL),(335,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas/detalhes/12','::1','Electron App','2025-11-14 23:48:33',1,NULL),(336,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-14 23:48:45',1,NULL),(337,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 23:48:47',1,NULL),(338,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 23:48:47',1,NULL),(339,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 23:48:50',1,NULL),(340,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-14 23:49:21',1,NULL),(341,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-14 23:49:22',1,NULL),(342,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 23:49:23',1,NULL),(343,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 23:49:23',1,NULL),(344,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-14 23:49:24',1,NULL),(345,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-14 23:49:26',1,NULL),(346,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-14 23:49:26',1,NULL),(347,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-14 23:49:31',1,NULL),(348,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 00:45:27',1,NULL),(349,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 00:46:18',1,NULL),(350,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas/detalhes/6','::1','Electron App','2025-11-15 00:46:31',1,NULL),(351,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /vendas/upload-imagem/6','::1','Electron App','2025-11-15 00:46:44',1,NULL),(352,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 00:46:44',1,NULL),(353,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 00:46:48',1,NULL),(354,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-15 00:46:49',1,NULL),(355,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 00:47:08',1,NULL),(356,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/editar/5','::1','Electron App','2025-11-15 00:47:13',1,NULL),(357,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /config/editar/5','::1','Electron App','2025-11-15 00:47:18',1,NULL),(358,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/editar/5','::1','Electron App','2025-11-15 00:47:18',1,NULL),(359,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 00:47:26',1,NULL),(360,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-15 00:47:27',1,NULL),(361,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 00:47:28',1,NULL),(362,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 00:47:30',1,NULL),(363,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-15 00:47:30',1,NULL),(364,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 00:47:31',1,NULL),(365,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/editar/1','::1','Electron App','2025-11-15 00:47:34',1,NULL),(366,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 00:47:35',1,NULL),(367,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 00:47:50',1,NULL),(368,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 00:47:54',1,NULL),(369,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-15 00:47:54',1,NULL),(370,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 00:47:58',1,NULL),(371,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 00:48:16',1,NULL),(372,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 00:48:17',1,NULL),(373,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 00:48:18',1,NULL),(374,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-15 00:48:18',1,NULL),(375,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 00:48:22',1,NULL),(376,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 00:48:22',1,NULL),(377,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 00:48:23',1,NULL),(378,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 00:48:24',1,NULL),(379,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-15 00:48:24',1,NULL),(380,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 00:48:24',1,NULL),(381,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 00:48:25',1,NULL),(382,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 00:48:26',1,NULL),(383,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 00:48:29',1,NULL),(384,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-15 00:48:29',1,NULL),(385,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 00:48:33',1,NULL),(386,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 00:48:35',1,NULL),(387,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 00:48:41',1,NULL),(388,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 00:48:42',1,NULL),(389,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-15 00:48:42',1,NULL),(390,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 00:48:43',1,NULL),(391,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 00:48:44',1,NULL),(392,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-15 00:48:44',1,NULL),(393,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 00:48:48',1,NULL),(394,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 00:48:49',1,NULL),(395,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 00:48:50',1,NULL),(396,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 00:49:10',1,NULL),(397,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 00:49:11',1,NULL),(398,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-15 00:49:11',1,NULL),(399,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 00:49:14',1,NULL),(400,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 00:49:16',1,NULL),(401,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-15 00:49:16',1,NULL),(402,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 00:49:17',1,NULL),(403,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 00:49:18',1,NULL),(404,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 00:49:20',1,NULL),(405,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 00:49:24',1,NULL),(406,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-15 00:49:24',1,NULL),(407,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 00:49:26',1,NULL),(408,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 00:49:27',1,NULL),(409,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 00:49:30',1,NULL),(410,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-15 00:49:30',1,NULL),(411,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 00:49:31',1,NULL),(412,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 00:49:31',1,NULL),(413,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 00:49:32',1,NULL),(414,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-15 00:49:32',1,NULL),(415,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 00:49:33',1,NULL),(416,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 00:49:34',1,NULL),(417,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 00:49:38',1,NULL),(418,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 00:49:46',1,NULL),(419,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-15 00:49:46',1,NULL),(420,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 00:49:47',1,NULL),(421,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 00:49:48',1,NULL),(422,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-15 00:49:48',1,NULL),(423,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 00:49:49',1,NULL),(424,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 00:49:49',1,NULL),(425,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 00:49:50',1,NULL),(426,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 00:49:51',1,NULL),(427,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-15 00:49:51',1,NULL),(428,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 00:49:53',1,NULL),(429,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 00:49:54',1,NULL),(430,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-15 00:49:54',1,NULL),(431,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 00:49:55',1,NULL),(432,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 00:49:57',1,NULL),(433,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-15 00:50:19',1,NULL),(434,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 00:52:09',1,NULL),(435,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 00:52:11',1,NULL),(436,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-15 00:52:11',1,NULL),(437,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-15 00:52:37',1,NULL),(438,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 00:59:18',1,NULL),(439,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 01:00:20',1,NULL),(440,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/editar/1','::1','Electron App','2025-11-15 01:00:23',1,NULL),(441,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 01:00:24',1,NULL),(442,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/editar/6','::1','Electron App','2025-11-15 01:00:25',1,NULL),(443,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /config/editar/6','::1','Electron App','2025-11-15 01:00:31',1,NULL),(444,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/editar/6','::1','Electron App','2025-11-15 01:00:31',1,NULL),(445,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 01:06:24',1,NULL),(446,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 01:06:26',1,NULL),(447,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/editar/6','::1','Electron App','2025-11-15 01:06:27',1,NULL),(448,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /config/editar/6','::1','Electron App','2025-11-15 01:06:31',1,NULL),(449,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/editar/6','::1','Electron App','2025-11-15 01:06:31',1,NULL),(450,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 01:08:29',1,NULL),(451,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 01:08:30',1,NULL),(452,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/editar/6','::1','Electron App','2025-11-15 01:08:34',1,NULL),(453,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /config/editar/6','::1','Electron App','2025-11-15 01:08:38',1,NULL),(454,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/editar/6','::1','Electron App','2025-11-15 01:08:38',1,NULL),(455,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 01:12:34',1,NULL),(456,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 01:12:35',1,NULL),(457,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/editar/6','::1','Electron App','2025-11-15 01:12:38',1,NULL),(458,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /config/editar/6','::1','Electron App','2025-11-15 01:12:43',1,NULL),(459,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/editar/6','::1','Electron App','2025-11-15 01:12:43',1,NULL),(460,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 01:16:43',1,NULL),(461,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 01:16:45',1,NULL),(462,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/editar/4','::1','Electron App','2025-11-15 01:16:47',1,NULL),(463,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /config/editar/4','::1','Electron App','2025-11-15 01:16:51',1,NULL),(464,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 01:16:51',1,NULL),(465,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/novo','::1','Electron App','2025-11-15 01:16:57',1,NULL),(466,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /config/criar','::1','Electron App','2025-11-15 01:17:32',1,NULL),(467,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 01:17:32',1,NULL),(468,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-15 01:18:32',1,NULL),(469,'app',9,'maria Luiza','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 01:18:37',1,NULL),(470,'app',9,'maria Luiza','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 01:18:38',1,NULL),(471,'app',9,'maria Luiza','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-15 01:18:40',1,NULL),(472,'app',9,'maria Luiza','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 01:19:15',1,NULL),(473,'app',9,'maria Luiza','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 01:19:20',1,NULL),(474,'app',9,'maria Luiza','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas/detalhes/11','::1','Electron App','2025-11-15 01:20:01',1,NULL),(475,'app',9,'maria Luiza','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 01:20:03',1,NULL),(476,'app',9,'maria Luiza','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas/detalhes/11','::1','Electron App','2025-11-15 01:20:08',1,NULL),(477,'app',9,'maria Luiza','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /vendas/upload-imagem/11','::1','Electron App','2025-11-15 01:20:17',1,NULL),(478,'app',9,'maria Luiza','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 01:20:17',1,NULL),(479,'app',9,'maria Luiza','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-15 01:20:27',1,NULL),(480,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 01:20:38',1,NULL),(481,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 01:20:41',1,NULL),(482,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 01:20:42',1,NULL),(483,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 01:20:43',1,NULL),(484,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 01:20:44',1,NULL),(485,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 01:20:45',1,NULL),(486,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 01:20:46',1,NULL),(487,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 01:20:47',1,NULL),(488,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 01:20:47',1,NULL),(489,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 01:20:47',1,NULL),(490,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 01:20:48',1,NULL),(491,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 01:20:49',1,NULL),(492,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 01:20:50',1,NULL),(493,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 01:20:50',1,NULL),(494,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 01:20:50',1,NULL),(495,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 01:20:51',1,NULL),(496,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 01:20:52',1,NULL),(497,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 01:20:54',1,NULL),(498,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 01:20:54',1,NULL),(499,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 01:20:54',1,NULL),(500,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 01:20:55',1,NULL),(501,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 01:20:55',1,NULL),(502,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 01:20:55',1,NULL),(503,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 01:20:55',1,NULL),(504,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 01:20:55',1,NULL),(505,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 01:20:56',1,NULL),(506,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 01:20:57',1,NULL),(507,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 01:20:58',1,NULL),(508,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 01:21:57',1,NULL),(509,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 01:21:58',1,NULL),(510,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-15 01:21:58',1,NULL),(511,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 01:22:31',1,NULL),(512,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas/detalhes/12','::1','Electron App','2025-11-15 01:22:33',1,NULL),(513,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 01:23:10',1,NULL),(514,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 01:23:12',1,NULL),(515,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 01:23:13',1,NULL),(516,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 01:23:14',1,NULL),(517,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-15 01:23:14',1,NULL),(518,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 01:23:18',1,NULL),(519,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 01:23:19',1,NULL),(520,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 01:23:20',1,NULL),(521,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-15 01:23:20',1,NULL),(522,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 01:23:22',1,NULL),(523,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 01:23:23',1,NULL),(524,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 01:23:24',1,NULL),(525,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 01:23:27',1,NULL),(526,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-15 01:23:27',1,NULL),(527,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 01:27:22',1,NULL),(528,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 01:27:23',1,NULL),(529,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/editar/1','::1','Electron App','2025-11-15 01:27:25',1,NULL),(530,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /config/editar/1','::1','Electron App','2025-11-15 01:27:31',1,NULL),(531,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 01:27:31',1,NULL),(532,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/editar/6','::1','Electron App','2025-11-15 01:27:41',1,NULL),(533,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /config/editar/6','::1','Electron App','2025-11-15 01:27:44',1,NULL),(534,'app',1,'Administrador Sistema','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 01:27:44',1,NULL),(535,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 01:29:05',1,NULL),(536,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 01:29:06',1,NULL),(537,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/editar/4','::1','Electron App','2025-11-15 01:29:11',1,NULL),(538,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /config/editar/4','::1','Electron App','2025-11-15 01:29:15',1,NULL),(539,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 01:29:16',1,NULL),(540,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 01:32:48',1,NULL),(541,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-15 01:33:40',1,NULL),(542,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 01:34:47',1,NULL),(543,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 01:34:49',1,NULL),(544,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas/detalhes/12','::1','Electron App','2025-11-15 01:34:53',1,NULL),(545,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /vendas/upload-imagem/12','::1','Electron App','2025-11-15 01:35:19',1,NULL),(546,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 01:35:19',1,NULL),(547,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 01:35:27',1,NULL),(548,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-15 01:35:27',1,NULL),(549,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 01:35:37',1,NULL),(550,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-15 01:35:59',1,NULL),(551,'app',8,'fernando','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 01:36:04',1,NULL),(552,'app',8,'fernando','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 01:36:05',1,NULL),(553,'app',8,'fernando','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-15 01:36:52',1,NULL),(554,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 01:37:03',1,NULL),(555,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 01:37:04',1,NULL),(556,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/editar/9','::1','Electron App','2025-11-15 01:37:12',1,NULL),(557,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /config/editar/9','::1','Electron App','2025-11-15 01:37:27',1,NULL),(558,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 01:37:27',1,NULL),(559,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 01:37:43',1,NULL),(560,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 01:37:44',1,NULL),(561,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 01:37:45',1,NULL),(562,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-15 01:37:45',1,NULL),(563,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 01:37:46',1,NULL),(564,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-15 01:37:50',1,NULL),(565,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 01:46:21',1,NULL),(566,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 01:46:23',1,NULL),(567,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/editar/8','::1','Electron App','2025-11-15 01:46:25',1,NULL),(568,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 01:46:36',1,NULL),(569,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/editar/3','::1','Electron App','2025-11-15 01:47:30',1,NULL),(570,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 01:47:32',1,NULL),(571,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/novo','::1','Electron App','2025-11-15 01:47:33',1,NULL),(572,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 01:47:39',1,NULL),(573,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 01:47:41',1,NULL),(574,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 01:47:42',1,NULL),(575,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-15 01:47:43',1,NULL),(576,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 01:49:28',1,NULL),(577,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 01:49:30',1,NULL),(578,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-15 01:49:30',1,NULL),(579,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-15 01:49:39',1,NULL),(580,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 01:49:57',1,NULL),(581,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 01:49:58',1,NULL),(582,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-15 01:49:59',1,NULL),(583,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-15 01:51:05',1,NULL),(584,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 01:51:14',1,NULL),(585,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 01:51:15',1,NULL),(586,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-15 01:51:15',1,NULL),(587,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 01:56:42',1,NULL),(588,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 01:56:43',1,NULL),(589,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-15 01:56:43',1,NULL),(590,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 01:59:13',1,NULL),(591,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 01:59:15',1,NULL),(592,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-15 01:59:15',1,NULL),(593,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/detalhes/12','::1','Electron App','2025-11-15 01:59:32',1,NULL),(594,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 02:05:58',1,NULL),(595,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 02:06:00',1,NULL),(596,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 02:06:03',1,NULL),(597,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-15 02:06:03',1,NULL),(598,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/detalhes/5','::1','Electron App','2025-11-15 02:06:13',1,NULL),(599,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-15 02:08:36',1,NULL),(600,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-15 02:10:13',1,NULL),(601,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 02:10:28',1,NULL),(602,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 02:10:29',1,NULL),(603,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-15 02:10:29',1,NULL),(604,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/detalhes/2','::1','Electron App','2025-11-15 02:10:39',1,NULL),(605,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 02:13:09',1,NULL),(606,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 02:13:11',1,NULL),(607,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 02:13:12',1,NULL),(608,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-15 02:13:12',1,NULL),(609,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 02:16:11',1,NULL),(610,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 02:16:13',1,NULL),(611,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-15 02:16:13',1,NULL),(612,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 02:19:01',1,NULL),(613,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios','::1','Electron App','2025-11-15 02:19:02',1,NULL),(614,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /relatorios/dados','::1','Electron App','2025-11-15 02:19:02',1,NULL),(615,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 02:24:42',1,NULL),(616,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 02:24:46',1,NULL),(617,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/editar/3','::1','Electron App','2025-11-15 02:24:48',1,NULL),(618,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 02:24:58',1,NULL),(619,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/editar/8','::1','Electron App','2025-11-15 02:25:06',1,NULL),(620,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /config/editar/8','::1','Electron App','2025-11-15 02:25:15',1,NULL),(621,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 02:25:15',1,NULL),(622,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-15 02:25:16',1,NULL),(623,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 02:25:57',1,NULL),(624,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 02:25:59',1,NULL),(625,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/editar/8','::1','Electron App','2025-11-15 02:26:02',1,NULL),(626,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /config/editar/8','::1','Electron App','2025-11-15 02:26:06',1,NULL),(627,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 02:26:06',1,NULL),(628,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-15 02:26:08',1,NULL),(629,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 02:27:05',1,NULL),(630,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 02:27:07',1,NULL),(631,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/editar/8','::1','Electron App','2025-11-15 02:27:11',1,NULL),(632,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /config/editar/8','::1','Electron App','2025-11-15 02:27:19',1,NULL),(633,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 02:27:20',1,NULL),(634,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-15 02:27:22',1,NULL),(635,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 02:28:38',1,NULL),(636,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 02:28:40',1,NULL),(637,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/editar/9','::1','Electron App','2025-11-15 02:28:42',1,NULL),(638,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /config/editar/9','::1','Electron App','2025-11-15 02:28:49',1,NULL),(639,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 02:28:49',1,NULL),(640,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-15 02:28:50',1,NULL),(641,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 02:29:04',1,NULL),(642,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 02:29:05',1,NULL),(643,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/editar/9','::1','Electron App','2025-11-15 02:29:08',1,NULL),(644,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /config/editar/9','::1','Electron App','2025-11-15 02:29:14',1,NULL),(645,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 02:29:14',1,NULL),(646,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-15 02:29:17',1,NULL),(647,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 02:36:05',1,NULL),(648,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 02:36:07',1,NULL),(649,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/editar/8','::1','Electron App','2025-11-15 02:36:10',1,NULL),(650,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /config/editar/8','::1','Electron App','2025-11-15 02:36:16',1,NULL),(651,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 02:36:16',1,NULL),(652,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/editar/1','::1','Electron App','2025-11-15 02:36:17',1,NULL),(653,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /config/editar/1','::1','Electron App','2025-11-15 02:36:30',1,NULL),(654,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 02:36:31',1,NULL),(655,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-15 02:36:32',1,NULL),(656,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 02:36:54',1,NULL),(657,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-15 02:37:00',1,NULL),(658,'app',8,'fernando','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 02:37:07',1,NULL),(659,'app',8,'fernando','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-15 02:38:43',1,NULL),(660,'app',8,'fernando','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 02:38:56',1,NULL),(661,'app',8,'fernando','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-15 02:39:06',1,NULL),(662,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 02:39:15',1,NULL),(663,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-15 02:39:16',1,NULL),(664,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 02:39:25',1,NULL),(665,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 02:39:27',1,NULL),(666,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/editar/8','::1','Electron App','2025-11-15 02:39:34',1,NULL),(667,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /config/editar/8','::1','Electron App','2025-11-15 02:39:38',1,NULL),(668,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 02:39:38',1,NULL),(669,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-15 02:39:40',1,NULL),(670,'app',8,'fernando','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 02:39:46',1,NULL),(671,'app',8,'fernando','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 02:42:26',1,NULL),(672,'app',8,'fernando','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 02:42:27',1,NULL),(673,'app',8,'fernando','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/editar/8','::1','Electron App','2025-11-15 02:42:32',1,NULL),(674,'app',8,'fernando','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /config/editar/8','::1','Electron App','2025-11-15 02:42:36',1,NULL),(675,'app',8,'fernando','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 02:42:36',1,NULL),(676,'app',8,'fernando','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-15 02:42:38',1,NULL),(677,'app',8,'fernando','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 02:42:44',1,NULL),(678,'app',8,'fernando','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-15 02:42:45',1,NULL),(679,'app',8,'fernando','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-15 02:42:48',1,NULL),(680,'app',8,'fernando','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 02:58:25',1,NULL),(681,'app',8,'fernando','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 02:58:27',1,NULL),(682,'app',8,'fernando','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas/detalhes/9','::1','Electron App','2025-11-15 02:58:28',1,NULL),(683,'app',8,'fernando','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /vendas/upload-imagem/9','::1','Electron App','2025-11-15 02:58:33',1,NULL),(684,'app',8,'fernando','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 02:58:33',1,NULL),(685,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-15 14:53:23',1,NULL),(686,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 14:53:24',1,NULL),(687,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas/detalhes/8','::1','Electron App','2025-11-15 14:53:26',1,NULL),(688,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas/galeria/8','::1','Electron App','2025-11-15 14:53:27',1,NULL),(689,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas/detalhes/8','::1','Electron App','2025-11-15 14:53:29',1,NULL),(690,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /vendas/upload-imagem/8','::1','Electron App','2025-11-15 14:53:54',1,NULL),(691,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-15 14:53:54',1,NULL),(692,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-22 01:19:39',1,NULL),(693,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-22 01:28:06',1,NULL),(694,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-22 01:28:07',1,NULL),(695,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/editar/5','::1','Electron App','2025-11-22 01:31:31',1,NULL),(696,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /config/editar/5','::1','Electron App','2025-11-22 01:31:43',1,NULL),(697,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-22 01:31:43',1,NULL),(698,'app',1,'Admin','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-22 01:31:44',1,NULL),(699,'app',5,'Ana Costa','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-22 01:31:53',1,NULL),(700,'app',5,'Ana Costa','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-22 01:31:54',1,NULL),(701,'app',5,'Ana Costa','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/editar/2','::1','Electron App','2025-11-22 01:32:18',1,NULL),(702,'app',5,'Ana Costa','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /config/editar/2','::1','Electron App','2025-11-22 01:32:24',1,NULL),(703,'app',5,'Ana Costa','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-22 01:32:24',1,NULL),(704,'app',5,'Ana Costa','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/editar/8','::1','Electron App','2025-11-22 01:32:31',1,NULL),(705,'app',5,'Ana Costa','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /config/editar/8','::1','Electron App','2025-11-22 01:32:33',1,NULL),(706,'app',5,'Ana Costa','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-22 01:32:33',1,NULL),(707,'app',5,'Ana Costa','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/editar/7','::1','Electron App','2025-11-22 01:32:39',1,NULL),(708,'app',5,'Ana Costa','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /config/editar/7','::1','Electron App','2025-11-22 01:32:42',1,NULL),(709,'app',5,'Ana Costa','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-22 01:32:42',1,NULL),(710,'app',5,'Ana Costa','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-22 01:32:43',1,NULL),(711,'app',5,'Ana Costa','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-22 01:39:56',1,NULL),(712,'app',5,'Ana Costa','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-22 01:39:57',1,NULL),(713,'app',5,'Ana Costa','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/novo','::1','Electron App','2025-11-22 01:39:58',1,NULL),(714,'app',5,'Ana Costa','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /config/criar','::1','Electron App','2025-11-22 01:40:29',1,NULL),(715,'app',5,'Ana Costa','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-22 01:40:29',1,NULL),(716,'app',5,'Ana Costa','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /home','::1','Electron App','2025-11-22 01:42:34',1,NULL),(717,'app',5,'Ana Costa','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-22 01:42:35',1,NULL),(718,'app',5,'Ana Costa','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config/editar/10','::1','Electron App','2025-11-22 01:42:41',1,NULL),(719,'app',5,'Ana Costa','SELECT',NULL,NULL,NULL,NULL,NULL,'POST /config/editar/10','::1','Electron App','2025-11-22 01:42:47',1,NULL),(720,'app',5,'Ana Costa','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /config','::1','Electron App','2025-11-22 01:42:47',1,NULL),(721,'app',5,'Ana Costa','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /vendas','::1','Electron App','2025-11-22 01:46:54',1,NULL),(722,'app',5,'Ana Costa','SELECT',NULL,NULL,NULL,NULL,NULL,'GET /logout','::1','Electron App','2025-11-22 01:47:00',1,NULL);
/*!40000 ALTER TABLE `logs_sistema` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidos`
--

DROP TABLE IF EXISTS `pedidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` varchar(100) NOT NULL,
  `source` enum('Wix','Mercado_Livre','Manual','Outro') NOT NULL,
  `cliente_id` int NOT NULL,
  `customer_name` varchar(150) NOT NULL,
  `item_count` int DEFAULT '0',
  `valor_total` decimal(10,2) DEFAULT '0.00',
  `peso_total_esperado` int DEFAULT NULL,
  `peso_total_real` int DEFAULT NULL,
  `status` enum('Pendente','Em_Separacao','Empacotado','Erro','Cancelado') DEFAULT 'Pendente',
  `usuario_criacao_id` int DEFAULT NULL,
  `usuario_empacotamento_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `packed_at` timestamp NULL DEFAULT NULL,
  `observacoes` text,
  `data_exibicao` varchar(10) GENERATED ALWAYS AS (date_format(`created_at`,_utf8mb4'%d/%m/%Y')) STORED,
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_id` (`order_id`),
  KEY `cliente_id` (`cliente_id`),
  KEY `usuario_criacao_id` (`usuario_criacao_id`),
  KEY `usuario_empacotamento_id` (`usuario_empacotamento_id`),
  KEY `idx_order_id` (`order_id`),
  KEY `idx_status` (`status`),
  KEY `idx_source` (`source`),
  KEY `idx_created_at` (`created_at`),
  CONSTRAINT `pedidos_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`),
  CONSTRAINT `pedidos_ibfk_2` FOREIGN KEY (`usuario_criacao_id`) REFERENCES `usuarios` (`id`),
  CONSTRAINT `pedidos_ibfk_3` FOREIGN KEY (`usuario_empacotamento_id`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos`
--

LOCK TABLES `pedidos` WRITE;
/*!40000 ALTER TABLE `pedidos` DISABLE KEYS */;
INSERT INTO `pedidos` (`id`, `order_id`, `source`, `cliente_id`, `customer_name`, `item_count`, `valor_total`, `peso_total_esperado`, `peso_total_real`, `status`, `usuario_criacao_id`, `usuario_empacotamento_id`, `created_at`, `packed_at`, `observacoes`) VALUES (1,'WIX-20251001','Wix',1,'Roberto Mendes',3,569.70,840,NULL,'Empacotado',2,1,'2025-10-13 11:30:00','2025-11-10 22:56:03',NULL),(2,'ML-789456123','Mercado_Livre',2,'Empresa XYZ Ltda',10,1899.00,2800,NULL,'Empacotado',2,2,'2025-10-13 12:15:00','2025-11-11 01:08:28',NULL),(3,'WIX-20251002','Wix',3,'Patricia Lima',2,379.80,560,NULL,'Em_Separacao',2,NULL,'2025-10-13 13:00:00',NULL,NULL),(4,'ML-456789012','Mercado_Livre',4,'Loja ABC Comercio',15,2698.50,4200,NULL,'Empacotado',2,NULL,'2025-10-12 17:20:00',NULL,NULL),(5,'WIX-20251003','Wix',5,'Fernando Rodrigues',4,759.60,1120,NULL,'Empacotado',2,1,'2025-10-13 14:30:00','2025-11-12 23:08:13',NULL),(6,'50','Manual',8,'jota',0,0.00,NULL,NULL,'Empacotado',1,1,'2025-11-12 23:02:00','2025-11-15 00:46:44','oii'),(7,'100','Manual',9,'LUIS',0,0.00,NULL,NULL,'Pendente',1,NULL,'2025-11-12 23:09:44',NULL,'WDAWD'),(8,'123','Manual',10,'MIGUEL VITOR',0,0.00,NULL,NULL,'Empacotado',1,1,'2025-11-13 23:26:15','2025-11-15 14:53:54',NULL),(9,'1233','Manual',11,'MARIO',0,0.00,NULL,NULL,'Empacotado',1,8,'2025-11-13 23:35:49','2025-11-15 02:58:33',NULL),(10,'WD1DW1','Manual',12,'AAAAA',0,0.00,NULL,NULL,'Empacotado',1,1,'2025-11-13 23:38:07','2025-11-13 23:40:34',NULL),(11,'123456','Manual',9,'luis',0,0.00,NULL,NULL,'Empacotado',1,9,'2025-11-14 16:15:19','2025-11-15 01:20:17',NULL),(12,'2542432','Mercado_Livre',13,'luci',0,0.00,NULL,NULL,'Empacotado',1,1,'2025-11-14 23:48:33','2025-11-15 01:35:19',NULL),(13,'WIX-20251121-001','Wix',14,'Lucas Pereira',3,569.70,NULL,NULL,'Pendente',1,NULL,'2025-11-22 01:45:44',NULL,'Pedido urgente'),(14,'WIX-20251121-002','Wix',15,'Maria Fernanda',2,379.80,NULL,NULL,'Pendente',1,NULL,'2025-11-22 01:45:44',NULL,NULL),(15,'ML-20251121-001','Mercado_Livre',16,'Tech Solutions Ltda',10,1899.00,NULL,NULL,'Pendente',1,NULL,'2025-11-22 01:45:44',NULL,'Cliente VIP'),(16,'MANUAL-001','Manual',17,'João Carlos',1,189.90,NULL,NULL,'Pendente',1,NULL,'2025-11-22 01:45:44',NULL,'Retirada na loja'),(17,'ML-20251121-002','Mercado_Livre',18,'Loja Express',5,949.50,NULL,NULL,'Pendente',1,NULL,'2025-11-22 01:45:44',NULL,NULL),(18,'WIX-20251121-003','Wix',14,'Lucas Pereira',4,759.60,NULL,NULL,'Em_Separacao',1,NULL,'2025-11-22 01:45:44',NULL,NULL),(19,'MANUAL-002','Manual',15,'Maria Fernanda',2,339.80,NULL,NULL,'Pendente',1,NULL,'2025-11-22 01:45:44',NULL,'Presente - embalar com cuidado'),(20,'WIX-20251121-010','Wix',1,'Roberto Mendes',3,569.70,NULL,NULL,'Pendente',1,NULL,'2025-11-21 23:46:49',NULL,'Pedido urgente'),(21,'ML-20251121-011','Mercado_Livre',2,'Empresa XYZ Ltda',5,949.50,NULL,NULL,'Pendente',1,NULL,'2025-11-21 22:46:49',NULL,NULL),(22,'WIX-20251121-012','Wix',3,'Patricia Lima',2,379.80,NULL,NULL,'Pendente',2,NULL,'2025-11-21 21:46:49',NULL,'Cliente frequente'),(23,'ML-20251121-013','Mercado_Livre',4,'Loja ABC Comercio',8,1519.20,NULL,NULL,'Em_Separacao',2,NULL,'2025-11-21 20:46:49',NULL,NULL),(24,'MANUAL-020','Manual',5,'Fernando Rodrigues',1,189.90,NULL,NULL,'Pendente',2,NULL,'2025-11-21 19:46:49',NULL,'Retirada na loja'),(25,'WIX-20251121-014','Wix',6,'Marcos Augusto',4,759.60,NULL,NULL,'Pendente',3,NULL,'2025-11-21 18:46:49',NULL,NULL),(26,'ML-20251121-015','Mercado_Livre',7,'Distribuidora MegaStore',15,2848.50,NULL,NULL,'Pendente',3,NULL,'2025-11-21 17:46:49',NULL,'Pedido grande - verificar estoque'),(27,'WIX-20251121-016','Wix',1,'Roberto Mendes',2,379.80,NULL,NULL,'Pendente',4,NULL,'2025-11-21 16:46:49',NULL,NULL),(28,'MANUAL-021','Manual',3,'Patricia Lima',3,569.70,NULL,NULL,'Em_Separacao',4,NULL,'2025-11-21 15:46:49',NULL,'Presente - embalar bonito'),(29,'ML-20251121-017','Mercado_Livre',2,'Empresa XYZ Ltda',6,1139.40,NULL,NULL,'Pendente',5,NULL,'2025-11-21 14:46:49',NULL,'Cliente VIP'),(30,'WIX-20251121-018','Wix',4,'Loja ABC Comercio',10,1899.00,NULL,NULL,'Pendente',5,NULL,'2025-11-21 13:46:49',NULL,NULL),(31,'MANUAL-022','Manual',5,'Fernando Rodrigues',2,379.80,NULL,NULL,'Pendente',5,NULL,'2025-11-21 12:46:49',NULL,NULL),(32,'WIX-20251121-019','Wix',6,'Marcos Augusto',1,189.90,NULL,NULL,'Pendente',6,NULL,'2025-11-21 11:46:49',NULL,'Entrega expressa'),(33,'ML-20251121-020','Mercado_Livre',7,'Distribuidora MegaStore',12,2278.80,NULL,NULL,'Pendente',6,NULL,'2025-11-21 10:46:49',NULL,NULL),(34,'WIX-20251121-021','Wix',1,'Roberto Mendes',5,949.50,NULL,NULL,'Pendente',7,NULL,'2025-11-21 09:46:49',NULL,NULL),(35,'MANUAL-023','Manual',2,'Empresa XYZ Ltda',3,569.70,NULL,NULL,'Em_Separacao',7,NULL,'2025-11-21 08:46:49',NULL,'Nota fiscal separada'),(36,'ML-20251121-022','Mercado_Livre',3,'Patricia Lima',4,759.60,NULL,NULL,'Pendente',8,NULL,'2025-11-21 07:46:49',NULL,NULL),(37,'WIX-20251121-023','Wix',4,'Loja ABC Comercio',7,1329.30,NULL,NULL,'Pendente',8,NULL,'2025-11-21 06:46:49',NULL,'Segunda compra do mês'),(38,'ML-20251121-024','Mercado_Livre',5,'Fernando Rodrigues',2,379.80,NULL,NULL,'Pendente',9,NULL,'2025-11-21 05:46:49',NULL,NULL),(39,'WIX-20251121-025','Wix',6,'Marcos Augusto',6,1139.40,NULL,NULL,'Pendente',9,NULL,'2025-11-21 04:46:49',NULL,'Verificar endereço');
/*!40000 ALTER TABLE `pedidos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produtos`
--

DROP TABLE IF EXISTS `produtos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produtos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `sku` varchar(50) NOT NULL,
  `barcode` varchar(50) DEFAULT NULL,
  `nome` varchar(200) NOT NULL,
  `descricao` text,
  `tipo_camisa_id` int NOT NULL,
  `tecido` varchar(100) DEFAULT NULL,
  `estampa` varchar(100) DEFAULT NULL,
  `gola` varchar(50) DEFAULT NULL,
  `bolso` tinyint(1) DEFAULT '0',
  `preco_custo` decimal(10,2) DEFAULT NULL,
  `preco_venda` decimal(10,2) NOT NULL,
  `peso_gramas` int DEFAULT NULL,
  `estoque_atual` int DEFAULT '0',
  `estoque_minimo` int DEFAULT '5',
  `ativo` tinyint(1) DEFAULT '1',
  `data_cadastro` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sku` (`sku`),
  UNIQUE KEY `barcode` (`barcode`),
  KEY `idx_sku` (`sku`),
  KEY `idx_barcode` (`barcode`),
  KEY `idx_nome` (`nome`),
  KEY `idx_tipo` (`tipo_camisa_id`),
  CONSTRAINT `produtos_ibfk_1` FOREIGN KEY (`tipo_camisa_id`) REFERENCES `tipos_camisa` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produtos`
--

LOCK TABLES `produtos` WRITE;
/*!40000 ALTER TABLE `produtos` DISABLE KEYS */;
INSERT INTO `produtos` VALUES (1,'MV-SOC-001','7891234560001','Camisa Social Branca Clássica','Camisa social branca tradicional, perfeita para o dia a dia corporativo',1,'100% Algodão Fio 60','Lisa','Italiana',0,85.00,189.90,280,150,20,1,'2025-11-10 22:55:19'),(2,'MV-SOC-002','7891234560002','Camisa Social Azul Royal','Camisa social azul vibrante, elegância e sofisticação',1,'100% Algodão Fio 60','Lisa','Italiana',0,85.00,189.90,280,120,20,1,'2025-11-10 22:55:19'),(3,'MV-SOC-003','7891234560003','Camisa Social Rosa','Camisa social rosa suave, estilo moderno',1,'100% Algodão Fio 60','Lisa','Francesa',0,85.00,199.90,280,80,15,1,'2025-11-10 22:55:19'),(4,'MV-SOC-004','7891234560004','Camisa Social Xadrez Azul','Camisa xadrez azul e branco, casual elegante',1,'Misto Algodão','Xadrez','Button Down',1,75.00,179.90,290,95,15,1,'2025-11-10 22:55:19'),(5,'MV-SOC-005','7891234560005','Camisa Social Listrada Cinza','Camisa listrada cinza e branco, versatilidade',1,'100% Algodão','Listrada','Italiana',0,80.00,189.90,285,110,20,1,'2025-11-10 22:55:19'),(6,'MV-SLIM-001','7891234560006','Camisa Slim Fit Branca','Modelagem ajustada, design contemporâneo',5,'100% Algodão Fio 80','Lisa','Francesa',0,95.00,219.90,260,70,15,1,'2025-11-10 22:55:19'),(7,'MV-SLIM-002','7891234560007','Camisa Slim Fit Preta','Elegância em preto, corte moderno',5,'100% Algodão Fio 80','Lisa','Italiana',0,95.00,219.90,260,65,15,1,'2025-11-10 22:55:19'),(8,'MV-POLO-001','7891234560008','Camisa Polo Azul Marinho','Polo clássica para uso casual',3,'Piquet 100% Algodão','Lisa','Polo',0,60.00,149.90,220,140,25,1,'2025-11-10 22:55:19'),(9,'MV-POLO-002','7891234560009','Camisa Polo Branca','Polo branca versátil para qualquer ocasião',3,'Piquet 100% Algodão','Lisa','Polo',0,60.00,149.90,220,160,25,1,'2025-11-10 22:55:19'),(10,'MV-MC-001','7891234560010','Camisa Social Manga Curta Branca','Ideal para dias quentes, manter o estilo',2,'100% Algodão','Lisa','Italiana',1,70.00,159.90,230,90,15,1,'2025-11-10 22:55:19'),(11,'MV-MC-002','7891234560011','Camisa Social Manga Curta Azul Claro','Manga curta com elegância',2,'100% Algodão','Lisa','Italiana',1,70.00,159.90,230,85,15,1,'2025-11-10 22:55:19'),(12,'MV-CAS-001','7891234560012','Camisa Casual Jeans','Estilo casual moderno',4,'Jeans Algodão','Lisa','Button Down',1,75.00,169.90,310,60,10,1,'2025-11-10 22:55:19'),(13,'MV-SOC-006','7891234560013','Camisa Social Vinho','Tom vinho sofisticado',1,'100% Algodão Fio 60','Lisa','Francesa',0,85.00,199.90,280,55,10,1,'2025-11-10 22:55:19');
/*!40000 ALTER TABLE `produtos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `provas_embalagem`
--

DROP TABLE IF EXISTS `provas_embalagem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `provas_embalagem` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pedido_id` int NOT NULL,
  `image_path` varchar(500) NOT NULL,
  `video_path` varchar(500) DEFAULT NULL,
  `tipo_midia` enum('foto','video','ambos') DEFAULT 'foto',
  `usuario_id` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `observacoes` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `pedido_id` (`pedido_id`),
  KEY `usuario_id` (`usuario_id`),
  KEY `idx_pedido` (`pedido_id`),
  KEY `idx_data` (`created_at`),
  CONSTRAINT `provas_embalagem_ibfk_1` FOREIGN KEY (`pedido_id`) REFERENCES `pedidos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `provas_embalagem_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `provas_embalagem`
--

LOCK TABLES `provas_embalagem` WRITE;
/*!40000 ALTER TABLE `provas_embalagem` DISABLE KEYS */;
INSERT INTO `provas_embalagem` VALUES (1,1,'/provas_embalagem/pedido_1_1762815363944.png',NULL,'foto',1,'2025-11-10 22:56:03',''),(2,2,'/provas_embalagem/pedido_2_1762823308606.jpg',NULL,'foto',2,'2025-11-11 01:08:28','oi'),(3,5,'/provas_embalagem/pedido_5_1762988893521.jpg',NULL,'foto',1,'2025-11-12 23:08:13',''),(4,10,'/provas_embalagem/pedido_10_1763077234806.jpg',NULL,'foto',1,'2025-11-13 23:40:34',''),(5,6,'/provas_embalagem/pedido_6_1763167604945.png',NULL,'foto',1,'2025-11-15 00:46:44',''),(6,11,'/provas_embalagem/pedido_11_1763169617941.png',NULL,'foto',9,'2025-11-15 01:20:17',''),(7,12,'/provas_embalagem/pedido_12_1763170519451.png',NULL,'foto',1,'2025-11-15 01:35:19',''),(8,9,'/provas_embalagem/pedido_9_1763175513897.jpeg',NULL,'foto',8,'2025-11-15 02:58:33',''),(9,8,'/provas_embalagem/pedido_8_1763218434916.png',NULL,'foto',1,'2025-11-15 14:53:54','');
/*!40000 ALTER TABLE `provas_embalagem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tarefas_fila`
--

DROP TABLE IF EXISTS `tarefas_fila`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tarefas_fila` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tipo` varchar(50) NOT NULL,
  `descricao` text NOT NULL,
  `dados` json DEFAULT NULL,
  `prioridade` enum('baixa','media','alta') DEFAULT 'media',
  `status` enum('pendente','processando','concluida','erro') DEFAULT 'pendente',
  `usuario_id` int DEFAULT NULL,
  `criado_em` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `processado_em` timestamp NULL DEFAULT NULL,
  `mensagem_erro` text,
  PRIMARY KEY (`id`),
  KEY `idx_status` (`status`),
  KEY `idx_tipo` (`tipo`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tarefas_fila`
--

LOCK TABLES `tarefas_fila` WRITE;
/*!40000 ALTER TABLE `tarefas_fila` DISABLE KEYS */;
INSERT INTO `tarefas_fila` VALUES (1,'embalagem','Embalar pedido #WD1DW1 - Cliente: AAAAA','{\"origem\": \"Manual\", \"cliente\": \"AAAAA\", \"cpf_cnpj\": \"522.214.522-14\", \"order_id\": \"WD1DW1\", \"telefone\": \"(21) 45652-1458\", \"pedido_id\": 10}','alta','pendente',1,'2025-11-13 23:38:07',NULL,NULL),(2,'embalagem','Embalar pedido #123456 - Cliente: luis','{\"origem\": \"Manual\", \"cliente\": \"luis\", \"cpf_cnpj\": \"452.454.752-54\", \"order_id\": \"123456\", \"telefone\": \"(19) 9556-5587\", \"pedido_id\": 11}','alta','pendente',1,'2025-11-14 16:15:19',NULL,NULL),(3,'embalagem','Embalar pedido #2542432 - Cliente: luci','{\"origem\": \"Mercado_Livre\", \"cliente\": \"luci\", \"cpf_cnpj\": \"546.454.545-44\", \"order_id\": \"2542432\", \"telefone\": \"(19) 54598-5484\", \"pedido_id\": 12}','alta','pendente',1,'2025-11-14 23:48:33',NULL,NULL);
/*!40000 ALTER TABLE `tarefas_fila` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipos_camisa`
--

DROP TABLE IF EXISTS `tipos_camisa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipos_camisa` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `descricao` text,
  `ativo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipos_camisa`
--

LOCK TABLES `tipos_camisa` WRITE;
/*!40000 ALTER TABLE `tipos_camisa` DISABLE KEYS */;
INSERT INTO `tipos_camisa` VALUES (1,'Social Manga Longa','Camisas sociais tradicionais manga longa',1),(2,'Social Manga Curta','Camisas sociais manga curta',1),(3,'Polo','Camisas polo estilo casual',1),(4,'Casual','Camisas casuais para uso diário',1),(5,'Slim Fit','Camisas com modelagem ajustada ao corpo',1),(6,'Regular Fit','Camisas com modelagem tradicional confortável',1);
/*!40000 ALTER TABLE `tipos_camisa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `senha` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `tipo_acesso` enum('gerente','supervisor','operador','admin') NOT NULL DEFAULT 'operador',
  `ativo` tinyint(1) DEFAULT '1',
  `data_criacao` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ultimo_acesso` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_nome` (`nome`),
  KEY `idx_tipo_acesso` (`tipo_acesso`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,'Admin','$2b$10$.//ot8KQQsMmFDs.RK1Y6ezkIrEl79qyND8eDs6YMitL8XjrYAqLC','admin@mountvernon.com.br','admin',1,'2025-11-10 22:55:19',NULL),(2,'Carlos Silva','$2a$10$PRn3QD6gusCpiz2CTD2Z2uhNwCUkQxq2NMK1Fyk4c6a404URgUCbO','carlos.silva@mountvernon.com.br','gerente',1,'2025-11-10 22:55:19',NULL),(3,'Maria Santos','supervisor123','maria.santos@mountvernon.com.br','supervisor',1,'2025-11-10 22:55:19',NULL),(4,'João Oliveira','$2b$10$lihsfggXP/cz5j5JhwLfM.2iuUPy69Vq19JParMjAcxt5AZuyeFgC','joao.oliveira@mountvernon.com.br','operador',1,'2025-11-10 22:55:19',NULL),(5,'Ana Costa','$2a$10$1SrS9xsWxf.prrEkAmPjt.mRiIfSOSLwAVVNl5KjkScRbRUxLgnSi','ana.costa@mountvernon.com.br','admin',1,'2025-11-10 22:55:19',NULL),(6,'Pedro Fernandes','$2b$10$4Ufgmg9g7p6Sd3SXrIonxujOAH90ihoTBH8.Rj.xgLdKTYuD8umQi','pedro.fernandes@mountvernon.com.br','operador',1,'2025-11-10 22:55:19',NULL),(7,'Juliana Alves','$2a$10$1VNRgr/srSyRRlYpqbeWQO9pXiLK85kQwCAUZJ.cpRWMN9QY7b1bm','juliana.alves@mountvernon.com.br','operador',1,'2025-11-10 22:55:19',NULL),(8,'fernando','$2a$10$6K5p0qSQixxGWzl4T74kN.dlJXDuPqYZDCg1Al.ZzYQZzRFZeaPBq','fer@123gmail.com','gerente',1,'2025-11-12 22:58:13',NULL),(9,'maria Luiza','$2b$10$efWbr29DxNsMyO0emgASa.5BMSGH7j0IDXIpPcXQYW/XIcKmjqKWm','mariaLuiza@gmail.com','operador',1,'2025-11-15 01:17:32',NULL),(10,'Felipe silva','$2a$10$C2Z0OgFxrBaLRXdeBRAPYOTCBD/ikG/4rB/sKt.Gj2sHEK2qAkDtW','Felipesilva@gmai.com','operador',1,'2025-11-22 01:40:29',NULL);
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `variacoes_produto`
--

DROP TABLE IF EXISTS `variacoes_produto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `variacoes_produto` (
  `id` int NOT NULL AUTO_INCREMENT,
  `produto_id` int NOT NULL,
  `sku_variacao` varchar(50) NOT NULL,
  `barcode_variacao` varchar(50) DEFAULT NULL,
  `cor` varchar(50) NOT NULL,
  `tamanho` enum('PP','P','M','G','GG','XG','EXG','1','2','3','4','5','6','7') NOT NULL,
  `preco_adicional` decimal(10,2) DEFAULT '0.00',
  `estoque` int DEFAULT '0',
  `peso_gramas` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sku_variacao` (`sku_variacao`),
  UNIQUE KEY `barcode_variacao` (`barcode_variacao`),
  KEY `idx_produto` (`produto_id`),
  KEY `idx_sku_var` (`sku_variacao`),
  KEY `idx_cor` (`cor`),
  KEY `idx_tamanho` (`tamanho`),
  CONSTRAINT `variacoes_produto_ibfk_1` FOREIGN KEY (`produto_id`) REFERENCES `produtos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `variacoes_produto`
--

LOCK TABLES `variacoes_produto` WRITE;
/*!40000 ALTER TABLE `variacoes_produto` DISABLE KEYS */;
INSERT INTO `variacoes_produto` VALUES (1,1,'MV-SOC-001-BR-P','7891234560101','Branco','P',0.00,25,270),(2,1,'MV-SOC-001-BR-M','7891234560102','Branco','M',0.00,40,280),(3,1,'MV-SOC-001-BR-G','7891234560103','Branco','G',0.00,45,290),(4,1,'MV-SOC-001-BR-GG','7891234560104','Branco','GG',0.00,30,300),(5,1,'MV-SOC-001-BR-XG','7891234560105','Branco','XG',0.00,10,310),(6,2,'MV-SOC-002-AZ-P','7891234560201','Azul Royal','P',0.00,20,270),(7,2,'MV-SOC-002-AZ-M','7891234560202','Azul Royal','M',0.00,35,280),(8,2,'MV-SOC-002-AZ-G','7891234560203','Azul Royal','G',0.00,40,290),(9,2,'MV-SOC-002-AZ-GG','7891234560204','Azul Royal','GG',0.00,20,300),(10,2,'MV-SOC-002-AZ-XG','7891234560205','Azul Royal','XG',0.00,5,310),(11,3,'MV-SOC-003-RS-P','7891234560301','Rosa','P',0.00,15,270),(12,3,'MV-SOC-003-RS-M','7891234560302','Rosa','M',0.00,25,280),(13,3,'MV-SOC-003-RS-G','7891234560303','Rosa','G',0.00,25,290),(14,3,'MV-SOC-003-RS-GG','7891234560304','Rosa','GG',0.00,15,300),(15,6,'MV-SLIM-001-BR-P','7891234560601','Branco','P',0.00,15,250),(16,6,'MV-SLIM-001-BR-M','7891234560602','Branco','M',0.00,20,260),(17,6,'MV-SLIM-001-BR-G','7891234560603','Branco','G',0.00,20,270),(18,6,'MV-SLIM-001-BR-GG','7891234560604','Branco','GG',0.00,15,280),(19,8,'MV-POLO-001-AZ-P','7891234560801','Azul Marinho','P',0.00,30,210),(20,8,'MV-POLO-001-AZ-M','7891234560802','Azul Marinho','M',0.00,40,220),(21,8,'MV-POLO-001-AZ-G','7891234560803','Azul Marinho','G',0.00,45,230),(22,8,'MV-POLO-001-AZ-GG','7891234560804','Azul Marinho','GG',0.00,25,240),(23,9,'MV-POLO-002-BR-P','7891234560901','Branco','P',0.00,35,210),(24,9,'MV-POLO-002-BR-M','7891234560902','Branco','M',0.00,45,220),(25,9,'MV-POLO-002-BR-G','7891234560903','Branco','G',0.00,50,230),(26,9,'MV-POLO-002-BR-GG','7891234560904','Branco','GG',0.00,30,240);
/*!40000 ALTER TABLE `variacoes_produto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vw_auditoria_completa`
--

DROP TABLE IF EXISTS `vw_auditoria_completa`;
/*!50001 DROP VIEW IF EXISTS `vw_auditoria_completa`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_auditoria_completa` AS SELECT 
 1 AS `id`,
 1 AS `usuario_id`,
 1 AS `usuario_nome`,
 1 AS `usuario_email`,
 1 AS `tipo_acesso`,
 1 AS `acao`,
 1 AS `descricao`,
 1 AS `tabela_afetada`,
 1 AS `registro_id`,
 1 AS `ip_address`,
 1 AS `dados_anteriores`,
 1 AS `dados_novos`,
 1 AS `data_hora`,
 1 AS `data_formatada`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_dashboard_logs`
--

DROP TABLE IF EXISTS `vw_dashboard_logs`;
/*!50001 DROP VIEW IF EXISTS `vw_dashboard_logs`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_dashboard_logs` AS SELECT 
 1 AS `data`,
 1 AS `usuario_mysql`,
 1 AS `acao`,
 1 AS `tabela_afetada`,
 1 AS `total_operacoes`,
 1 AS `total_erros`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_dashboard_produtividade`
--

DROP TABLE IF EXISTS `vw_dashboard_produtividade`;
/*!50001 DROP VIEW IF EXISTS `vw_dashboard_produtividade`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_dashboard_produtividade` AS SELECT 
 1 AS `operador`,
 1 AS `pedidos_empacotados_hoje`,
 1 AS `itens_escaneados_hoje`,
 1 AS `erros_hoje`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_itens_pendentes`
--

DROP TABLE IF EXISTS `vw_itens_pendentes`;
/*!50001 DROP VIEW IF EXISTS `vw_itens_pendentes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_itens_pendentes` AS SELECT 
 1 AS `order_id`,
 1 AS `customer_name`,
 1 AS `product_name`,
 1 AS `variant_info`,
 1 AS `quantity_required`,
 1 AS `quantity_scanned`,
 1 AS `quantidade_faltante`,
 1 AS `sku`,
 1 AS `barcode`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_pedidos_completos`
--

DROP TABLE IF EXISTS `vw_pedidos_completos`;
/*!50001 DROP VIEW IF EXISTS `vw_pedidos_completos`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_pedidos_completos` AS SELECT 
 1 AS `id`,
 1 AS `order_id`,
 1 AS `source`,
 1 AS `customer_name`,
 1 AS `cliente_email`,
 1 AS `cliente_telefone`,
 1 AS `item_count`,
 1 AS `valor_total`,
 1 AS `status`,
 1 AS `created_at`,
 1 AS `packed_at`,
 1 AS `tempo_processamento`,
 1 AS `criado_por`,
 1 AS `empacotado_por`,
 1 AS `tem_prova`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_relatorio_pedidos`
--

DROP TABLE IF EXISTS `vw_relatorio_pedidos`;
/*!50001 DROP VIEW IF EXISTS `vw_relatorio_pedidos`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_relatorio_pedidos` AS SELECT 
 1 AS `data`,
 1 AS `data_formatada`,
 1 AS `origem`,
 1 AS `status`,
 1 AS `total_pedidos`,
 1 AS `valor_total_dia`,
 1 AS `ticket_medio`,
 1 AS `pendentes`,
 1 AS `prontos`,
 1 AS `com_erro`,
 1 AS `tempo_medio_minutos`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `vw_auditoria_completa`
--

/*!50001 DROP VIEW IF EXISTS `vw_auditoria_completa`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_auditoria_completa` AS select `a`.`id` AS `id`,`a`.`usuario_id` AS `usuario_id`,coalesce(`a`.`usuario_nome`,`u`.`nome`,'Sistema') AS `usuario_nome`,`u`.`email` AS `usuario_email`,`u`.`tipo_acesso` AS `tipo_acesso`,`a`.`acao` AS `acao`,`a`.`descricao` AS `descricao`,`a`.`tabela_afetada` AS `tabela_afetada`,`a`.`registro_id` AS `registro_id`,`a`.`ip_address` AS `ip_address`,`a`.`dados_anteriores` AS `dados_anteriores`,`a`.`dados_novos` AS `dados_novos`,`a`.`data_hora` AS `data_hora`,date_format(`a`.`data_hora`,'%d/%m/%Y %H:%i:%s') AS `data_formatada` from (`auditoria_sistema` `a` left join `usuarios` `u` on((`a`.`usuario_id` = `u`.`id`))) order by `a`.`data_hora` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_dashboard_logs`
--

/*!50001 DROP VIEW IF EXISTS `vw_dashboard_logs`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_dashboard_logs` AS select cast(`logs_sistema`.`data_hora` as date) AS `data`,`logs_sistema`.`usuario_mysql` AS `usuario_mysql`,`logs_sistema`.`acao` AS `acao`,`logs_sistema`.`tabela_afetada` AS `tabela_afetada`,count(0) AS `total_operacoes`,sum((case when (`logs_sistema`.`sucesso` = false) then 1 else 0 end)) AS `total_erros` from `logs_sistema` where (`logs_sistema`.`data_hora` >= (now() - interval 30 day)) group by cast(`logs_sistema`.`data_hora` as date),`logs_sistema`.`usuario_mysql`,`logs_sistema`.`acao`,`logs_sistema`.`tabela_afetada` order by `data` desc,`total_operacoes` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_dashboard_produtividade`
--

/*!50001 DROP VIEW IF EXISTS `vw_dashboard_produtividade`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_dashboard_produtividade` AS select `u`.`nome` AS `operador`,count(distinct `p`.`id`) AS `pedidos_empacotados_hoje`,count(`he`.`id`) AS `itens_escaneados_hoje`,sum((case when (`he`.`sucesso` = false) then 1 else 0 end)) AS `erros_hoje` from ((`usuarios` `u` left join `pedidos` `p` on(((`u`.`id` = `p`.`usuario_empacotamento_id`) and (cast(`p`.`packed_at` as date) = curdate())))) left join `historico_escaneamento` `he` on(((`u`.`id` = `he`.`usuario_id`) and (cast(`he`.`data_hora` as date) = curdate())))) where (`u`.`tipo_acesso` in ('operador','supervisor')) group by `u`.`id`,`u`.`nome` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_itens_pendentes`
--

/*!50001 DROP VIEW IF EXISTS `vw_itens_pendentes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_itens_pendentes` AS select `p`.`order_id` AS `order_id`,`p`.`customer_name` AS `customer_name`,`ip`.`product_name` AS `product_name`,`ip`.`variant_info` AS `variant_info`,`ip`.`quantity_required` AS `quantity_required`,`ip`.`quantity_scanned` AS `quantity_scanned`,(`ip`.`quantity_required` - `ip`.`quantity_scanned`) AS `quantidade_faltante`,`ip`.`sku` AS `sku`,`ip`.`barcode` AS `barcode` from (`itens_pedido` `ip` join `pedidos` `p` on((`ip`.`pedido_id` = `p`.`id`))) where ((`ip`.`verified` = false) and (`p`.`status` in ('Pendente','Em_Separacao'))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_pedidos_completos`
--

/*!50001 DROP VIEW IF EXISTS `vw_pedidos_completos`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_pedidos_completos` AS select `p`.`id` AS `id`,`p`.`order_id` AS `order_id`,`p`.`source` AS `source`,`p`.`customer_name` AS `customer_name`,`c`.`email` AS `cliente_email`,`c`.`telefone` AS `cliente_telefone`,`p`.`item_count` AS `item_count`,`p`.`valor_total` AS `valor_total`,`p`.`status` AS `status`,`p`.`created_at` AS `created_at`,`p`.`packed_at` AS `packed_at`,timestampdiff(MINUTE,`p`.`created_at`,`p`.`packed_at`) AS `tempo_processamento`,`u_criacao`.`nome` AS `criado_por`,`u_empacotamento`.`nome` AS `empacotado_por`,(case when (`pe`.`id` is not null) then 'Sim' else 'Não' end) AS `tem_prova` from ((((`pedidos` `p` left join `clientes` `c` on((`p`.`cliente_id` = `c`.`id`))) left join `usuarios` `u_criacao` on((`p`.`usuario_criacao_id` = `u_criacao`.`id`))) left join `usuarios` `u_empacotamento` on((`p`.`usuario_empacotamento_id` = `u_empacotamento`.`id`))) left join `provas_embalagem` `pe` on((`p`.`id` = `pe`.`pedido_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_relatorio_pedidos`
--

/*!50001 DROP VIEW IF EXISTS `vw_relatorio_pedidos`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_relatorio_pedidos` AS select cast(`p`.`created_at` as date) AS `data`,date_format(`p`.`created_at`,'%d/%m/%Y') AS `data_formatada`,`p`.`source` AS `origem`,`p`.`status` AS `status`,count(0) AS `total_pedidos`,sum(`p`.`valor_total`) AS `valor_total_dia`,avg(`p`.`valor_total`) AS `ticket_medio`,count((case when (`p`.`status` = 'Pendente') then 1 end)) AS `pendentes`,count((case when (`p`.`status` = 'Empacotado') then 1 end)) AS `prontos`,count((case when (`p`.`status` = 'Erro') then 1 end)) AS `com_erro`,avg(timestampdiff(MINUTE,`p`.`created_at`,`p`.`packed_at`)) AS `tempo_medio_minutos` from `pedidos` `p` group by cast(`p`.`created_at` as date),`p`.`source`,`p`.`status` order by `data` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-11-21 22:47:44
