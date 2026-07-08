<template>
  <div>
    <el-card>
      <template #header>
        <div class="page-header">
          <span>商品管理</span>
          <el-button type="primary" @click="openDialog()">新增商品</el-button>
        </div>
      </template>
      <div class="search-bar">
        <el-input v-model="query.keyword" placeholder="搜索商品名称/编码" clearable style="width: 300px" @clear="search" @keyup.enter="search" />
        <el-button type="primary" style="margin-left: 12px" @click="search">搜索</el-button>
      </div>
      <el-table :data="list" border stripe v-loading="loading">
        <el-table-column prop="productName" label="商品名称" min-width="140" />
        <el-table-column prop="productCode" label="商品编码" width="120" />
        <el-table-column prop="categoryName" label="分类" width="100" />
        <el-table-column prop="spec" label="规格" width="120" />
        <el-table-column prop="unit" label="单位" width="60" />
        <el-table-column prop="purchasePrice" label="采购价" width="100" align="right">
          <template #default="{ row }">{{ row.purchasePrice?.toFixed(2) }}</template>
        </el-table-column>
        <el-table-column prop="salePrice" label="销售价" width="100" align="right">
          <template #default="{ row }">{{ row.salePrice?.toFixed(2) }}</template>
        </el-table-column>
        <el-table-column prop="minStock" label="库存预警" width="80" />
        <el-table-column prop="status" label="状态" width="70">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : 'danger'" size="small">{{ row.status === 1 ? '启用' : '停用' }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link size="small" @click="openDialog(row)">编辑</el-button>
            <el-button type="danger" link size="small" @click="handleDelete(row.id)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="pagination-wrap">
        <el-pagination v-model:page-size="query.pageSize" v-model:current-page="query.pageNum" :total="total" layout="total, prev, pager, next" @current-change="fetchData" />
      </div>
    </el-card>

    <el-dialog v-model="dialogVisible" :title="isEdit ? '编辑商品' : '新增商品'" width="600px" :close-on-click-modal="false">
      <el-form ref="formRef" :model="form" :rules="rules" label-width="90px">
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="商品名称" prop="productName">
              <el-input v-model="form.productName" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="商品编码" prop="productCode">
              <el-input v-model="form.productCode" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="分类" prop="categoryId">
              <el-select v-model="form.categoryId" placeholder="请选择" clearable style="width: 100%">
                <el-option v-for="c in categories" :key="c.id" :label="c.categoryName" :value="c.id" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="单位" prop="unit">
              <el-input v-model="form.unit" placeholder="个/箱/kg" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="规格" prop="spec">
          <el-input v-model="form.spec" />
        </el-form-item>
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="采购价" prop="purchasePrice">
              <el-input-number v-model="form.purchasePrice" :min="0" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="销售价" prop="salePrice">
              <el-input-number v-model="form.salePrice" :min="0" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="最低库存" prop="minStock">
              <el-input-number v-model="form.minStock" :min="0" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="最高库存" prop="maxStock">
              <el-input-number v-model="form.maxStock" :min="0" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="状态" prop="status">
          <el-switch v-model="form.status" :active-value="1" :inactive-value="0" active-text="启用" inactive-text="停用" />
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" type="textarea" :rows="2" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="submitLoading" @click="handleSubmit">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox, type FormInstance } from 'element-plus'
import { getProductPage, createProduct, updateProduct, deleteProduct, type Product } from '../../api/product'
import { getCategoryList, type Category } from '../../api/category'

const loading = ref(false)
const list = ref<Product[]>([])
const total = ref(0)
const query = reactive({ pageNum: 1, pageSize: 10, keyword: '' })
const categories = ref<Category[]>([])
const dialogVisible = ref(false)
const isEdit = ref(false)
const submitLoading = ref(false)
const formRef = ref<FormInstance>()

const initForm = (): Partial<Product> => ({
  productName: '', productCode: '', categoryId: null, spec: '', unit: '',
  purchasePrice: 0, salePrice: 0, image: '', remark: '', status: 1, minStock: 0, maxStock: 0,
})

const form = reactive<Partial<Product>>(initForm())
const rules = {
  productName: [{ required: true, message: '请输入商品名称', trigger: 'blur' }],
  productCode: [{ required: true, message: '请输入商品编码', trigger: 'blur' }],
}

async function fetchData() {
  loading.value = true
  try {
    const res = await getProductPage({ ...query })
    list.value = res.records
    total.value = res.total
  } finally { loading.value = false }
}

function search() { query.pageNum = 1; fetchData() }

async function loadCategories() {
  try { categories.value = await getCategoryList() } catch { /* empty */ }
}

function openDialog(row?: Product) {
  isEdit.value = !!row
  Object.assign(form, row ? { ...row } : initForm())
  dialogVisible.value = true
}

async function handleSubmit() {
  const valid = await formRef.value?.validate().catch(() => false)
  if (!valid) return
  submitLoading.value = true
  try {
    if (isEdit.value) { await updateProduct({ ...form }); ElMessage.success('更新成功') }
    else { await createProduct({ ...form }); ElMessage.success('新增成功') }
    dialogVisible.value = false
    fetchData()
  } catch (e: unknown) { ElMessage.error((e as Error).message || '操作失败') }
  finally { submitLoading.value = false }
}

async function handleDelete(id: number) {
  try {
    await ElMessageBox.confirm('确认删除该商品？', '提示')
    await deleteProduct(id)
    ElMessage.success('删除成功')
    fetchData()
  } catch { /* empty */ }
}

onMounted(() => { fetchData(); loadCategories() })
</script>

<style scoped>
.page-header { display: flex; justify-content: space-between; align-items: center; }
.search-bar { margin-bottom: 16px; }
.pagination-wrap { margin-top: 16px; display: flex; justify-content: flex-end; }
</style>