CREATE DATABASE TESTE_BDMG

CREATE TABLE CLIENTES 
(
    CODIGO          INTEGER NOT NULL,
    NOME            VARCHAR(100),
    CPF             VARCHAR(11),
    DATA_NASCIMENTO DATE,
    ATIVO           CHAR(1),
    CONSTRAINT CLIENTES_PK PRIMARY KEY (CODIGO)
)


CREATE TABLE FORNECEDORES 
(
    CODIGO          INTEGER NOT NULL,
    NOME_FANTASIA   VARCHAR(50),
    RAZAO_SOCIAL    VARCHAR(100),
    CNPJ            VARCHAR(14),
    ATIVO           CHAR(1),
    CONSTRAINT FORNECEDORES_PK PRIMARY KEY (CODIGO)
)


CREATE TABLE PRODUTOS 
(
    CODIGO          INTEGER NOT NULL,
    DESCRICAO       VARCHAR(120),
    PRECO_UNITARIO  NUMERIC(9,2),
    COD_FORNECEDOR  INTEGER,
    ATIVO           CHAR(1),
    CONSTRAINT PRODUTOS_PK PRIMARY KEY (CODIGO),
    CONSTRAINT PRODUTO_FORNECEDOR_FK FOREIGN KEY (COD_FORNECEDOR) REFERENCES FORNECEDORES (CODIGO)
)


CREATE TABLE VENDAS
(
    NUMERO       INTEGER NOT NULL,
    COD_CLIENTE  INTEGER,
    DATA_HORA    DATETIME,
    VALOR_TOTAL  NUMERIC(9,2),
    STATUS       CHAR(1),
    CONSTRAINT VENDAS_PK PRIMARY KEY (NUMERO),
    CONSTRAINT VENDA_CLIENTE_FK FOREIGN KEY (COD_CLIENTE) REFERENCES CLIENTES (CODIGO)
)

CREATE TABLE ITENS_VENDA
(
    NUMERO_VENDA  INTEGER NOT NULL,
    NUMERO_ITEM   INTEGER NOT NULL,
    COD_PRODUTO   INTEGER,
    QUANTIDADE    INTEGER,
    VALOR_TOTAL   NUMERIC(9,2),
    CONSTRAINT ITENS_VENDA_PK PRIMARY KEY (NUMERO_VENDA, NUMERO_ITEM),
    CONSTRAINT ITENSVENDA_VENDA_FK FOREIGN KEY (NUMERO_VENDA) REFERENCES VENDAS (NUMERO),
    CONSTRAINT ITENSVENDA_PRODUTO_FK FOREIGN KEY (COD_PRODUTO) REFERENCES PRODUTOS (CODIGO)
)