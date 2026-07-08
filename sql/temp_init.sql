-- ============================================
-- ERP System - Database Init Script
-- ============================================

CREATE TABLE IF NOT EXISTS t_role (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT,
  `role_name`   VARCHAR(50)  NOT NULL,
  `role_code`   VARCHAR(50)  NOT NULL,
  `description` VARCHAR(200) DEFAULT NULL,
  `status`      TINYINT(1)   NOT NULL DEFAULT 1,
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_by`   BIGINT       DEFAULT NULL,
  `is_deleted`  TINYINT(1)   NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_role_code` (`role_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS t_menu (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT,
  `parent_id`   BIGINT       NOT NULL DEFAULT 0,
  `menu_name`   VARCHAR(50)  NOT NULL,
  `menu_type`   TINYINT      NOT NULL DEFAULT 1,
  `path`        VARCHAR(200) DEFAULT NULL,
  `component`   VARCHAR(200) DEFAULT NULL,
  `icon`        VARCHAR(100) DEFAULT NULL,
  `perms`       VARCHAR(100) DEFAULT NULL,
  `sort`        INT          NOT NULL DEFAULT 0,
  `visible`     TINYINT(1)   NOT NULL DEFAULT 1,
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_by`   BIGINT       DEFAULT NULL,
  `is_deleted`  TINYINT(1)   NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS t_user (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT,
  `username`    VARCHAR(50)  NOT NULL,
  `password`    VARCHAR(100) NOT NULL,
  `real_name`   VARCHAR(50)  DEFAULT NULL,
  `phone`       VARCHAR(20)  DEFAULT NULL,
  `email`       VARCHAR(100) DEFAULT NULL,
  `avatar`      VARCHAR(255) DEFAULT NULL,
  `status`      TINYINT(1)   NOT NULL DEFAULT 1,
  `role_id`     BIGINT       DEFAULT NULL,
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_by`   BIGINT       DEFAULT NULL,
  `is_deleted`  TINYINT(1)   NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS t_category (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT,
  `category_name` VARCHAR(100) NOT NULL,
  `parent_id`   BIGINT       NOT NULL DEFAULT 0,
  `sort`        INT          NOT NULL DEFAULT 0,
  `remark`      VARCHAR(500) DEFAULT NULL,
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_by`   BIGINT       DEFAULT NULL,
  `is_deleted`  TINYINT(1)   NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS t_product (
  `id`            BIGINT        NOT NULL AUTO_INCREMENT,
  `product_name`  VARCHAR(200)  NOT NULL,
  `product_code`  VARCHAR(50)   DEFAULT NULL,
  `category_id`   BIGINT        DEFAULT NULL,
  `spec`          VARCHAR(200)  DEFAULT NULL,
  `unit`          VARCHAR(20)   DEFAULT NULL,
  `purchase_price` DECIMAL(10,2) DEFAULT 0.00,
  `sale_price`    DECIMAL(10,2) DEFAULT 0.00,
  `image`         VARCHAR(500)  DEFAULT NULL,
  `remark`        VARCHAR(500)  DEFAULT NULL,
  `status`        TINYINT(1)    NOT NULL DEFAULT 1,
  `min_stock`     INT           NOT NULL DEFAULT 0,
  `max_stock`     INT           NOT NULL DEFAULT 0,
  `create_time`   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_by`     BIGINT        DEFAULT NULL,
  `is_deleted`    TINYINT(1)    NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_product_code` (`product_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS t_supplier (
  `id`            BIGINT       NOT NULL AUTO_INCREMENT,
  `supplier_name` VARCHAR(200) NOT NULL,
  `contact_person` VARCHAR(50) DEFAULT NULL,
  `phone`         VARCHAR(20)  DEFAULT NULL,
  `address`       VARCHAR(500) DEFAULT NULL,
  `remark`        VARCHAR(500) DEFAULT NULL,
  `status`        TINYINT(1)   NOT NULL DEFAULT 1,
  `create_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_by`     BIGINT       DEFAULT NULL,
  `is_deleted`    TINYINT(1)   NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS t_customer (
  `id`            BIGINT       NOT NULL AUTO_INCREMENT,
  `customer_name` VARCHAR(200) NOT NULL,
  `contact_person` VARCHAR(50) DEFAULT NULL,
  `phone`         VARCHAR(20)  DEFAULT NULL,
  `address`       VARCHAR(500) DEFAULT NULL,
  `remark`        VARCHAR(500) DEFAULT NULL,
  `status`        TINYINT(1)   NOT NULL DEFAULT 1,
  `create_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_by`     BIGINT       DEFAULT NULL,
  `is_deleted`    TINYINT(1)   NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS t_purchase_order (
  `id`              BIGINT       NOT NULL AUTO_INCREMENT,
  `order_no`        VARCHAR(50)  NOT NULL,
  `supplier_id`     BIGINT       DEFAULT NULL,
  `total_amount`    DECIMAL(12,2) DEFAULT 0.00,
  `status`          TINYINT      NOT NULL DEFAULT 0,
  `remark`          VARCHAR(500) DEFAULT NULL,
  `operator`        VARCHAR(50)  DEFAULT NULL,
  `order_date`      DATE         DEFAULT NULL,
  `create_time`     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_by`       BIGINT       DEFAULT NULL,
  `is_deleted`      TINYINT(1)   NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_order_no` (`order_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS t_purchase_order_item (
  `id`              BIGINT        NOT NULL AUTO_INCREMENT,
  `order_id`        BIGINT        NOT NULL,
  `product_id`      BIGINT        NOT NULL,
  `quantity`        INT           NOT NULL DEFAULT 0,
  `unit_price`      DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `total_price`     DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  `remark`          VARCHAR(500)  DEFAULT NULL,
  `create_time`     DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS t_sales_order (
  `id`              BIGINT       NOT NULL AUTO_INCREMENT,
  `order_no`        VARCHAR(50)  NOT NULL,
  `customer_id`     BIGINT       DEFAULT NULL,
  `total_amount`    DECIMAL(12,2) DEFAULT 0.00,
  `status`          TINYINT      NOT NULL DEFAULT 0,
  `remark`          VARCHAR(500) DEFAULT NULL,
  `operator`        VARCHAR(50)  DEFAULT NULL,
  `order_date`      DATE         DEFAULT NULL,
  `create_time`     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_by`       BIGINT       DEFAULT NULL,
  `is_deleted`      TINYINT(1)   NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sales_order_no` (`order_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS t_sales_order_item (
  `id`              BIGINT        NOT NULL AUTO_INCREMENT,
  `order_id`        BIGINT        NOT NULL,
  `product_id`      BIGINT        NOT NULL,
  `quantity`        INT           NOT NULL DEFAULT 0,
  `unit_price`      DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `total_price`     DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  `remark`          VARCHAR(500)  DEFAULT NULL,
  `create_time`     DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_sales_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS t_inventory (
  `id`             BIGINT        NOT NULL AUTO_INCREMENT,
  `product_id`     BIGINT        NOT NULL,
  `quantity`       INT           NOT NULL DEFAULT 0,
  `create_time`    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS t_inventory_record (
  `id`             BIGINT        NOT NULL AUTO_INCREMENT,
  `product_id`     BIGINT        NOT NULL,
  `type`           TINYINT       NOT NULL,
  `quantity`       INT           NOT NULL,
  `before_quantity` INT          NOT NULL DEFAULT 0,
  `after_quantity`  INT          NOT NULL DEFAULT 0,
  `reference_no`   VARCHAR(50)  DEFAULT NULL,
  `remark`         VARCHAR(500) DEFAULT NULL,
  `create_by`      BIGINT       DEFAULT NULL,
  `create_time`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO t_role (role_name, role_code, description) VALUES
('Admin', 'ADMIN', 'All permissions'),
('Purchase', 'PURCHASE', 'Purchase management'),
('Sales', 'SALES', 'Sales management'),
('Warehouse', 'WAREHOUSE', 'Inventory management');

INSERT INTO t_user (username, password, real_name, role_id) VALUES
('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EH', 'Admin', 1);

INSERT INTO t_category (category_name, parent_id, sort) VALUES
('Electronics', 0, 1), ('Office', 0, 2), ('Food', 0, 3);

INSERT INTO t_supplier (supplier_name, contact_person, phone, address) VALUES
('Shenzhen Tech Co', 'Zhang', '13800138001', 'Shenzhen');

INSERT INTO t_customer (customer_name, contact_person, phone, address) VALUES
('Beijing Tech Ltd', 'Wang', '13900139001', 'Beijing');

INSERT INTO t_product (product_name, product_code, category_id, spec, unit, purchase_price, sale_price, min_stock) VALUES
('ThinkPad X1', 'P001', 1, 'i7/16G/512G', 'unit', 6800.00, 8999.00, 5);