# ERP 进销存管理系统

基于 Spring Boot 3 + Vue 3 的前后端分离进销存管理系统，涵盖采购、销售、库存、基础数据等核心业务模块。

## 项目简介

本系统是一个轻量级 ERP 进销存管理系统，适用于中小型企业进行商品采购、销售和库存管理。系统采用前后端分离架构，后端提供 RESTful API，前端负责页面渲染和用户交互。

### 核心功能

- **系统管理**：用户管理、角色管理、菜单权限、操作日志
- **基础数据**：商品分类、商品信息、供应商、客户
- **采购管理**：采购订单创建、入库确认、采购退货
- **销售管理**：销售订单创建、出库确认、销售退货
- **库存管理**：实时库存查询、库存预警、库存变动记录
- **数据看板**：销售统计、采购统计、库存概览

## 技术栈

### 后端

| 技术 | 版本 | 说明 |
|------|------|------|
| Java | 17 | LTS 版本 |
| Spring Boot | 3.1.5 | 主框架 |
| MyBatis-Plus | 3.5.5 | ORM 框架，简化 CRUD |
| MySQL | 8.x | 关系型数据库 |
| java-jwt | 4.4.0 | JWT 令牌生成与验证 |
| Lombok | - | 简化 Java 代码 |

### 前端

| 技术 | 版本 | 说明 |
|------|------|------|
| Vue | 3.5.39 | 渐进式 JavaScript 框架 |
| Vite | 6.4.3 | 下一代前端构建工具 |
| TypeScript | 6.0.2 | JavaScript 超集 |
| Element Plus | 2.14.2 | Vue 3 UI 组件库 |
| Pinia | 3.0.4 | Vue 状态管理 |
| Vue Router | 4.6.4 | 路由管理 |
| Axios | 1.18.1 | HTTP 客户端 |

## 项目结构

```
erp-system/
├── backend/                          # 后端 Spring Boot 项目
│   └── src/main/java/com/erp/
│       ├── ErpApplication.java       # 启动类
│       ├── common/                   # 公共类（统一响应、异常处理）
│       ├── config/                   # 配置类
│       │   ├── CorsConfig.java       # 跨域配置
│       │   └── MybatisPlusConfig.java # MyBatis-Plus 配置
│       ├── controller/               # 控制器层
│       │   ├── AuthController.java   # 认证登录
│       │   ├── CategoryController.java
│       │   ├── CustomerController.java
│       │   ├── DashboardController.java
│       │   ├── InventoryController.java
│       │   ├── ProductController.java
│       │   ├── PurchaseOrderController.java
│       │   ├── SalesOrderController.java
│       │   └── SupplierController.java
│       ├── dto/                      # 数据传输对象
│       ├── entity/                   # 实体类
│       ├── mapper/                   # MyBatis Mapper 接口
│       ├── security/                 # 安全模块
│       │   ├── JwtUtil.java          # JWT 工具类
│       │   ├── JwtAuthenticationFilter.java
│       │   └── SecurityConfig.java
│       ├── service/                  # 业务逻辑层
│       │   └── impl/                 # Service 实现类
│       └── vo/                       # 视图对象
│
├── frontend/                         # 前端 Vue 3 项目
│   └── src/
│       ├── api/                      # API 接口定义
│       │   ├── auth.ts
│       │   ├── category.ts
│       │   ├── customer.ts
│       │   ├── dashboard.ts
│       │   ├── inventory.ts
│       │   ├── product.ts
│       │   ├── purchase.ts
│       │   ├── sales.ts
│       │   └── supplier.ts
│       ├── layouts/                  # 布局组件
│       ├── router/                   # 路由配置
│       ├── stores/                   # Pinia 状态管理
│       ├── utils/                    # 工具函数（Axios 封装等）
│       └── views/                    # 页面视图
│           ├── login/                # 登录页
│           ├── dashboard/            # 数据看板
│           ├── product/              # 商品管理
│           ├── customer/             # 客户管理
│           ├── supplier/             # 供应商管理
│           ├── purchase/             # 采购管理
│           ├── sales/                # 销售管理
│           └── inventory/            # 库存管理
│
├── sql/                              # 数据库脚本
│   └── init.sql                      # 建表 + 初始化数据
│
├── pom.xml                           # Maven 父级配置
└── README.md
```

## 数据库设计

### 表结构概览

