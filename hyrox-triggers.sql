USE hyrox;
DELIMITER $$

CREATE TRIGGER trg_valida_entrega_pulseira
BEFORE INSERT ON UsoPulseira
FOR EACH ROW
BEGIN
    DECLARE v_estado_inscricao VARCHAR(20);
    DECLARE v_estado_pulseira VARCHAR(20);
    
    SELECT Estado INTO v_estado_inscricao 
    FROM Inscricao 
    WHERE idInscricao = NEW.Inscricao;

    IF v_estado_inscricao != 'Confirmado' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Erro de Inscrição: Pulseira bloqueada. A inscrição deste atleta encontra-se Pendente.';
    END IF;

    SELECT Estado INTO v_estado_pulseira 
    FROM Pulseira 
    WHERE idPulseira = NEW.Pulseira;

    IF v_estado_pulseira != 'Ativa' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Erro de Hardware: A pulseira que tentou entregar está registada no sistema como Avariada ou Extraviada.';
    END IF;
END$$

DELIMITER ;