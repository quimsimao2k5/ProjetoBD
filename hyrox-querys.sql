Use hyrox;
-- Consulta de atletas por bateria de partida - Pessoas que vão começar num certo horário

SELECT P.Nome
FROM Participante P
JOIN Inscricao I ON P.idParticipante = I.Participante
JOIN Heat H ON I.Heat = H.idHeat
JOIN Evento E ON H.Evento = E.idEvento
WHERE E.Nome = 'Hyrox Lisboa 2026' 
  AND H.HoraPartida = '2026-05-10 10:00:00'
  AND I.Estado = 'Confirmado';
  
  
-- Consulta de agregação simples de penalizações - Total de penalizações numa estação

SELECT SUM(RT.`Penalizacao(ms)`) AS Total_Penalizacoes_MS
FROM RegistoTempo RT
JOIN Prova Pr ON RT.Prova = Pr.idProva
WHERE Pr.Nome = 'Sled Push';


-- Consulta de auditabilidade de oficiais de prova - Quem avaliou a pessoa x

SELECT DISTINCT S.Nome AS Nome_Juiz
FROM Staff S
JOIN RegistoTempo RT ON S.idStaff = RT.Juiz
JOIN Inscricao I ON RT.Inscricao = I.idInscricao
JOIN Participante P ON I.Participante = P.idParticipante
WHERE P.Nome = 'Diogo Correia Ferreira';



-- Consulta de histórico de assistências médicas

SELECT P.Nome AS Atleta_Assistido, S.Nome AS Medico_Responsavel
FROM OcorrenciaMedica OM
JOIN Participante P ON OM.Participante = P.idParticipante
JOIN Staff S ON OM.Medico = S.idStaff;



-- Consulta complexa com agrupamento e funções escalares
SELECT 
    Pr.OrdemProva,
    Pr.Nome AS Estacao, 
    I.Categoria, 
    COUNT(RT.idRegistoTempo) AS Total_Avaliacoes,
    FN_FORMATA_TEMPO(AVG(RT.`Duracao(ms)` + RT.`Penalizacao(ms)`)) AS Tempo_Medio_Oficial
FROM RegistoTempo RT
JOIN Prova Pr ON RT.Prova = Pr.idProva
JOIN Inscricao I ON RT.Inscricao = I.idInscricao
WHERE I.Estado = 'Confirmado'
GROUP BY Pr.idProva, Pr.Nome, Pr.OrdemProva, I.Categoria
ORDER BY Pr.OrdemProva ASC, I.Categoria ASC;