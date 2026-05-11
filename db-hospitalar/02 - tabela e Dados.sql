-- BANCO DE DADOS HOSPITALAR 
CREATE DATABASE IF NOT EXISTS db_hospital;
USE db_hospital;

-- 1. CRIAÇÃO DAS TABELAS

-- 1. Especialidades
CREATE TABLE especialidades (
    id_especialidade INT AUTO_INCREMENT PRIMARY KEY,
    nome_especialidade VARCHAR(100) NOT NULL UNIQUE,
    descricao TEXT
);

-- 2. Médicos
CREATE TABLE medicos (
    id_medico INT AUTO_INCREMENT PRIMARY KEY,
    nome_medico VARCHAR(200) NOT NULL,
    crm VARCHAR(20) UNIQUE NOT NULL,
    id_especialidade INT NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100),
    data_contratacao DATE,
    status_medico ENUM('Ativo', 'Inativo', 'Licença') DEFAULT 'Ativo',
    FOREIGN KEY (id_especialidade) REFERENCES especialidades(id_especialidade)
);

-- 3. Pacientes
CREATE TABLE pacientes (
    id_paciente INT AUTO_INCREMENT PRIMARY KEY,
    nome_paciente VARCHAR(200) NOT NULL,
    cpf VARCHAR(20) UNIQUE NOT NULL,
    data_nascimento DATE,
    genero ENUM('Masculino', 'Feminino', 'Outro'),
    telefone VARCHAR(20),
    email VARCHAR(100),
    endereco VARCHAR(255),
    cidade VARCHAR(100),
    estado CHAR(2),
    data_cadastro DATE DEFAULT (CURRENT_DATE),
    status_paciente ENUM('Ativo', 'Inativo') DEFAULT 'Ativo'
);

-- 4. Consultas
CREATE TABLE consultas (
    id_consulta INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_medico INT NOT NULL,
    data_consulta DATETIME NOT NULL,
    valor_consulta DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    status_consulta ENUM('Agendada', 'Realizada', 'Cancelada', 'Não Compareceu') DEFAULT 'Agendada',
    diagnostico TEXT,
    observacoes TEXT,
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente),
    FOREIGN KEY (id_medico) REFERENCES medicos(id_medico)
);

-- 5. Pagamentos
CREATE TABLE pagamentos (
    id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    id_consulta INT NOT NULL,
    valor_pago DECIMAL(10,2) NOT NULL,
    data_pagamento DATETIME DEFAULT CURRENT_TIMESTAMP,
    forma_pagamento ENUM('Pix','Cartão de Crédito','Cartão de Débito','Dinheiro','Convênio') NOT NULL,
    status_pagamento ENUM('Pendente','Pago','Cancelado','Reembolsado') DEFAULT 'Pendente',
    FOREIGN KEY (id_consulta) REFERENCES consultas(id_consulta) ON DELETE CASCADE
);

-- 2. INSERÇÃO DOS DADOS

-- 1. Especialidades
INSERT INTO especialidades (nome_especialidade, descricao) VALUES
('Cardiologia', 'Especialidade que cuida do coração e sistema circulatório'),
('Ortopedia', 'Tratamento de ossos, articulações e músculos'),
('Pediatria', 'Cuidado médico de crianças e adolescentes'),
('Ginecologia', 'Saúde da mulher e sistema reprodutor feminino'),
('Neurologia', 'Doenças do sistema nervoso'),
('Dermatologia', 'Tratamento da pele, cabelo e unhas'),
('Oftalmologia', 'Cuidados com os olhos'),
('Endocrinologia', 'Doenças hormonais e metabolismo'),
('Psiquiatria', 'Saúde mental e distúrbios emocionais'),
('Clínica Geral', 'Atendimento inicial e prevenção');

