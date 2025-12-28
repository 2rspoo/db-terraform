CREATE TABLE customer (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    cpf VARCHAR(11) NOT NULL UNIQUE,
    CONSTRAINT chk_cpf CHECK (cpf ~ '^[0-9]{11}$')
);

-- Dados iniciais de Clientes
INSERT INTO customer (name, email, cpf) VALUES
  ('João Silva', 'joao.silva@email.com', '12345678901'),
  ('Maria Souza', 'maria.souza@email.com', '98765432109'),
  ('Carlos Ferreira', NULL, '11223344556'),
  ('Ana Costa', 'ana.costa@email.com', '65432109876');