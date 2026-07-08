<template>
  <div>
    <el-card>
      <template #header>
        <div class="page-header">
          <span>库存管理</span>
        </div>
      </template>
      <div class="search-bar">
        <el-input v-model="query.keyword" placeholder="搜索商品名称/编码" clearable style="width: 300px" @clear="search" @keyup.enter="search" />
        <el-button type="primary" style="margin-left: 12px" @click="search">搜索</el-button>
      </div>
      <el-table :data="list" border stripe v-loading="loading">
        <el-table-column prop="productName" label="商品名称" min-width="140" />
        <el-table-column prop="productCode" label="商品编码" width="120" />
        <el-table-column prop="spec" label="规格" width="120" />
        <el-table-column prop="unit" label="单位" width="60" />
        <el-table-column prop="quantity" label="当前库存" width="100" align="right">
          <template #default="{ row }">
            <el-tag v-if="row.quantity <= row.minStock" type="danger">{{ row.quantity }}</el-tag>
            <span v-else>{{ row.quantity }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="minStock" label="最低预警" width="80" align="right" />
        <el-table-column label="库存状态" width="100" align="center">
          <template #default="{ row }">
            <el-tag v-if="row.quantity <= row.minStock" type="danger" size="small">库存不足</el-tag>
            <el-tag v-else type="success" size="small">正常</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="120" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link size="small" @click="openAdjust(row)">调整</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="pagination-wrap">
        <el-pagination v-model:page-size="query.pageSize" v-model:current-page="query.pageNum" :total="total" layout="total, prev, pager, next" @current-change="fetchData" />
      </div>
    </el-card>

    <el-dialog v-model="adjustVisible" title="库存调整" width="400px" :close-on-click-modal="false">
      <el-form ref="adjustFormRef" :model="adjustForm" :rules="adjustRules" label-width="100px">
        <el-form-item label="商品名称">
          <el-input :model-value="adjustForm.productName" disabled />
        </el-form-item>
        <el-form-item label="当前库存">
          <el-input :model-value="adjustForm.currentQty" disabled />
        </el-form-item>
        <el-form-item label="调整数量" prop="quantity">
          <el-input-number v-model="adjustForm.quantity" style="width: 100%" />
        </el-form-item>
        <div style="color: #999; font-size: 12px; margin-top: -16px; margin-bottom: 16px; padding-left: 100px">正数=入库，负数=出库</div>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="adjustForm.remark" type="textarea" :rows="2" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="adjustVisible = false">取消</el-button>
        <el-button type="primary" :loading="adjustLoading" @click="handleAdjust">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, type FormInstance } from 'element-plus'
import { getInventoryPage, adjustStock, type InventoryItem } from '../../api/inventory'

const loading = ref(false)
const list = ref<InventoryItem[]>([])
const total = ref(0)
const query = reactive({ pageNum: 1, pageSize: 10, keyword: '' })
const adjustVisible = ref(false)
const adjustLoading = ref(false)
const adjustFormRef = ref<FormInstance>()
const adjustForm = reactive({ productId: 0, productName: '', currentQty: 0, quantity: 0, remark: '' })
const adjustRules = { quantity: [{ required: true, message: '请输入调整数量', trigger: 'blur' }] }

async function fetchData() {
  loading.value = true
  try {
    const res = await getInventoryPage({ ...query })
    list.value = res.records; total.value = res.total
  } finally { loading.value = false }
}

function search() { query.pageNum = 1; fetchData() }

function openAdjust(row: InventoryItem) {
  adjustForm.productId = row.productId; adjustForm.productName = row.productName
  adjustForm.currentQty = row.quantity; adjustForm.quantity = 0; adjustForm.remark = ''
  adjustVisible.value = true
}

async function handleAdjust() {
  const valid = await adjustFormRef.value?.validate().catch(() => false)
  if (!valid) return
  adjustLoading.value = true
  try {
    await adjustStock({ productId: adjustForm.productId, quantity: adjustForm.quantity, remark: adjustForm.remark })
    ElMessage.success('调整成功'); adjustVisible.value = false; fetchData()
  } catch (e: unknown) { ElMessage.error((e as Error).message || '调整失败') }
  finally { adjustLoading.value = false }
}

onMounted(() => fetchData())
</script>

<style scoped>
.page-header { display: flex; justify-content: space-between; align-items: center; }
.search-bar { margin-bottom: 16px; }
.pagination-wrap { margin-top: 16px; display: flex; justify-content: flex-end; }
</style>