import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/login',
      name: 'Login',
      component: () => import('../views/login/LoginView.vue'),
    },
    {
      path: '/',
      component: () => import('../layouts/MainLayout.vue'),
      redirect: '/dashboard',
      children: [
        {
          path: 'dashboard',
          name: 'Dashboard',
          component: () => import('../views/dashboard/DashboardView.vue'),
          meta: { title: '首页' },
        },
        {
          path: 'product',
          name: 'Product',
          component: () => import('../views/product/ProductView.vue'),
          meta: { title: '商品管理' },
        },
        {
          path: 'purchase',
          name: 'Purchase',
          component: () => import('../views/purchase/PurchaseView.vue'),
          meta: { title: '采购管理' },
        },
        {
          path: 'sales',
          name: 'Sales',
          component: () => import('../views/sales/SalesView.vue'),
          meta: { title: '销售管理' },
        },
        {
          path: 'inventory',
          name: 'Inventory',
          component: () => import('../views/inventory/InventoryView.vue'),
          meta: { title: '库存管理' },
        },
        {
          path: 'supplier',
          name: 'Supplier',
          component: () => import('../views/supplier/SupplierView.vue'),
          meta: { title: '供应商管理' },
        },
        {
          path: 'customer',
          name: 'Customer',
          component: () => import('../views/customer/CustomerView.vue'),
          meta: { title: '客户管理' },
        },
      ],
    },
  ],
})

router.beforeEach((to, _from, next) => {
  const token = localStorage.getItem('token')
  if (to.path !== '/login' && !token) {
    next('/login')
  } else {
    next()
  }
})

export default router