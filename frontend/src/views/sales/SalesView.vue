<template>
  <div>
    <el-card>
      <template #header>
        <div class="page-header">
          <span>销售管理</span>
          <el-button type="primary" @click="openCreate">新增销售单</el-button>
        </div>
      </template>
      <div class="search-bar">
        <el-input v-model="query.keyword" placeholder="搜索销售单号/客户" clearable style="width: 300px" @clear="search" @keyup.enter="search" />
        <el-button type="primary" style="margin-left: 12px" @click="search">搜索</el-button>
      </div>
      <el-table :data="list" border stripe v-loading="loading">
        <el-table-column prop="orderNo" label="销售单号" width="160" />
        <el-table-column prop="customerName" label="客户" min-width="140" />
        <el-table-column prop="totalAmount" label="总金额" width="120" align="right">
          <template #default="{ row }">¥{{ row.totalAmount?.toFixed(2) }}</template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="80">
          <template #default="{ row }">
            <el-tag :type="statusMap[row.status]?.type || 'info'" size="small">{{ statusMap[row.status]?.label || row.status }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="operator" label="经办人" width="80" />
        <el-table-column prop="orderDate" label="销售日期" width="100" />
        <el-table-column label="操作" width="220" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link size="small" @click="viewDetail(row.id)">详情</el-button>
            <el-button v-if="row.status === 0" type="success" link size="small" @click="updateStatus(row.id, 1)">出库</el-button>
            <el-button type="danger" link size="small" @click="handleDelete(row.id)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="pagination-wrap">
        <el-pagination v-model:page-size="query.pageSize" v-model:current-page="query.pageNum" :total="total" layout="total, prev, pager, next" @current-change="fetchData" />
      </div>
    </el-card>

    <el-dialog v-model="detailVisible" title="销售单详情" width="700px">
      <template v-if="detail">
        <el-descriptions :column="3" border>
          <el-descriptions-item label="销售单号">{{ detail.orderNo }}</el-descriptions-item>
          <el-descriptions-item label="客户">{{ detail.customerName }}</el-descriptions-item>
          <el-descriptions-item label="状态">
            <el-tag :type="statusMap[detail.status]?.type" size="small">{{ statusMap[detail.status]?.label }}</el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="经办人">{{ detail.operator || '-' }}</el-descriptions-item>
          <el-descriptions-item label="销售日期">{{ detail.orderDate || '-' }}</el-descriptions-item>
          <el-descriptions-item label="总金额">¥{{ detail.totalAmount?.toFixed(2) }}</el-descriptions-item>
          <el-descriptions-item label="备注" :span="3">{{ detail.remark || '-' }}</el-descriptions-item>
        </el-descriptions>
        <h4 style="margin: 16px 0 8px">商品明细</h4>
        <el-table :data="detail.items" border stripe>
          <el-table-column prop="productName" label="商品名称" min-width="120" />
          <el-table-column prop="quantity" label="数量" width="80" align="right" />
          <el-table-column prop="unitPrice" label="单价" width="100" align="right">
            <template #default="{ row }">¥{{ row.unitPrice?.toFixed(2) }}</template>
          </el-table-column>
          <el-table-column prop="totalPrice" label="小计" width="120" align="right">
            <template #default="{ row }">¥{{ (row.totalPrice || row.quantity * row.unitPrice)?.toFixed(2) }}</template>
          </el-table-column>
          <el-table-column prop="remark" label="备注" min-width="100" />
        </el-table>
      </template>
    </el-dialog>

    <el-dialog v-model="createVisible" title="新增销售单" width="750px" :close-on-click-modal="false">
      <el-form ref="createFormRef" :model="createForm" :rules="createRules" label-width="80px">
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="客户" prop="customerId">
              <el-select v-model="createForm.customerId" placeholder="请选择" filterable style="width: 100%">
                <el-option v-for="c in customers" :key="c.id" :label="c.customerName" :value="c.id" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="经办人" prop="operator">
              <el-input v-model="createForm.operator" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="销售日期" prop="orderDate">
              <el-date-picker v-model="createForm.orderDate" type="date" value-format="YYYY-MM-DD" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="备注" prop="remark">
              <el-input v-model="createForm.remark" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <h4 style="margin: 0 0 8px">商品明细</h4>
      <el-table :data="createForm.items" border stripe>
        <el-table-column label="商品" min-width="160">
          <template #default="{ row, $index }">
            <el-select v-model="row.productId" placeholder="请选择商品" filterable style="width: 100%" @change="(val) => onProductSelect($index, val)">
              <el-option v-for="p in products" :key="p.id" :label="p.productName" :value="p.id" />
            </el-select>
          </template>
        </el-table-column>
        <el-table-column label="数量" width="160">
          <template #default="{ row }">
            <el-input-number v-model="row.quantity" :min="1" controls-position="right" style="width: 130px" />
          </template>
        </el-table-column>
        <el-table-column label="单价" width="160">
          <template #default="{ row }">
            <el-input-number v-model="row.unitPrice" :min="0" :precision="2" controls-position="right" style="width: 140px" />
          </template>
        </el-table-column>
        <el-table-column label="小计" width="140" align="right">
          <template #default="{ row }">¥{{ (row.quantity * row.unitPrice)?.toFixed(2) }}</template>
        </el-table-column>
        <el-table-column label="操作" width="60">
          <template #default="{ $index }">
            <el-button type="danger" link size="small" @click="removeItem($index)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div style="margin-top: 8px">
        <el-button size="small" @click="addItem">添加商品</el-button>
      </div>
      <div style="text-align: right; margin-top: 12px; font-size: 16px">
        合计：<strong>¥{{ totalAmount.toFixed(2) }}</strong>
      </div>
      <template #footer>
        <el-button @click="createVisible = false">取消</el-button>
        <el-button type="primary" :loading="submitLoading" @click="handleCreate">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage, ElMessageBox, type FormInstance } from 'element-plus'
