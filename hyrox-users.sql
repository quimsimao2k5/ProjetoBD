USE hyrox;

-- 1. Criação dos Grupos
CREATE ROLE 'role_admin', 'role_juiz', 'role_medico';

-- 2. Permissões do Admin
GRANT ALL PRIVILEGES ON hyrox.* TO 'role_admin';

-- 3. Permissões do Juiz
GRANT SELECT ON hyrox.view_classificacao_geral TO 'role_juiz';
GRANT SELECT ON hyrox.view_heats_partida TO 'role_juiz';
GRANT SELECT ON hyrox.Inscricao TO 'role_juiz';
GRANT SELECT ON hyrox.Heat TO 'role_juiz';
GRANT SELECT ON hyrox.Prova TO 'role_juiz';
GRANT INSERT, UPDATE ON hyrox.RegistoTempo TO 'role_juiz';

-- 4. Permissões do Médico 
GRANT SELECT ON hyrox.view_seguranca_medica TO 'role_medico';
GRANT SELECT ON hyrox.Inscricao TO 'role_medico';
GRANT INSERT, UPDATE ON hyrox.OcorrenciaMedica TO 'role_medico';

-- 5. Criação dos Utilizadores Reais
CREATE USER 'andre_matos_admin'@'localhost' IDENTIFIED BY 'Admin2026';
CREATE USER 'rui_gomes_juiz'@'localhost' IDENTIFIED BY 'JuizProva2026';
CREATE USER 'ana_gomes_juiz'@'localhost' IDENTIFIED BY 'anagomes';
CREATE USER 'antonio_costa_med'@'localhost' IDENTIFIED BY 'MedicinaHyrox2026';

-- 6. Atribuição dos Roles aos Utilizadores
GRANT 'role_admin' TO 'andre_matos_admin'@'localhost';
GRANT 'role_juiz' TO 'rui_gomes_juiz'@'localhost';
GRANT 'role_juiz' TO 'ana_gomes_juiz'@'localhost';
GRANT 'role_medico' TO 'antonio_costa_med'@'localhost';

-- 7. Ativação Automática dos Roles quando fazem Login
SET DEFAULT ROLE 'role_admin' TO 'andre_matos_admin'@'localhost';
SET DEFAULT ROLE 'role_juiz' TO 'rui_gomes_juiz'@'localhost';
SET DEFAULT ROLE 'role_juiz' TO 'ana_gomes_juiz'@'localhost';
SET DEFAULT ROLE 'role_medico' TO 'antonio_costa_med'@'localhost';

FLUSH PRIVILEGES;