<template>
  <el-container style="min-height: 100vh">
    <el-aside width="220px" style="background: #304156">
      <div class="logo">
        <h2>进销存管理系统</h2>
      </div>
      <el-menu
        :default-active="route.path"
        background-color="#304156"
        text-color="#bfcbd9"
        active-text-color="#409eff"
        router
      >
        <el-menu-item index="/dashboard">
          <span>首页</span>
        </el-menu-item>
        <el-menu-item index="/product">
          <span>商品管理</span>
        </el-menu-item>
        <el-menu-item index="/purchase">
          <span>采购管理</span>
        </el-menu-item>
        <el-menu-item index="/sales">
          <span>销售管理</span>
        </el-menu-item>
        <el-menu-item index="/inventory">
          <span>库存管理</span>
        </el-menu-item>
        <el-menu-item index="/supplier">
          <span>供应商管理</span>
        </el-menu-item>
        <el-menu-item index="/customer">
          <span>客户管理</span>
        </el-menu-item>
      </el-menu>
    </el-aside>
    <el-container>
      <el-header style="background: #fff; border-bottom: 1px solid #e6e6e6; display: flex; align-items: center; justify-content: space-between">
        <span style="font-size: 16px; font-weight: 600">{{ route.meta.title }}</span>
        <div>
          <span style="margin-right: 16px">{{ authStore.userInfo?.realName || authStore.userInfo?.username }}</span>
          <el-button type="danger" size="small" @click="handleLogout">退出登录</el-button>
        </div>
      </el-header>
      <el-main style="background: #f0f2f5">
        <router-view />
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup lang="ts">
import { useRoute, useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()

function handleLogout() {
  authStore.logout()
  router.push('/login')
}
</script>

<style scoped>
.logo {
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
}
.logo h2 {
  color: #fff;
  font-size: 18px;
  margin: 0;
  font-weight: 600;
}
</style>