import request from '../utils/request'

export interface Supplier {
  id?: number
  supplierName: string
  contactPerson: string
  phone: string
  address: string
  remark: string
  status: number
}

export function getSupplierPage(params: { pageNum: number; pageSize: number; keyword?: string }) {
  return request.get<null, { total: number; records: Supplier[] }>('/supplier/page', { params })
}

export function getSupplierList() {
  return request.get<null, Supplier[]>('/supplier/list')
}

export function createSupplier(data: Partial<Supplier>) {
  return request.post<null, null>('/supplier', data)
}

export function updateSupplier(data: Partial<Supplier>) {
  return request.put<null, null>('/supplier', data)
}

export function deleteSupplier(id: number) {
  return request.delete<null, null>(`/supplier/${id}`)
}

export function getSupplierById(id: number) {
  return request.get<null, Supplier>(`/supplier/${id}`)
}