-- 2. Médicos
INSERT INTO medicos (nome_medico, crm, id_especialidade, telefone, email, data_contratacao, status_medico) VALUES
('Dr. Carlos Mendes', 'SP12345', 1, '11987654321', 'carlos.mendes@hospital.com', '2022-03-15', 'Ativo'),
('Dra. Juliana Costa', 'SP23456', 4, '11987654322', 'juliana.costa@hospital.com', '2021-11-20', 'Ativo'),
('Dr. Rafael Santos', 'SP34567', 2, '11987654323', 'rafael.santos@hospital.com', '2023-01-10', 'Ativo'),
('Dra. Mariana Alves', 'SP45678', 3, '11987654324', 'mariana.alves@hospital.com', '2022-08-05', 'Ativo'),
('Dr. Lucas Ferreira', 'SP56789', 5, '11987654325', 'lucas.ferreira@hospital.com', '2021-06-12', 'Ativo'),
('Dra. Beatriz Lima', 'SP67890', 6, '11987654326', 'beatriz.lima@hospital.com', '2023-02-28', 'Ativo'),
('Dr. André Silva', 'SP78901', 1, '11987654327', 'andre.silva@hospital.com', '2020-09-15', 'Ativo'),
('Dra. Camila Rocha', 'SP89012', 7, '11987654328', 'camila.rocha@hospital.com', '2022-05-10', 'Ativo'),
('Dr. Gabriel Nunes', 'SP90123', 8, '11987654329', 'gabriel.nunes@hospital.com', '2023-04-01', 'Ativo'),
('Dra. Larissa Mendes', 'SP01234', 9, '11987654330', 'larissa.mendes@hospital.com', '2021-12-15', 'Ativo'),
('Dr. Thiago Costa', 'SP11223', 10, '11987654331', 'thiago.costa@hospital.com', '2022-07-20', 'Ativo'),
('Dra. Fernanda Oliveira', 'SP22334', 3, '11987654332', 'fernanda.oliveira@hospital.com', '2023-03-05', 'Ativo'),
('Dr. Roberto Almeida', 'SP33445', 2, '11987654333', 'roberto.almeida@hospital.com', '2021-10-18', 'Ativo'),
('Dra. Ana Beatriz', 'SP44556', 4, '11987654334', 'ana.beatriz@hospital.com', '2022-11-30', 'Ativo'),
('Dr. Marcos Vinicius', 'SP55667', 1, '11987654335', 'marcos.vinicius@hospital.com', '2020-04-12', 'Ativo');

-- 3. Pacientes
INSERT INTO pacientes (nome_paciente, cpf, data_nascimento, genero, telefone, email, cidade, estado) VALUES
('João Pedro Silva', '123.456.789-01', '1995-08-15', 'Masculino', '11955554444', 'joao@email.com', 'São Paulo', 'SP'),
('Maria Clara Santos', '234.567.890-02', '2000-03-22', 'Feminino', '11955554445', 'maria@email.com', 'São Paulo', 'SP'),
('Lucas Mendes', '345.678.901-03', '1988-11-10', 'Masculino', '11955554446', 'lucas.m@email.com', 'Guarulhos', 'SP'),
('Ana Beatriz Costa', '456.789.012-04', '1997-05-30', 'Feminino', '11955554447', 'ana.beatriz@email.com', 'São Paulo', 'SP'),
('Pedro Henrique Lima', '567.890.123-05', '1992-12-05', 'Masculino', '11955554448', 'pedro.h@email.com', 'Osasco', 'SP'),
('Julia Ferreira', '678.901.234-06', '2002-07-18', 'Feminino', '11955554449', 'julia.f@email.com', 'São Paulo', 'SP'),
('Gabriel Rocha', '789.012.345-07', '1994-09-25', 'Masculino', '11955554450', 'gabriel.r@email.com', 'São Bernardo', 'SP'),
('Laura Oliveira', '890.123.456-08', '1999-01-12', 'Feminino', '11955554451', 'laura@email.com', 'São Paulo', 'SP'),
('Rafael Costa', '901.234.567-09', '1985-06-08', 'Masculino', '11955554452', 'rafael.c@email.com', 'Guarulhos', 'SP'),
('Isabella Santos', '012.345.678-10', '2001-04-17', 'Feminino', '11955554453', 'isabella@email.com', 'São Paulo', 'SP');

