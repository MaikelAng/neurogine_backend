SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ============================
-- CATEGORY
-- ============================
DROP TABLE IF EXISTS category;
CREATE TABLE category (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  category_name VARCHAR(255)
) ENGINE=InnoDB CHARSET=utf8mb4;

INSERT INTO category (id, category_name) VALUES
(1,'MIE'),
(2,'NASI');

-- ============================
-- PRODUCT
-- ============================
DROP TABLE IF EXISTS product;
CREATE TABLE product (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  category_id BIGINT,
  name VARCHAR(255),
  price DECIMAL(15,2),
  description VARCHAR(255),

  INDEX idx_category (category_id),
  CONSTRAINT fk_product_category
    FOREIGN KEY (category_id)
    REFERENCES category(id)
) ENGINE=InnoDB CHARSET=utf8mb4;

INSERT INTO product (id, category_id, name, price, description) VALUES
(7,1,'Indomie Goreng',5750,'Indomie Goreng Special Pake Telor'),
(8,1,'Indomie Soto',5000,'Indomie Soto Special'),
(9,2,'Nasi Goreng',25000,'Nasi Goreng Special'),
(11,NULL,'Martabak Bangka Pacenongan',125000,'Martabak serba Tebal'),
(12,NULL,'Speaker',250000,'Speaker JBL');

-- ============================
-- PURCHASE HEADER
-- ============================
DROP TABLE IF EXISTS purchase_header;
CREATE TABLE purchase_header (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  number_po VARCHAR(20) NOT NULL,
  po_date DATETIME(6),
  supplier VARCHAR(255),
  total DECIMAL(15,2),
  ppn DECIMAL(15,2),
  grand_total DECIMAL(15,2),
  UNIQUE KEY uk_number_po (number_po)
) ENGINE=InnoDB CHARSET=utf8mb4;

INSERT INTO purchase_header
(id, number_po, po_date, supplier, total, ppn, grand_total)
VALUES
(2,'P2024080001','2024-08-17 04:43:36','EKO',100,10,110);

-- ============================
-- PURCHASE DETAIL
-- ============================
DROP TABLE IF EXISTS purchase_detail;
CREATE TABLE purchase_detail (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  purchase_id BIGINT NOT NULL,
  stock_code VARCHAR(50),
  stock_name VARCHAR(255),
  stock_price DECIMAL(15,2),
  stock_quantity INT,
  subtotal DECIMAL(15,2),

  INDEX idx_purchase_id (purchase_id),
  CONSTRAINT fk_purchase_detail_header
    FOREIGN KEY (purchase_id)
    REFERENCES purchase_header(id)
) ENGINE=InnoDB CHARSET=utf8mb4;

INSERT INTO purchase_detail
(id, purchase_id, stock_code, stock_name, stock_price, stock_quantity, subtotal)
VALUES
(7,2,'001','INDOMIE GORENG',5500,1,5500),
(8,2,'002','INDOMIE KARI AYAM',4500,1,4500);

SET FOREIGN_KEY_CHECKS = 1;
