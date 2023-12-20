--TRABALHANDO COM DDL – DATA DEFINITION LANGUAGE
--■ Criação da Database
	CREATE DATABASE "pc_sistemas"
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Portuguese_Brazil.1252'
    LC_CTYPE = 'Portuguese_Brazil.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

-- Criação da tabela cliente
CREATE TABLE cliente ( 
	ID SERIAL PRIMARY KEY,
	nome VARCHAR(40) NOT NULL,
	data_cadastro TIMESTAMP
);

-- Insere dados na tabela clientes

INSERT INTO cliente (nome) VALUES
('João Castro'),
('Maria Soares');

--■ Criando TRIGGER before insert com função na coluna 
--data_cadastro na tabela cliente para inserir data e hora caso usuário não insira

CREATE FUNCTION data_cadastro()
RETURNS TRIGGER AS $$
BEGIN
  NEW.data_cadastro = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER datas_cadastros
  BEFORE INSERT
  ON cliente
  FOR EACH ROW
  EXECUTE PROCEDURE data_cadastro();


INSERT INTO cliente (nome) VALUES
	('Carlos Magno'),
    ('Ana Carolina');
	
INSERT INTO cliente (nome) 
VALUES ('Fernanda Brum'),
	   ('Ketllen Rebeca');
	   
SELECT * FROM cliente;

-- Função para retornar os registros de cadastro de clientes do dia pesquisado

CREATE FUNCTION cadastro_clientes_por_dia(data_pesquisa DATE) 
RETURNS INT AS $$
DECLARE
	total_clientes INT;
BEGIN
   
    SELECT COUNT(*) INTO total_clientes
    FROM cliente
    WHERE data_cadastro = data_pesquisa;

 -- Retorna o resultado.
 
    RETURN total_clientes;	
END;
$$ language 'plpgsql';

-- Função para retornar os registros de cadastro de clientes do dia COM IF

CREATE FUNCTION cad_clientes_por_dia(data_pesquisa DATE) 
RETURNS BIGINT AS $$
DECLARE
    total_clientes BIGINT;
BEGIN
    -- Verifica se a data de pesquisa é nula
    IF data_pesquisa IS NULL THEN
        RAISE EXCEPTION 'A data de pesquisa não pode ser nula.';
    END IF;
    
    -- Conta o número de registros de clientes para a data de pesquisa
    SELECT COUNT(*) INTO total_clientes
    FROM cliente
    WHERE data_cadastro = data_pesquisa;

    -- Retorna o resultado.
    RETURN total_clientes;	
END;
$$ LANGUAGE plpgsql;


-- Exemplo de uso da função para obter o número de clientes cadastrados em uma data específica
SELECT cad_clientes_por_dia('2023-11-02') AS "Total Clientes Cadastrados Dia";