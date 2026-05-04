CREATE FUNCTION fn_formata_tempo(total_ms INT UNSIGNED) 
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    DECLARE total_segundos INT;
    DECLARE tempo_formatado VARCHAR(10);
    
    -- Converte milissegundos para segundos
    SET total_segundos = ROUND(total_ms / 1000);
    
    -- Transforma os segundos no formato 00:00:00
    SET tempo_formatado = TIME_FORMAT(SEC_TO_TIME(total_segundos), '%H:%i:%s');
    
    RETURN tempo_formatado;
END