import { getSalesPage, getSalesDetail, createSalesOrder, updateSalesStatus, deleteSalesOrder, type SalesOrder } from '../../api/sales'
import { getCustomerList, type Customer } from '../../api/customer'
import { getProductList, type Product } from '../../api/product'

const loading = ref(false)
const list = ref<SalesOrder[]>([])
const total = ref(0)
const query = reactive({ pageNum: 1, pageSize: 10, keyword: '' })
const detailVisible = ref(false)
const detail = ref<SalesOrder | null>(null)
const createVisible = ref(false)
const submitLoading = ref(false)
const createFormRef = ref<FormInstance>()
const customers = ref<Customer[]>([])
const products = ref<Product[]>([])

const statusMap: Record<number, { label: string; type: string }> = {
  0: { label: '待出库', type: 'warning' },
  1: { label: '已出库', type: 'success' },
  2: { label: '已退货', type: 'danger' },
}

const createForm = reactive({
  customerId: null as number | null, operator: '', orderDate: '', remark: '',
  items: [] as { productId: number | null; quantity: number; unitPrice: number }[],
})

const createRules = { customerId: [{ required: true, message: '请选择客户', trigger: 'change' }] }

const totalAmount = computed(() =>
  createForm.items.reduce((sum, item) => sum + (item.quantity || 0) * (item.unitPrice || 0), 0),
)

function addItem() { createForm.items.push({ productId: null, quantity: 1, unitPrice: 0 }) }
function removeItem(index: number) { createForm.items.splice(index, 1) }

function onProductSelect(index: number, productId: number) {
  const product = products.value.find(p => p.id === productId)
  if (product) { createForm.items[index].unitPrice = product.salePrice }
}

async function fetchData() {
  loading.value = true
  try {
    const res = await getSalesPage({ ...query })
    list.value = res.records
    total.value = res.total
  } finally { loading.value = false }
}

function search() { query.pageNum = 1; fetchData() }

async function loadOptions() {
  try { customers.value = await getCustomerList(); products.value = await getProductList() } catch { /* empty */ }
}

async function viewDetail(id: number) {
  try { detail.value = await getSalesDetail(id); detailVisible.value = true }
  catch (e: unknown) { ElMessage.error((e as Error).message || '获取详情失败') }
}

async function openCreate() {
  createForm.customerId = null; createForm.operator = ''; createForm.orderDate = ''; createForm.remark = ''
  createForm.items = [{ productId: null, quantity: 1, unitPrice: 0 }]
  createVisible.value = true
}

async function handleCreate() {
  const valid = await createFormRef.value?.validate().catch(() => false)
  if (!valid) return
  if (createForm.items.length === 0 || !createForm.items[0].productId) { ElMessage.warning('请添加商品明细'); return }
  submitLoading.value = true
  try {
    await createSalesOrder({
      customerId: createForm.customerId!, operator: createForm.operator || undefined,
      orderDate: createForm.orderDate || undefined, remark: createForm.remark || undefined,
      items: createForm.items.map(i => ({ productId: i.productId!, quantity: i.quantity, unitPrice: i.unitPrice })),
    })
    ElMessage.success('创建成功'); createVisible.value = false; fetchData()
  } catch (e: unknown) { ElMessage.error((e as Error).message || '创建失败') }
  finally { submitLoading.value = false }
}

async function updateStatus(id: number, status: number) {
  try {
    await ElMessageBox.confirm(status === 1 ? '确认出库？' : '确认操作？', '提示')
    await updateSalesStatus(id, status); ElMessage.success('操作成功'); fetchData()
  } catch { /* empty */ }
}

async function handleDelete(id: number) {
  try {
    await ElMessageBox.confirm('确认删除该销售单？', '提示')
    await deleteSalesOrder(id); ElMessage.success('删除成功'); fetchData()
  } catch { /* empty */ }
}

onMounted(() => { fetchData(); loadOptions() })
</script>

<style scoped>
.page-header { display: flex; justify-content: space-between; align-items: center; }
.search-bar { margin-bottom: 16px; }
.pagination-wrap { margin-top: 16px; display: flex; justify-content: flex-end; }
</style>