| 模块 | 表名 | 说明 |
|------|------|------|
| 系统管理 | t_role | 角色表 |
| | t_menu | 菜单权限表 |
| | t_role_menu | 角色菜单关联表 |
| | t_user | 用户表 |
| | t_operation_log | 操作日志表 |
| 基础数据 | t_category | 商品分类表（支持多级） |
| | t_product | 商品信息表 |
| | t_supplier | 供应商表 |
| | t_customer | 客户表 |
| 采购管理 | t_purchase_order | 采购订单表 |
| | t_purchase_order_item | 采购订单明细表 |
| 销售管理 | t_sales_order | 销售订单表 |
| | t_sales_order_item | 销售订单明细表 |
| 库存管理 | t_inventory | 库存表 |
| | t_inventory_record | 库存变动记录表 |

### ER 关系

```
t_user ──┐
         ├── t_role ── t_role_menu ── t_menu
t_role ──┘

t_product ── t_category
t_product ── t_inventory
t_product ── t_inventory_record

t_purchase_order ── t_supplier
t_purchase_order ── t_purchase_order_item ── t_product

t_sales_order ── t_customer
t_sales_order ── t_sales_order_item ── t_product
```

## 快速开始

### 环境要求

- JDK 17+
- Node.js 18+
- MySQL 8.0+
- Maven 3.8+

### 1. 初始化数据库

```bash
# 登录 MySQL
mysql -u root -p

# 执行初始化脚本
source sql/init.sql
```

默认管理员账号：`admin` / `123456`

### 2. 启动后端

```bash
cd backend

# 修改数据库配置（如需要）
# vim src/main/resources/application.yml

# 编译并启动
mvn spring-boot:run
```

后端启动地址：`http://localhost:8080`

### 3. 启动前端

```bash
cd frontend

# 安装依赖
npm install

# 启动开发服务器
npm run dev
```

前端启动地址：`http://localhost:5173`

### 4. 配置说明

#### 后端配置 (application.yml)

```yaml
server:
  port: 8080

spring:
  datasource:
    url: jdbc:mysql://localhost:3306/erp_system
    username: root
    password: 123456

jwt:
  secret: your-jwt-secret-key
  expiration: 86400000  # 24小时
```

#### 前端代理配置 (vite.config.ts)

开发环境下，前端通过 Vite 代理将 `/api` 请求转发到后端 `http://localhost:8080`。

## API 接口

### 认证接口

| 方法 | 路径 | 说明 |
|------|------|------|
| POST | /api/auth/login | 用户登录 |
| GET | /api/auth/info | 获取当前用户信息 |

### 业务接口

| 模块 | 方法 | 路径 | 说明 |
|------|------|------|------|
| 商品 | GET/POST | /api/products | 查询/新增商品 |
| 分类 | GET/POST | /api/categories | 查询/新增分类 |
| 供应商 | GET/POST | /api/suppliers | 查询/新增供应商 |
| 客户 | GET/POST | /api/customers | 查询/新增客户 |
| 采购 | GET/POST | /api/purchase-orders | 查询/新增采购单 |
| 采购入库 | PUT | /api/purchase-orders/{id}/receive | 采购入库 |
| 销售 | GET/POST | /api/sales-orders | 查询/新增销售单 |
| 销售出库 | PUT | /api/sales-orders/{id}/ship | 销售出库 |
| 库存 | GET | /api/inventory | 查询库存列表 |
| 看板 | GET | /api/dashboard/stats | 获取统计数据 |

所有业务接口需要在请求头中携带 JWT Token：

```
Authorization: Bearer <token>
```

## 功能特性

### 已实现

- JWT 登录认证
- 角色权限控制（管理员/采购员/销售员/仓库管理员）
- 商品多级分类管理
- 商品 CRUD + 库存预警设置
- 供应商/客户管理
- 采购订单全流程（创建 → 入库 → 自动更新库存）
- 销售订单全流程（创建 → 出库 → 自动更新库存）
- 库存实时查询 + 变动记录
- 数据看板统计
- 操作日志记录

### 技术亮点

- MyBatis-Plus 逻辑删除，数据安全可恢复
- 采购/销售操作使用事务，保证数据一致性
- 库存变动记录完整审计追踪
- 前端 Axios 封装，统一处理 Token 和错误
- Vue Router 路由守卫，未登录自动跳转

## 开发说明

### 后端开发

实体类使用 Lombok `@Data` 注解，减少样板代码。Mapper 继承 `BaseMapper<T>` 获得基础 CRUD 能力，复杂查询使用 `LambdaQueryWrapper`。

### 前端开发

API 接口按模块拆分到 `src/api/` 目录，页面组件按功能拆分到 `src/views/` 目录。状态管理使用 Pinia，路由守卫在 `src/router/index.ts` 中配置。

## License

[MIT](LICENSE)
