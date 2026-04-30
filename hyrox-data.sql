INSERT INTO `Equipa` (`idEquipa`) VALUES
(1)
-- -----------------------------------------------------
-- 1. Participantes
-- -----------------------------------------------------
INSERT INTO `Participante` (`idParticipante`, `Nome`, `Telemóvel`, `Email`, `DataNascimento`, `Morada`) VALUES
(1, 'João Silva', '912345678', 'joao.silva@email.com', '1990-05-15', 'Rua de Cima, 123, Lisboa'),
(2, 'Maria Santos', '962345678', 'maria.santos@email.com', '1992-08-22', 'Avenida Central, 45, Porto'),
(3, 'Carlos Pereira', '932345678', 'carlos.p@email.com', '1988-11-02', 'Praceta das Flores, Braga');

-- -----------------------------------------------------
-- 2. Eventos
-- -----------------------------------------------------
INSERT INTO `Evento` (`idEvento`, `Nome`, `Local`, `Inicio`, `Fim`) VALUES
(1, 'Hyrox Lisboa 2026', 'FIL - Feira Internacional de Lisboa', '2026-05-10', '2026-05-11'),
(2, 'Hyrox Porto 2026', 'Exponor', '2026-10-24', '2026-10-25');

-- -----------------------------------------------------
-- 3. Provas (As estações fixas)
-- -----------------------------------------------------
INSERT INTO `Prova` (`idProva`, `Nome`, `OrdemProva`, `Métrica`) VALUES
(1, 'Corrida1', 1, '1000 Metros'),
(2, 'SkiErg', 2, '1000 Metros'),
(3, 'Corrida2', 3, '1000 Metros'),
(4, 'Sled Push', 4, '50 Metros'),
(5, 'Corrida3', 5, '1000 Metros'),
(6, 'Sled Pull', 6, '50 Metros'),
(7, 'Corrida4', 7, '1000 Metros'),
(8, 'Burpee Broad Jumps', 8, '80 Metros'),
(9, 'Corrida5', 9, '1000 Metros'),
(10, 'Rowing', 10, '1000 Metros'),
(11, 'Corrida6', 11, '1000 Metros'),
(12, 'Farmers Carry', 12, '200 Metros'),
(13, 'Corrida7', 13, '1000 Metros'),
(14, 'Sandbag Lunges', 14, '100 Metros'),
(15, 'Corrida8', 15, '1000 Metros'),
(16, 'Wall Balls', 16, '75/100 Repetições');

-- -----------------------------------------------------
-- 4. Equipamento (Pulseiras)
-- -----------------------------------------------------
INSERT INTO `Pulseira` (`idPulseira`, `Estado`) VALUES
(101, 'Ativa'),
(102, 'Ativa'),
(103, 'Avariada'),
(104, 'Ativa');

-- -----------------------------------------------------
-- 5. Staff (A Superclasse)
-- -----------------------------------------------------
INSERT INTO `Staff` (`idStaff`, `Nome`, `Telm`, `Email`, `Tipo`) VALUES
(1, 'Dr. António Costa', '910000001', 'antonio.medico@hyrox.pt', 'Medico'),
(2, 'Ana Rodrigues', '910000002', 'ana.juiz@hyrox.pt', 'JuizProva'),
(3, 'Rui Gomes', '910000003', 'rui.juiz@hyrox.pt', 'JuizProva'),
(4, 'Sofia Almeida', '910000004', 'sofia.media@hyrox.pt', 'Media');

-- -----------------------------------------------------
-- 6. Especializações do Staff
-- -----------------------------------------------------
INSERT INTO `Médico` (`numStaff`, `Cedula`) VALUES 
(1, 'OM-12345');

INSERT INTO `JuizProva` (`numStaff`, `NivelCertificacao`) VALUES 
(2, '3'), -- Head Judge
(3, '1'); -- Juiz de linha

INSERT INTO `Media` (`numStaff`, `Orgao`, `Acesso`, `nrCarteira`) VALUES 
(4, 'Revista Fitness', 'Pista', 'CP-9876');

-- -----------------------------------------------------
-- 7. Heats (Baterias)
-- -----------------------------------------------------
-- A Heat 1 pertence ao Hyrox Lisboa (Evento 1) e tem a Ana (Juiz 2) como Head Judge.
INSERT INTO `Heat` (`idHeat`, `Evento`, `HoraPartida`, `HeadJudge`) VALUES
(1, 1, '2026-05-10 10:00:00', 2),
(2, 1, '2026-05-10 10:30:00', 2);

-- -----------------------------------------------------
-- 8. Inscrições
-- -----------------------------------------------------
INSERT INTO `Inscrição` (`idInscrição`, `Participante`, `Estado`, `Categoria`, `Heat`, `Equipa`) VALUES
(1, 1, 'Confirmado', 'Doubles', 1, 1), -- João na Heat 1
(2, 2, 'Confirmado', 'Doubles', 1, 1),  -- Maria na Heat 1
(3, 3, 'Pendente', 'Open', NULL,NULL); -- Carlos ainda não pagou, logo não tem Heat

-- -----------------------------------------------------
-- 9. Entregas de Logística e Pagamentos
-- -----------------------------------------------------
-- Atribuir pulseiras ativas às inscrições confirmadas
INSERT INTO `UsoPulseira` (`Inscricao`, `Pulseira`) VALUES
(1, 101),
(2, 102);

-- Registar os pagamentos
INSERT INTO `Pagamento` (`idPagamento`, `Inscricao`, `Data`, `Montante`, `Metodo`, `Validou`) VALUES
(1, 1, '2026-03-01 14:30:00', 85.00, 'MBWay', NULL), -- Automático, sem validação humana
(2, 2, '2026-03-02 09:15:00', 105.00, 'Transferência', 2); -- Validado manualmente por um admin/staff

-- -----------------------------------------------------
-- 10. Registo de Tempos (A tabela associativa)
-- -----------------------------------------------------
-- Tempos registados em milissegundos
INSERT INTO `RegistoTempo` (`idRegistoTempo`, `Juiz`, `Inscricao`, `Prova`, `Duracao(ms)`, `Penalizacao(ms)`) VALUES
(1, 3, 1, 1, 245000, 0),      -- João no SkiErg validado pelo Rui (sem penalização)
(2, 3, 2, 1, 220000, 0),      -- Maria no SkiErg validada pelo Rui (sem penalização)
(3, 2, 1, 2, 180000, 30000),  -- João no Sled Push validado pela Ana (30s de penalização)
(4, 2, 2, 2, 165000, 0);      -- Maria no Sled Push validada pela Ana

-- -----------------------------------------------------
-- 11. Ocorrências Médicas
-- -----------------------------------------------------
INSERT INTO `OcorrenciaMedica` (`idOcorrenciaMedica`, `Participante`, `Medico`, `DataHora`, `Descricao`) VALUES
(1, 1, 1, '2026-05-10 10:45:00', 'Atleta queixou-se de cãibras severas nos gémeos após a estação Sled Pull. Aplicado gelo. Atleta recusou abandono e prosseguiu.');