-- 4. Consultas
INSERT INTO consultas (id_paciente, id_medico, data_consulta, valor_consulta, status_consulta, diagnostico, observacoes) VALUES
(1, 1, '2026-04-01 08:30:00', 280.00, 'Realizada', 'Hipertensão arterial', 'Paciente iniciou tratamento medicamentoso'),
(2, 2, '2026-04-01 09:00:00', 250.00, 'Realizada', 'Exame ginecológico de rotina', 'Sem alterações clínicas'),
(3, 3, '2026-04-02 10:15:00', 300.00, 'Realizada', 'Fratura por estresse', 'Repouso recomendado por 30 dias'),
(4, 4, '2026-04-02 14:00:00', 220.00, 'Realizada', 'Check-up pediátrico', 'Crescimento adequado para idade'),
(5, 1, '2026-04-03 08:45:00', 280.00, 'Cancelada', NULL, 'Paciente cancelou consulta'),
(1, 7, '2026-04-05 09:30:00', 280.00, 'Realizada', 'Controle de hipertensão', 'Pressão arterial estabilizada'),
(6, 6, '2026-04-05 11:00:00', 260.00, 'Realizada', 'Dermatite de contato', 'Recomendado evitar produto alergênico'),
(7, 5, '2026-04-06 14:30:00', 320.00, 'Não Compareceu', NULL, 'Paciente não compareceu à consulta'),
(8, 8, '2026-04-07 08:00:00', 270.00, 'Realizada', 'Exame oftalmológico', 'Necessário uso de lentes corretivas'),
(9, 11, '2026-04-08 10:20:00', 180.00, 'Realizada', 'Gripe forte', 'Medicamentos prescritos'),
(10, 2, '2026-04-08 15:00:00', 250.00, 'Cancelada', NULL, 'Consulta remarcada pelo paciente'),
(4, 4, '2026-04-10 09:15:00', 220.00, 'Realizada', 'Vacinação', 'Vacinação concluída com sucesso'),
(2, 9, '2026-04-12 11:30:00', 290.00, 'Não Compareceu', NULL, 'Paciente não respondeu contato'),
(5, 3, '2026-04-15 08:40:00', 300.00, 'Realizada', 'Entorse no joelho', 'Fisioterapia recomendada'),
(1, 1, '2026-04-20 08:30:00', 280.00, 'Realizada', 'Retorno cardiológico', 'Paciente apresentou melhora significativa'),
(1, 7, '2026-05-02 09:00:00', 280.00, 'Realizada', 'Acompanhamento pressão arterial', 'Pressão estabilizada'),
(2, 2, '2026-05-05 10:30:00', 250.00, 'Agendada', NULL, 'Consulta preventiva anual'),
(5, 3, '2026-05-08 14:00:00', 300.00, 'Agendada', NULL, 'Retorno ortopédico');

-- 5. Pagamentos
INSERT INTO pagamentos (id_consulta, valor_pago, data_pagamento, forma_pagamento, status_pagamento) VALUES
(1, 280.00, '2026-04-01 09:00:00', 'Pix', 'Pago'),
(2, 250.00, '2026-04-01 09:30:00', 'Cartão de Crédito', 'Pago'),
(3, 300.00, '2026-04-02 11:00:00', 'Pix', 'Pago'),
(4, 220.00, '2026-04-02 14:30:00', 'Convênio', 'Pago'),
(5, 280.00, NULL, 'Pix', 'Cancelado'),
(6, 280.00, '2026-04-05 10:00:00', 'Pix', 'Pago'),
(7, 260.00, '2026-04-05 11:45:00', 'Cartão de Débito', 'Pago'),
(8, 320.00, NULL, 'Pix', 'Pendente'),
(9, 270.00, '2026-04-07 08:30:00', 'Cartão de Crédito', 'Pago'),
(10, 180.00, '2026-04-08 10:50:00', 'Pix', 'Pago'),
(11, 250.00, NULL, 'Convênio', 'Cancelado'),
(12, 220.00, '2026-04-10 09:45:00', 'Dinheiro', 'Pago'),
(13, 290.00, NULL, 'Cartão de Crédito', 'Pendente'),
(14, 300.00, '2026-04-15 09:10:00', 'Pix', 'Pago'),
(15, 280.00, '2026-04-20 09:00:00', 'Pix', 'Pago'),
(16, 280.00, '2026-05-02 09:30:00', 'Cartão de Crédito', 'Pago'),
(17, 250.00, NULL, 'Convênio', 'Pendente'),
(18, 300.00, NULL, 'Pix', 'Pendente');
