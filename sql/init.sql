-- ERP System Database
CREATE DATABASE IF NOT EXISTS erp_system DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE erp_system;

-- Users
CREATE TABLE IF NOT EXISTS sys_user (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  display_name VARCHAR(100),
  role VARCHAR(20) DEFAULT 'admin',
  status INT DEFAULT 1,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Products
CREATE TABLE IF NOT EXISTS product (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(200) NOT NULL,
  sku VARCHAR(100) NOT NULL UNIQUE,
  category VARCHAR(100),
  unit VARCHAR(20) DEFAULT '个',
  price DECIMAL(10,2) DEFAULT 0,
  cost_price DECIMAL(10,2) DEFAULT 0,
  stock INT DEFAULT 0,
  min_stock INT DEFAULT 0,
  description TEXT,
  status INT DEFAULT 1,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Suppliers
CREATE TABLE IF NOT EXISTS supplier (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(200) NOT NULL,
  contact VARCHAR(100),
  phone VARCHAR(50),
  email VARCHAR(200),
  address VARCHAR(500),
  remark TEXT,
  status INT DEFAULT 1,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Customers
CREATE TABLE IF NOT EXISTS customer (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(200) NOT NULL,
  contact VARCHAR(100),
  phone VARCHAR(50),
  email VARCHAR(200),
  address VARCHAR(500),
  remark TEXT,
  status INT DEFAULT 1,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Purchase Orders
CREATE TABLE IF NOT EXISTS purchase_order (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  order_no VARCHAR(100) NOT NULL UNIQUE,
  supplier_id BIGINT,
  total_amount DECIMAL(12,2) DEFAULT 0,
  status VARCHAR(20) DEFAULT 'pending',
  remark TEXT,
  created_by VARCHAR(50),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Purchase Order Items
CREATE TABLE IF NOT EXISTS purchase_order_item (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  order_id BIGINT NOT NULL,
  product_id BIGINT,
  quantity INT NOT NULL,
  unit_price DECIMAL(10,2) DEFAULT 0,
  total_price DECIMAL(12,2) DEFAULT 0
);

-- Sales Orders
CREATE TABLE IF NOT EXISTS sales_order (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  order_no VARCHAR(100) NOT NULL UNIQUE,
  customer_id BIGINT,
  total_amount DECIMAL(12,2) DEFAULT 0,
  status VARCHAR(20) DEFAULT 'pending',
  remark TEXT,
  created_by VARCHAR(50),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Sales Order Items
CREATE TABLE IF NOT EXISTS sales_order_item (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  order_id BIGINT NOT NULL,
  product_id BIGINT,
  quantity INT NOT NULL,
  unit_price DECIMAL(10,2) DEFAULT 0,
  total_price DECIMAL(12,2) DEFAULT 0
);

-- Seed data: admin/123456
INSERT INTO sys_user (username, password, display_name, role) VALUES
('admin', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '管理员', 'admin');

INSERT INTO product (name, sku, category, unit, price, cost_price, stock, min_stock) VALUES
('笔记本电脑', 'P001', '电子产品', '台', 5999.00, 4500.00, 50, 10),
('无线鼠标', 'P002', '电子产品', '个', 99.00, 60.00, 200, 30),
('机械键盘', 'P003', '电子产品', '个', 399.00, 250.00, 100, 20),
('A4打印纸', 'P004', '办公用品', '箱', 89.00, 60.00, 300, 50),
('文件夹', 'P005', '办公用品', '个', 12.50, 8.00, 500, 100);

INSERT INTO supplier (name, contact, phone, email, address) VALUES
('深圳科技有限公司', '张三', '13800138001', 'zhang@tech.com', '深圳市南山区'),
('广州商贸有限公司', '李四', '13800138002', 'li@trade.com', '广州市天河区'),
('北京数码商城', '王五', '13800138003', 'wang@digi.com', '北京市海淀区');

INSERT INTO customer (name, contact, phone, email, address) VALUES
('上海贸易公司', '赵六', '13900139001', 'zhao@shanghai.com', '上海市浦东新区'),
('杭州电商平台', '钱七', '13900139002', 'qian@hangzhou.com', '杭州市西湖区'),
('成都零售商行', '孙八', '13900139003', 'sun@chengdu.com', '成都市高新区');

INSERT INTO purchase_order (order_no, supplier_id, total_amount, status, created_by) VALUES
('PO-20240001', 1, 90000.00, 'completed', 'admin'),
('PO-20240002', 2, 26700.00, 'pending', 'admin'),
('PO-20240003', 3, 39900.00, 'draft', 'admin');

INSERT INTO purchase_order_item (order_id, product_id, quantity, unit_price, total_price) VALUES
(1, 1, 20, 4500.00, 90000.00),
(2, 3, 100, 267.00, 26700.00),
(3, 2, 500, 79.80, 39900.00);

INSERT INTO sales_order (order_no, customer_id, total_amount, status, created_by) VALUES
('SO-20240001', 1, 59990.00, 'completed', 'admin'),
('SO-20240002', 2, 49950.00, 'pending', 'admin'),
('SO-20240003', 3, 19980.00, 'draft', 'admin');

INSERT INTO sales_order_item (order_id, product_id, quantity, unit_price, total_price) VALUES
(1, 1, 10, 5999.00, 59990.00),
(2, 2, 500, 99.90, 49950.00),
(3, 3, 50, 399.60, 19980.00);
