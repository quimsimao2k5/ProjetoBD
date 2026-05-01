USE hyrox;

CREATE ROLE 'role_admin', 'role_juiz', 'role_medico';

GRANT ALL PRIVILEGES ON hyrox.* TO 'role_admin';

GRANT SELECT ON hyrox.Participante TO 'role_juiz';
GRANT SELECT ON hyrox.Inscrição TO 'role_juiz';
GRANT SELECT ON hyrox.Heat TO 'role_juiz';
GRANT SELECT ON hyrox.Prova TO 'role_juiz';
GRANT INSERT, UPDATE ON hyrox.RegistoTempo TO 'role_juiz';

GRANT SELECT ON hyrox.Participante TO 'role_medico';
GRANT SELECT ON hyrox.Inscrição TO 'role_medico';
GRANT INSERT, UPDATE ON hyrox.OcorrenciaMedica TO 'role_medico';

CREATE USER 'andre_matos_admin'@'localhost' IDENTIFIED BY 'Admin2026';
CREATE USER 'rui_gomes_juiz'@'localhost' IDENTIFIED BY 'JuizProva2026';
CREATE USER 'antonio_costa_med'@'localhost' IDENTIFIED BY 'MedicinaHyrox2026';

GRANT 'role_admin' TO 'andre_matos_admin'@'localhost';
GRANT 'role_juiz' TO 'rui_gomes_juiz'@'localhost';
GRANT 'role_medico' TO 'antonio_costa_med'@'localhost';

SET DEFAULT ROLE 'role_admin' TO 'andre_matos_admin'@'localhost';
SET DEFAULT ROLE 'role_juiz' TO 'rui_gomes_juiz'@'localhost';
SET DEFAULT ROLE 'role_medico' TO 'antonio_costa_med'@'localhost';

FLUSH PRIVILEGES;