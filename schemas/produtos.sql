CREATE TABLE category (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE product (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price NUMERIC(10, 2) NOT NULL,
    description TEXT,
    image_url VARCHAR(255),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    category_id BIGINT NOT NULL,
    CONSTRAINT fk_product_category FOREIGN KEY (category_id) REFERENCES category (id)
);

INSERT INTO category (id, name) VALUES (1, 'Lanche'), (2, 'Acompanhamento'), (3, 'Bebidas'), (4, 'Sobremesa');

INSERT INTO product (name, price, category_id, description, image_url, is_active) VALUES
  ('Cheeseburger Clássico', 35.00, 1, 'Hambúrguer de carne...', 'https://example.com/cheeseburger.jpg', TRUE),
  ('Batata Frita Grande', 18.00, 2, 'Porção generosa...', 'https://example.com/batata.jpg', TRUE);