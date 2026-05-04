CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_inscrever_doubles`(
    IN p_participante1 INT UNSIGNED,
    IN p_participante2 INT UNSIGNED
)
BEGIN
    DECLARE v_id_equipa INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    INSERT INTO Equipa (idEquipa) VALUES (DEFAULT);
    SET v_id_equipa = LAST_INSERT_ID();

    INSERT INTO Inscricao (Participante, Estado, Categoria, Equipa) 
    VALUES (p_participante1, 'Pendente', 'Doubles', v_id_equipa);

    INSERT INTO Inscricao (Participante, Estado, Categoria, Equipa) 
    VALUES (p_participante2, 'Pendente', 'Doubles', v_id_equipa);

    COMMIT;
END