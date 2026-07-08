<template>
  <div>
    <el-row :gutter="16" style="margin-bottom: 16px">
      <el-col v-for="s in stats" :key="s.label" :span="6">
        <el-card shadow="hover">
          <div class="stat-item">
            <div class="stat-value">{{ s.value }}</div>
            <div class="stat-label">{{ s.label }}</div>
          </div>
        </el-card>
      </el-col>
    </el-row>
    <el-row :gutter="16">
      <el-col :span="12">
        <el-card>
          <template #header><span>库存预警</span></template>
          <el-table :data="warnings" border stripe v-loading="loading" max-height="300">
            <el-table-column prop="productName" label="商品" min-width="120" />
            <el-table-column prop="quantity" label="库存" width="60" />
            <el-table-column prop="minStock" label="最低预警" width="80" />
          </el-table>
        </el-card>
      </el-col>
      <el-col :span="12">
        <el-card>
          <template #header><span>快速操作</span></template>
          <div style="display: flex; gap: 12px; flex-wrap: wrap">
            <el-button @click="$router.push('/product')" style="flex:1">商品管理</el-button>
            <el-button @click="$router.push('/purchase')" style="flex:1">采购管理</el-button>
            <el-button @click="$router.push('/sales')" style="flex:1">销售管理</el-button>
            <el-button @click="$router.push('/inventory')" style="flex:1">库存管理</el-button>
            <el-button @click="$router.push('/supplier')" style="flex:1">供应商管理</el-button>
            <el-button @click="$router.push('/customer')" style="flex:1">客户管理</el-button>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { getDashboardStats } from '../../api/dashboard'
import { getInventoryPage, type InventoryItem } from '../../api/inventory'

const loading = ref(false)
const stats = ref<{ label: string; value: string | number }[]>([])
const warnings = ref<InventoryItem[]>([])

async function fetchStats() {
  try {
    const data = await getDashboardStats()
    stats.value = [
      { label: '商品总数', value: (data.productCount as number) ?? '-' },
      { label: '供应商总数', value: (data.supplierCount as number) ?? '-' },
      { label: '客户总数', value: (data.customerCount as number) ?? '-' },
      { label: '库存预警', value: (data.warningCount as number) ?? '-' },
    ]
  } catch { /* empty */ }
}

async function fetchWarnings() {
  loading.value = true
  try {
    const res = await getInventoryPage({ pageNum: 1, pageSize: 100 })
    warnings.value = res.records.filter((i: InventoryItem) => i.quantity <= i.minStock)
  } finally {
    loading.value = false
  }
}

onMounted(() => { fetchStats(); fetchWarnings() })
</script>

<style scoped>
.stat-item { text-align: center; padding: 8px 0; }
.stat-value { font-size: 32px; font-weight: 700; color: #409eff; }
.stat-label { font-size: 14px; color: #666; margin-top: 8px; }
</style>