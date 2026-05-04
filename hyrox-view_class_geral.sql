CREATE VIEW view_classificacao_geral AS
SELECT 
    P.Nome AS Atleta,
    I.Categoria,
    I.Estado,
    SUM(RT.`Duracao(ms)` + RT.`Penalizacao(ms)`) AS TempoTotal_MS,
    fn_formata_tempo(SUM(RT.`Duracao(ms)` + RT.`Penalizacao(ms)`)) AS Tempo_Oficial
FROM 
    Participante P
JOIN 
    Inscrição I ON P.idParticipante = I.Participante
JOIN 
    RegistoTempo RT ON I.idInscrição = RT.Inscricao
WHERE
    I.Estado = 'Confirmado'
GROUP BY 
    P.idParticipante, P.Nome, I.Categoria, I.Estado
ORDER BY 
    TempoTotal_MS ASC;