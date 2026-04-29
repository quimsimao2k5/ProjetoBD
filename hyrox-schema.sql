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
  UNIQUE INDEX `idParticipante_UNIQUE` (`idParticipante` ASC) VISIBLE,
  UNIQUE INDEX `Email_UNIQUE` (`Email` ASC) VISIBLE)
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
  PRIMARY KEY (`idEvento`),
  UNIQUE INDEX `idEvento_UNIQUE` (`idEvento` ASC) VISIBLE)
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
  UNIQUE INDEX `idProva_UNIQUE` (`idProva` ASC) VISIBLE,
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
  UNIQUE INDEX `idStaff_UNIQUE` (`idStaff` ASC) VISIBLE,
  UNIQUE INDEX `Email_UNIQUE` (`Email` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `JuizProva`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `JuizProva` (
  `numStaff` INT UNSIGNED NOT NULL,
  `NivelCertificacao` ENUM('1', '2', '3') NOT NULL,
  PRIMARY KEY (`numStaff`),
  CONSTRAINT `fk_jp_staff`
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
  UNIQUE INDEX `idHeat_UNIQUE` (`idHeat` ASC) VISIBLE,
  INDEX `HeadJudge_idx` (`HeadJudge` ASC) VISIBLE,
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
-- Table `Inscrição`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Inscrição` (
  `idInscrição` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Participante` INT UNSIGNED NOT NULL,
  `Estado` ENUM('Pendente', 'Pago', 'Confirmado') NOT NULL DEFAULT 'Pendente',
  `Categoria` ENUM('Open', 'Pro', 'Doubles', 'Relay') NOT NULL,
  `Heat` INT NULL,
  PRIMARY KEY (`idInscrição`),
  UNIQUE INDEX `idInscrição_UNIQUE` (`idInscrição` ASC) VISIBLE,
  INDEX `Participante_idx` (`Participante` ASC) VISIBLE,
  INDEX `Heat_idx` (`Heat` ASC) VISIBLE,
  CONSTRAINT `ParticipanteInscricao`
    FOREIGN KEY (`Participante`)
    REFERENCES `Participante` (`idParticipante`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `HeatInscricao`
    FOREIGN KEY (`Heat`)
    REFERENCES `Heat` (`idHeat`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Pulseira`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Pulseira` (
  `idPulseira` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Estado` ENUM('Ativa', 'Avariada', 'Extraviada') NOT NULL,
  PRIMARY KEY (`idPulseira`),
  UNIQUE INDEX `idPulseira_UNIQUE` (`idPulseira` ASC) VISIBLE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `UsoPulseira`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `UsoPulseira` (
  `Inscricao` INT UNSIGNED NOT NULL,
  `Pulseira` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Inscricao`),
  INDEX `Pulseira_idx` (`Pulseira` ASC) VISIBLE,
  CONSTRAINT `InscricaoPulseira`
    FOREIGN KEY (`Inscricao`)
    REFERENCES `Inscrição` (`idInscrição`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `PulseiraUso`
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
  CONSTRAINT `fk_medicon_staff`
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
  UNIQUE INDEX `numStaff_UNIQUE` (`numStaff` ASC) VISIBLE,
  CONSTRAINT `fk_media_staff`
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
  UNIQUE INDEX `idOcorrenciaMedica_UNIQUE` (`idOcorrenciaMedica` ASC) VISIBLE,
  INDEX `Medico_idx` (`Medico` ASC) VISIBLE,
  CONSTRAINT `ParticipanteOcorrMed`
    FOREIGN KEY (`Participante`)
    REFERENCES `Participante` (`idParticipante`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Medico`
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
  UNIQUE INDEX `idPagamento_UNIQUE` (`idPagamento` ASC) VISIBLE,
  UNIQUE INDEX `Inscricao_UNIQUE` (`Inscricao` ASC) VISIBLE,
  INDEX `Validou_idx` (`Validou` ASC) VISIBLE,
  CONSTRAINT `InscricaoPagamento`
    FOREIGN KEY (`Inscricao`)
    REFERENCES `Inscrição` (`idInscrição`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Validou`
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
  UNIQUE INDEX `idRegistoTempo_UNIQUE` (`idRegistoTempo` ASC) VISIBLE,
  INDEX `Inscricao_idx` (`Inscricao` ASC) VISIBLE,
  INDEX `Juiz_idx` (`Juiz` ASC) VISIBLE,
  UNIQUE INDEX `idx_unico_tempo` (`Prova` ASC, `Inscricao` ASC) VISIBLE,
  CONSTRAINT `ProvaTempo`
    FOREIGN KEY (`Prova`)
    REFERENCES `Prova` (`idProva`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `InscricaoTempo`
    FOREIGN KEY (`Inscricao`)
    REFERENCES `Inscrição` (`idInscrição`)
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
