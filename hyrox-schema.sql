CREATE SCHEMA hyrox;
USE hyrox;
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Table `Participante`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Participante` (
  `idParticipante` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(100) NOT NULL,
  `Telemóvel` VARCHAR(15) NOT NULL,
  `Email` VARCHAR(100) NOT NULL,
  `DataNascimento` DATE NOT NULL,
  `Morada` VARCHAR(150) NULL,
  PRIMARY KEY (`idParticipante`),
  UNIQUE INDEX `Email_UNIQUE` (`Email` ASC) VISIBLE)
INDEX `idx_nome` (`Nome`) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Evento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Evento` (
  `idEvento` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(150) NOT NULL,
  `Local` VARCHAR(150) NOT NULL,
  `Inicio` DATE NOT NULL,
  `Fim` DATE NOT NULL,
  PRIMARY KEY (`idEvento`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Prova`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Prova` (
  `idProva` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(45) NOT NULL,
  `OrdemProva` TINYINT UNSIGNED NOT NULL,
  `Métrica` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idProva`),
  UNIQUE INDEX `Nome_UNIQUE` (`Nome` ASC) VISIBLE,
  UNIQUE INDEX `OrdemProva_UNIQUE` (`OrdemProva` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Staff`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Staff` (
  `idStaff` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(45) NOT NULL,
  `Telm` VARCHAR(15) NOT NULL,
  `Email` VARCHAR(100) NOT NULL,
  `Tipo` ENUM('Medico', 'Admin', 'Media', 'Voluntario', 'JuizProva') NOT NULL,
  PRIMARY KEY (`idStaff`),
  UNIQUE INDEX `Email_UNIQUE` (`Email` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `JuizProva`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `JuizProva` (
  `numStaff` INT UNSIGNED NOT NULL,
  `NivelCertificacao` ENUM('1', '2', '3') NOT NULL,
  PRIMARY KEY (`numStaff`),
  CONSTRAINT `numStaffJp`
    FOREIGN KEY (`numStaff`)
    REFERENCES `Staff` (`idStaff`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Heat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Heat` (
  `idHeat` INT NOT NULL AUTO_INCREMENT,
  `Evento` INT UNSIGNED NOT NULL,
  `HoraPartida` DATETIME NOT NULL,
  `HeadJudge` INT UNSIGNED NULL,
  PRIMARY KEY (`idHeat`),
  INDEX `HeadJudge_idx` (`HeadJudge` ASC) VISIBLE,
  INDEX `idx_hora_partida` (`HoraPartida` ASC) VISIBLE,
  CONSTRAINT `EventoHeat`
    FOREIGN KEY (`Evento`)
    REFERENCES `Evento` (`idEvento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `HeadJudgeHeat`
    FOREIGN KEY (`HeadJudge`)
    REFERENCES `JuizProva` (`numStaff`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Equipa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Equipa` (
  `idEquipa` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idEquipa`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Inscricao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Inscricao` (
  `idInscricao` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Participante` INT UNSIGNED NOT NULL,
  `Estado` ENUM('Pendente', 'Pago', 'Confirmado') NOT NULL DEFAULT 'Pendente',
  `Categoria` ENUM('Open', 'Pro', 'Doubles', 'Relay') NOT NULL,
  `Heat` INT NULL,
  `Equipa` INT UNSIGNED NULL,
  PRIMARY KEY (`idInscricao`),
  INDEX `Participante_idx` (`Participante` ASC) VISIBLE,
  INDEX `Heat_idx` (`Heat` ASC) VISIBLE,
INDEX `Equipa_idx` (`Equipa` ASC) VISIBLE,
  INDEX `idx_estado` (`Estado` ASC) VISIBLE,
  INDEX `idx_categoria` (`Categoria` ASC) VISIBLE,
  CONSTRAINT `ParticipanteInsc`
    FOREIGN KEY (`Participante`)
    REFERENCES `Participante` (`idParticipante`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `HeatInsc`
    FOREIGN KEY (`Heat`)
    REFERENCES `Heat` (`idHeat`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `EquipaInsc`
    FOREIGN KEY (`Equipa`)
    REFERENCES `Equipa` (`idEquipa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Pulseira`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Pulseira` (
  `idPulseira` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Estado` ENUM('Ativa', 'Avariada', 'Extraviada') NOT NULL,
  PRIMARY KEY (`idPulseira`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `UsoPulseira`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `UsoPulseira` (
  `Inscricao` INT UNSIGNED NOT NULL,
  `Pulseira` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Inscricao`),
  INDEX `Pulseira_idx` (`Pulseira` ASC) VISIBLE,
  CONSTRAINT `InscricaoPuls`
    FOREIGN KEY (`Inscricao`)
    REFERENCES `Inscricao` (`idInscricao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `PulseiraPuls`
    FOREIGN KEY (`Pulseira`)
    REFERENCES `Pulseira` (`idPulseira`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Médico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Médico` (
  `numStaff` INT UNSIGNED NOT NULL,
  `Cedula` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`numStaff`),
  UNIQUE INDEX `Cedula_UNIQUE` (`Cedula` ASC) VISIBLE,
  CONSTRAINT `numStaffMedico`
    FOREIGN KEY (`numStaff`)
    REFERENCES `Staff` (`idStaff`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Media`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Media` (
  `numStaff` INT UNSIGNED NOT NULL,
  `Orgao` VARCHAR(45) NOT NULL,
  `Acesso` ENUM('Pista', 'Bastidores', 'VIP Zone') NOT NULL,
  `nrCarteira` VARCHAR(15) NULL,
  PRIMARY KEY (`numStaff`),
  CONSTRAINT `numStaffMedia`
    FOREIGN KEY (`numStaff`)
    REFERENCES `Staff` (`idStaff`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `OcorrenciaMedica`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `OcorrenciaMedica` (
  `idOcorrenciaMedica` INT NOT NULL AUTO_INCREMENT,
  `Participante` INT UNSIGNED NOT NULL,
  `Medico` INT UNSIGNED NOT NULL,
  `DataHora` DATETIME NOT NULL,
  `Descricao` TEXT NOT NULL,
  PRIMARY KEY (`idOcorrenciaMedica`),
  INDEX `Medico_idx` (`Medico` ASC) VISIBLE,
  CONSTRAINT `ParticipanteMed`
    FOREIGN KEY (`Participante`)
    REFERENCES `Participante` (`idParticipante`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `MedicoMed`
    FOREIGN KEY (`Medico`)
    REFERENCES `Médico` (`numStaff`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Pagamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Pagamento` (
  `idPagamento` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Inscricao` INT UNSIGNED NOT NULL,
  `Data` DATETIME NOT NULL,
  `Montante` DECIMAL(8,2) NOT NULL,
  `Metodo` ENUM('Transferência', 'MBWay', 'Cartão') NOT NULL,
  `Validou` INT UNSIGNED NULL,
  PRIMARY KEY (`idPagamento`),
  UNIQUE INDEX `Inscricao_UNIQUE` (`Inscricao` ASC) VISIBLE,
  INDEX `Validou_idx` (`Validou` ASC) VISIBLE,
  CONSTRAINT `InscricaoPag`
    FOREIGN KEY (`Inscricao`)
    REFERENCES `Inscricao` (`idInscricao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `ValidouPag`
    FOREIGN KEY (`Validou`)
    REFERENCES `Staff` (`idStaff`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `RegistoTempo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `RegistoTempo` (
  `idRegistoTempo` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Juiz` INT UNSIGNED NOT NULL,
  `Inscricao` INT UNSIGNED NOT NULL,
  `Prova` INT UNSIGNED NOT NULL,
  `Duracao(ms)` INT UNSIGNED NOT NULL,
  `Penalizacao(ms)` INT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`idRegistoTempo`),
  INDEX `Inscricao_idx` (`Inscricao` ASC) VISIBLE,
  INDEX `Juiz_idx` (`Juiz` ASC) VISIBLE,
  UNIQUE INDEX `idx_unico_tempo` (`Prova` ASC, `Inscricao` ASC) VISIBLE,
INDEX `idx_prova_duracao` (`Prova` ASC, `Duracao(ms)` ASC) VISIBLE,
  CONSTRAINT `ProvaTempo`
    FOREIGN KEY (`Prova`)
    REFERENCES `Prova` (`idProva`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `InscricaoTempo`
    FOREIGN KEY (`Inscricao`)
    REFERENCES `Inscricao` (`idInscricao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `JuizTempo`
    FOREIGN KEY (`Juiz`)
    REFERENCES `JuizProva` (`numStaff`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
