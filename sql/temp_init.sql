-- ============================================
-- 进销存管理系统 - 数据库初始化脚本
-- ============================================

-- 系统管理模块
CREATE TABLE IF NOT EXISTS t_role (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name`   VARCHAR(50)  NOT NULL COMMENT '角色名称',
  `role_code`   VARCHAR(50)  NOT NULL COMMENT '角色编码',
  `description` VARCHAR(200) DEFAULT NULL COMMENT '描述',
  `status`      TINYINT(1)   NOT NULL DEFAULT 1 COMMENT '状态 0-禁用 1-正常',
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_by`   BIGINT       DEFAULT NULL,
  `is_deleted`  TINYINT(1)   NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_role_code` (`role_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色表';

CREATE TABLE IF NOT EXISTS t_menu (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `parent_id`   BIGINT       NOT NULL DEFAULT 0 COMMENT '父级ID',
  `menu_name`   VARCHAR(50)  NOT NULL COMMENT '菜单名称',
  `menu_type`   TINYINT      NOT NULL DEFAULT 1 COMMENT '类型 1-目录 2-菜单 3-按钮',
  `path`        VARCHAR(200) DEFAULT NULL COMMENT '路由路径',
  `component`   VARCHAR(200) DEFAULT NULL COMMENT '前端组件路径',
  `icon`        VARCHAR(100) DEFAULT NULL COMMENT '图标',
  `perms`       VARCHAR(100) DEFAULT NULL COMMENT '权限标识',
  `sort`        INT          NOT NULL DEFAULT 0 COMMENT '排序',
  `visible`     TINYINT(1)   NOT NULL DEFAULT 1 COMMENT '是否显示',
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_by`   BIGINT       DEFAULT NULL,
  `is_deleted`  TINYINT(1)   NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='菜单权限表';

CREATE TABLE IF NOT EXISTS t_role_menu (
  `id`      BIGINT NOT NULL AUTO_INCREMENT,
  `role_id` BIGINT NOT NULL,
  `menu_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_role_id` (`role_id`),
  KEY `idx_menu_id` (`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色菜单关联表';

CREATE TABLE IF NOT EXISTS t_user (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username`    VARCHAR(50)  NOT NULL COMMENT '用户名',
  `password`    VARCHAR(100) NOT NULL COMMENT '密码',
  `real_name`   VARCHAR(50)  DEFAULT NULL COMMENT '真实姓名',
  `phone`       VARCHAR(20)  DEFAULT NULL COMMENT '手机号',
  `email`       VARCHAR(100) DEFAULT NULL COMMENT '邮箱',
  `avatar`      VARCHAR(255) DEFAULT NULL COMMENT '头像',
  `status`      TINYINT(1)   NOT NULL DEFAULT 1 COMMENT '状态 0-禁用 1-正常',
  `role_id`     BIGINT       DEFAULT NULL COMMENT '角色ID',
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_by`   BIGINT       DEFAULT NULL,
  `is_deleted`  TINYINT(1)   NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`),
  KEY `idx_role_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

CREATE TABLE IF NOT EXISTS t_operation_log (
  `id`             BIGINT       NOT NULL AUTO_INCREMENT,
  `user_id`        BIGINT       DEFAULT NULL,
  `username`       VARCHAR(50)  DEFAULT NULL,
  `operation`      VARCHAR(100) DEFAULT NULL,
  `method`         VARCHAR(200) DEFAULT NULL,
  `request_url`    VARCHAR(300) DEFAULT NULL,
  `request_method` VARCHAR(10)  DEFAULT NULL,
  `request_params` TEXT         DEFAULT NULL,
  `response_result`TEXT         DEFAULT NULL,
  `ip`             VARCHAR(50)  DEFAULT NULL,
  `status`         TINYINT      DEFAULT 1,
  `error_msg`      TEXT         DEFAULT NULL,
  `cost_time`      BIGINT       DEFAULT NULL,
  `create_time`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='操作日志表';

-- 基础数据模块
CREATE TABLE IF NOT EXISTS t_category (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `category_name` VARCHAR(100) NOT NULL COMMENT '分类名称',
  `parent_id`   BIGINT       NOT NULL DEFAULT 0 COMMENT '父级分类ID',
  `sort`        INT          NOT NULL DEFAULT 0 COMMENT '排序',
  `remark`      VARCHAR(500) DEFAULT NULL COMMENT '备注',
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_by`   BIGINT       DEFAULT NULL,
  `is_deleted`  TINYINT(1)   NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品分类表';

CREATE TABLE IF NOT EXISTS t_product (
  `id`            BIGINT        NOT NULL AUTO_INCREMENT COMMENT '商品ID',
  `product_name`  VARCHAR(200)  NOT NULL COMMENT '商品名称',
  `product_code`  VARCHAR(50)   DEFAULT NULL COMMENT '商品编码',
  `category_id`   BIGINT        DEFAULT NULL COMMENT '分类ID',
  `spec`          VARCHAR(200)  DEFAULT NULL COMMENT '规格型号',
  `unit`          VARCHAR(20)   DEFAULT NULL COMMENT '单位(个/箱/kg)',
  `purchase_price` DECIMAL(10,2) DEFAULT 0.00 COMMENT '采购价',
  `sale_price`    DECIMAL(10,2) DEFAULT 0.00 COMMENT '销售价',
  `image`         VARCHAR(500)  DEFAULT NULL COMMENT '商品图片',
  `remark`        VARCHAR(500)  DEFAULT NULL COMMENT '备注',
  `status`        TINYINT(1)    NOT NULL DEFAULT 1 COMMENT '状态 0-停用 1-启用',
  `min_stock`     INT           NOT NULL DEFAULT 0 COMMENT '最低库存预警',
  `max_stock`     INT           NOT NULL DEFAULT 0 COMMENT '最高库存预警(0为不限)',
  `create_time`   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_by`     BIGINT        DEFAULT NULL,
  `is_deleted`    TINYINT(1)    NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_product_code` (`product_code`),
  KEY `idx_category_id` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品信息表';

CREATE TABLE IF NOT EXISTS t_supplier (
  `id`            BIGINT       NOT NULL AUTO_INCREMENT COMMENT '供应商ID',
  `supplier_name` VARCHAR(200) NOT NULL COMMENT '供应商名称',
  `contact_person` VARCHAR(50) DEFAULT NULL COMMENT '联系人',
  `phone`         VARCHAR(20)  DEFAULT NULL COMMENT '联系电话',
  `address`       VARCHAR(500) DEFAULT NULL COMMENT '地址',
  `remark`        VARCHAR(500) DEFAULT NULL COMMENT '备注',
  `status`        TINYINT(1)   NOT NULL DEFAULT 1 COMMENT '状态',
  `create_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_by`     BIGINT       DEFAULT NULL,
  `is_deleted`    TINYINT(1)   NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='供应商表';

CREATE TABLE IF NOT EXISTS t_customer (
  `id`            BIGINT       NOT NULL AUTO_INCREMENT COMMENT '客户ID',
  `customer_name` VARCHAR(200) NOT NULL COMMENT '客户名称',
  `contact_person` VARCHAR(50) DEFAULT NULL COMMENT '联系人',
  `phone`         VARCHAR(20)  DEFAULT NULL COMMENT '联系电话',
  `address`       VARCHAR(500) DEFAULT NULL COMMENT '地址',
  `remark`        VARCHAR(500) DEFAULT NULL COMMENT '备注',
  `status`        TINYINT(1)   NOT NULL DEFAULT 1 COMMENT '状态',
  `create_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_by`     BIGINT       DEFAULT NULL,
  `is_deleted`    TINYINT(1)   NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='客户表';

-- 采购管理模块
CREATE TABLE IF NOT EXISTS t_purchase_order (
  `id`              BIGINT       NOT NULL AUTO_INCREMENT COMMENT '采购单ID',
  `order_no`        VARCHAR(50)  NOT NULL COMMENT '采购单号',
  `supplier_id`     BIGINT       DEFAULT NULL COMMENT '供应商ID',
  `total_amount`    DECIMAL(12,2) DEFAULT 0.00 COMMENT '总金额',
  `status`          TINYINT      NOT NULL DEFAULT 0 COMMENT '状态 0-待入库 1-已入库 2-已退货',
  `remark`          VARCHAR(500) DEFAULT NULL COMMENT '备注',
  `operator`        VARCHAR(50)  DEFAULT NULL COMMENT '经办人',
  `order_date`      DATE         DEFAULT NULL COMMENT '采购日期',
  `create_time`     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_by`       BIGINT       DEFAULT NULL,
  `is_deleted`      TINYINT(1)   NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_order_no` (`order_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='采购订单表';

CREATE TABLE IF NOT EXISTS t_purchase_order_item (
  `id`              BIGINT        NOT NULL AUTO_INCREMENT,
  `order_id`        BIGINT        NOT NULL COMMENT '采购单ID',
  `product_id`      BIGINT        NOT NULL COMMENT '商品ID',
  `quantity`        INT           NOT NULL DEFAULT 0 COMMENT '数量',
  `unit_price`      DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '单价',
  `total_price`     DECIMAL(12,2) NOT NULL DEFAULT 0.00 COMMENT '小计',
  `remark`          VARCHAR(500)  DEFAULT NULL COMMENT '备注',
  `create_time`     DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_order_id` (`order_id`),
  KEY `idx_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='采购订单明细表';

-- 销售管理模块
CREATE TABLE IF NOT EXISTS t_sales_order (
  `id`              BIGINT       NOT NULL AUTO_INCREMENT COMMENT '销售单ID',
  `order_no`        VARCHAR(50)  NOT NULL COMMENT '销售单号',
  `customer_id`     BIGINT       DEFAULT NULL COMMENT '客户ID',
  `total_amount`    DECIMAL(12,2) DEFAULT 0.00 COMMENT '总金额',
  `status`          TINYINT      NOT NULL DEFAULT 0 COMMENT '状态 0-待出库 1-已出库 2-已退货',
  `remark`          VARCHAR(500) DEFAULT NULL COMMENT '备注',
  `operator`        VARCHAR(50)  DEFAULT NULL COMMENT '经办人',
  `order_date`      DATE         DEFAULT NULL COMMENT '销售日期',
  `create_time`     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_by`       BIGINT       DEFAULT NULL,
  `is_deleted`      TINYINT(1)   NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sales_order_no` (`order_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='销售订单表';

CREATE TABLE IF NOT EXISTS t_sales_order_item (
  `id`              BIGINT        NOT NULL AUTO_INCREMENT,
  `order_id`        BIGINT        NOT NULL COMMENT '销售单ID',
  `product_id`      BIGINT        NOT NULL COMMENT '商品ID',
  `quantity`        INT           NOT NULL DEFAULT 0 COMMENT '数量',
  `unit_price`      DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '单价',
  `total_price`     DECIMAL(12,2) NOT NULL DEFAULT 0.00 COMMENT '小计',
  `remark`          VARCHAR(500)  DEFAULT NULL COMMENT '备注',
  `create_time`     DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_sales_order_id` (`order_id`),
  KEY `idx_sales_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='销售订单明细表';

-- 库存管理模块
CREATE TABLE IF NOT EXISTS t_inventory (
  `id`             BIGINT        NOT NULL AUTO_INCREMENT,
  `product_id`     BIGINT        NOT NULL COMMENT '商品ID',
  `quantity`       INT           NOT NULL DEFAULT 0 COMMENT '当前库存数量',
  `create_time`    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='库存表';

CREATE TABLE IF NOT EXISTS t_inventory_record (
  `id`             BIGINT        NOT NULL AUTO_INCREMENT,
  `product_id`     BIGINT        NOT NULL COMMENT '商品ID',
  `type`           TINYINT       NOT NULL COMMENT '类型 1-入库 2-出库 3-盘点调整',
  `quantity`       INT           NOT NULL COMMENT '变动数量(正数入库/负数出库)',
  `before_quantity` INT          NOT NULL DEFAULT 0 COMMENT '变动前数量',
  `after_quantity`  INT          NOT NULL DEFAULT 0 COMMENT '变动后数量',
  `reference_no`   VARCHAR(50)  DEFAULT NULL COMMENT '关联单号',
  `remark`         VARCHAR(500) DEFAULT NULL COMMENT '备注',
  `create_by`      BIGINT       DEFAULT NULL,
  `create_time`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_product_id` (`product_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='库存变动记录表';

-- ============================================
-- 初始化数据
-- ============================================
INSERT INTO t_role (role_name, role_code, description) VALUES
('超级管理员', 'ADMIN', '拥有所有权限'),
('采购员', 'PURCHASE', '采购管理权限'),
('销售员', 'SALES', '销售管理权限'),
('仓库管理员', 'WAREHOUSE', '库存管理权限');

INSERT INTO t_user (username, password, real_name, role_id) VALUES
('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EH', '管理员', 1);

INSERT INTO t_category (category_name, parent_id, sort) VALUES
('电子产品', 0, 1), ('办公用品', 0, 2), ('食品饮料', 0, 3),
('电脑', 1, 1), ('手机配件', 1, 2);

INSERT INTO t_supplier (supplier_name, contact_person, phone, address) VALUES
('深圳华强电子有限公司', '张经理', '13800138001', '深圳市福田区华强北路'),
('广州办公用品批发中心', '李经理', '13800138002', '广州市天河区天河路');

INSERT INTO t_customer (customer_name, contact_person, phone, address) VALUES
('北京科技有限公司', '王总', '13900139001', '北京市海淀区中关村'),
('上海贸易有限公司', '赵总', '13900139002', '上海市浦东新区陆家嘴');

INSERT INTO t_product (product_name, product_code, category_id, spec, unit, purchase_price, sale_price, min_stock) VALUES
('联想ThinkPad X1', 'P001', 4, 'i7/16G/512G', '台', 6800.00, 8999.00, 5),
('苹果iPhone 15', 'P002', 5, '256G 黑色', '台', 5500.00, 6999.00, 10),
('得力A4打印纸', 'P003', 2, '500张/包', '箱', 20.00, 35.00, 50),
('农夫山泉矿泉水', 'P004', 3, '550ml*24瓶', '箱', 28.00, 48.00, 30);