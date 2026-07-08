<template>
  <div>
    <el-card>
      <template #header>
        <div class="page-header">
          <span>供应商管理</span>
          <el-button type="primary" @click="openDialog()">新增供应商</el-button>
        </div>
      </template>
      <div class="search-bar">
        <el-input v-model="query.keyword" placeholder="搜索供应商名称" clearable style="width: 300px" @clear="search" @keyup.enter="search" />
        <el-button type="primary" style="margin-left: 12px" @click="search">搜索</el-button>
      </div>
      <el-table :data="list" border stripe v-loading="loading">
        <el-table-column prop="supplierName" label="供应商名称" min-width="140" />
        <el-table-column prop="contactPerson" label="联系人" width="100" />
        <el-table-column prop="phone" label="联系电话" width="130" />
        <el-table-column prop="address" label="地址" min-width="200" />
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

    <el-dialog v-model="dialogVisible" :title="isEdit ? '编辑供应商' : '新增供应商'" width="550px" :close-on-click-modal="false">
      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="供应商名称" prop="supplierName">
          <el-input v-model="form.supplierName" />
        </el-form-item>
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="联系人" prop="contactPerson">
              <el-input v-model="form.contactPerson" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="联系电话" prop="phone">
              <el-input v-model="form.phone" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="地址" prop="address">
          <el-input v-model="form.address" type="textarea" :rows="2" />
        </el-form-item>
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
import { getSupplierPage, createSupplier, updateSupplier, deleteSupplier, type Supplier } from '../../api/supplier'

const loading = ref(false)
const list = ref<Supplier[]>([])
const total = ref(0)
const query = reactive({ pageNum: 1, pageSize: 10, keyword: '' })
const dialogVisible = ref(false)
const isEdit = ref(false)
const submitLoading = ref(false)
const formRef = ref<FormInstance>()

const initForm = (): Partial<Supplier> => ({ supplierName: '', contactPerson: '', phone: '', address: '', remark: '', status: 1 })
const form = reactive<Partial<Supplier>>(initForm())
const rules = { supplierName: [{ required: true, message: '请输入供应商名称', trigger: 'blur' }] }

async function fetchData() {
  loading.value = true
  try {
    const res = await getSupplierPage({ ...query })
    list.value = res.records; total.value = res.total
  } finally { loading.value = false }
}

function search() { query.pageNum = 1; fetchData() }

function openDialog(row?: Supplier) {
  isEdit.value = !!row; Object.assign(form, row ? { ...row } : initForm()); dialogVisible.value = true
}

async function handleSubmit() {
  const valid = await formRef.value?.validate().catch(() => false)
  if (!valid) return
  submitLoading.value = true
  try {
    if (isEdit.value) { await updateSupplier({ ...form }); ElMessage.success('更新成功') }
    else { await createSupplier({ ...form }); ElMessage.success('新增成功') }
    dialogVisible.value = false; fetchData()
  } catch (e: unknown) { ElMessage.error((e as Error).message || '操作失败') }
  finally { submitLoading.value = false }
}

async function handleDelete(id: number) {
  try {
    await ElMessageBox.confirm('确认删除该供应商？', '提示')
    await deleteSupplier(id); ElMessage.success('删除成功'); fetchData()
  } catch { /* empty */ }
}

onMounted(() => fetchData())
</script>

<style scoped>
.page-header { display: flex; justify-content: space-between; align-items: center; }
.search-bar { margin-bottom: 16px; }
.pagination-wrap { margin-top: 16px; display: flex; justify-content: flex-end; }
</style>