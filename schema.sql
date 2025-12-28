-- Criação de tipos enumerados para garantir a consistência dos status.
CREATE TYPE order_status AS ENUM ('RECEBIDO', 'EM_PREPARACAO', 'PRONTO', 'FINALIZADO', 'CANCELADO');
CREATE TYPE payment_status AS ENUM ('PENDENTE', 'PAGO', 'RECUSADO');

-- Tabela para as categorias dos produtos.
CREATE TABLE category (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- Tabela para os clientes.
CREATE TABLE customer (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    cpf VARCHAR(11) NOT NULL UNIQUE,
    -- Garante que o CPF contenha apenas 11 dígitos numéricos.
    CONSTRAINT chk_cpf CHECK (cpf ~ '^[0-9]{11}$')
);

-- Tabela para os produtos.
CREATE TABLE product (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price NUMERIC(10, 2) NOT NULL,
    description TEXT,
    image_url VARCHAR(255),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    category_id BIGINT NOT NULL,
    -- Chave estrangeira que garante a integridade referencial com a tabela 'category'.
    CONSTRAINT fk_product_category
        FOREIGN KEY (category_id)
        REFERENCES category (id)
);

-- Tabela para os pedidos.
CREATE TABLE orders (
    id BIGSERIAL PRIMARY KEY,
    total_price NUMERIC(10, 2) NOT NULL,
    status order_status NOT NULL DEFAULT 'RECEBIDO',
    payment_status payment_status NOT NULL DEFAULT 'PENDENTE',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(), -- Armazena data, hora e fuso horário.
    customer_id BIGINT, -- Permite pedidos de clientes não identificados (pode ser nulo).
    -- Chave estrangeira que garante a integridade referencial com a tabela 'customer'.
    CONSTRAINT fk_order_customer
        FOREIGN KEY (customer_id)
        REFERENCES customer (id)
);

-- Tabela associativa para os itens de um pedido (solução para o problema da normalização).
CREATE TABLE order_items (
    id BIGSERIAL PRIMARY KEY,
    quantity INTEGER NOT NULL DEFAULT 1,
    -- Armazena o preço do produto no momento da compra para manter a consistência histórica.
    unit_price NUMERIC(10, 2) NOT NULL,
    order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    -- Chaves estrangeiras.
    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id)
        REFERENCES orders (id) ON DELETE CASCADE, -- Se um pedido for deletado, seus itens também serão.
    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id)
        REFERENCES product (id) ON DELETE RESTRICT, -- Impede que um produto seja deletado se estiver em um pedido.
    -- Garante que o mesmo produto não seja adicionado duas vezes no mesmo pedido.
    UNIQUE (order_id, product_id)
);

INSERT INTO category (id, name) VALUES
  (1, 'Lanche'),
  (2, 'Acompanhamento'),
  (3, 'Bebidas'),
  (4, 'Sobremesa')
ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name; -- Isso ajuda a lidar com IDs já existentes

INSERT INTO product (name, price, category, description, image, active) VALUES
  ('Cheeseburger Clássico', 3500, 1, 'Hambúrguer de carne, queijo cheddar, alface, tomate e molho especial.', 'https://example.com/images/cheeseburger.jpg', TRUE),
  ('Sanduíche Natural de Frango', 2800, 1, 'Pão integral, frango desfiado, ricota, cenoura e mix de folhas.', 'https://example.com/images/sanduiche-natural.jpg', TRUE),
  ('Pizza Calabresa (fatia)', 1500, 1, 'Fatia generosa de pizza com molho de tomate, queijo e calabresa.', 'https://example.com/images/pizza-calabresa.jpg', TRUE),
  ('Hot Dog Simples', 1200, 1, 'Salsicha, pão e mostarda.', 'https://example.com/images/hotdog.jpg', TRUE);


INSERT INTO product (name, price, category, description, image, active) VALUES
  ('Batata Frita Grande', 1800, 2, 'Porção generosa de batatas fritas crocantes.', 'https://example.com/images/batata-frita.jpg', TRUE),
  ('Anéis de Cebola', 2000, 2, 'Porção de anéis de cebola empanados e fritos.', 'https://example.com/images/aneis-cebola.jpg', TRUE),
  ('Salada Caesar', 2200, 2, 'Alface americana, croutons, queijo parmesão e molho Caesar.', 'https://example.com/images/salada-caesar.jpg', TRUE),
  ('Pão de Queijo (6 unidades)', 1000, 2, 'Seis unidades de pão de queijo quentinho e crocante.', 'https://example.com/images/pao-queijo.jpg', TRUE);


INSERT INTO product (name, price, category, description, image, active) VALUES
  ('Refrigerante Lata', 800, 3, 'Lata de refrigerante de sua escolha (Coca-Cola, Guaraná, Soda).', 'https://example.com/images/refrigerante.jpg', TRUE),
  ('Suco Natural de Laranja', 1200, 3, 'Suco natural de laranja, fresco e sem adição de açúcares.', 'https://example.com/images/suco-laranja.jpg', TRUE),
  ('Água Mineral 500ml', 500, 3, 'Garrafa de água mineral sem gás.', 'https://example.com/images/agua-mineral.jpg', TRUE),
  ('Café Expresso', 700, 3, 'Pequena xícara de café expresso.', 'https://example.com/images/cafe-expresso.jpg', TRUE);


INSERT INTO product (name, price, category, description, image, active) VALUES
  ('Brownie com Sorvete', 2500, 4, 'Brownie de chocolate quentinho servido com uma bola de sorvete de creme.', 'https://example.com/images/brownie-sorvete.jpg', TRUE),
  ('Mousse de Maracujá', 1800, 4, 'Cremosa mousse de maracujá com cobertura de sementes da fruta.', 'https://example.com/images/mousse-maracuja.jpg', TRUE),
  ('Pudim de Leite Condensado', 1600, 4, 'Fatia de pudim de leite condensado com calda de caramelo.', 'https://example.com/images/pudim.jpg', TRUE),
  ('Açaí Pequeno', 2000, 4, 'Creme de açaí puro com granola e banana.', 'https://example.com/images/acai.jpg', TRUE);

INSERT INTO customer (name, email, cpf) VALUES
  ('João Silva', 'joao.silva@email.com', 12345678901),
  ('Maria Souza', 'maria.souza@email.com', 98765432109),
  ('Carlos Ferreira', NULL, 11223344556), -- Exemplo com email nulo
  ('Ana Costa', 'ana.costa@email.com', 65432109876);


INSERT INTO "orderqueue" (idcustomer, step, date, time, price, details) VALUES
  (1, 'RECEBIDO', '2025-06-04', '14:30:00', 7500, '1 Cheeseburger Clássico, 1 Batata Frita Grande, 1 Refrigerante Lata'),
  (2, 'RECEBIDO', '2025-06-04', '15:15:00', 4300, '1 Sanduíche Natural de Frango, 1 Suco Natural de Laranja, 1 Mousse de Maracujá');