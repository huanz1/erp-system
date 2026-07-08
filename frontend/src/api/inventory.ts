import request from '../utils/request'

export interface InventoryItem {
  id: number
  productId: number
  productName: string
  productCode: string
  spec: string
  unit: string
  quantity: number
  minStock: number
  maxStock: number
  updateTime: string
}

export function getInventoryPage(params: { pageNum: number; pageSize: number; keyword?: string }) {
  return request.get<null, { total: number; records: InventoryItem[] }>('/inventory/page', { params })
}

export function adjustStock(data: { productId: number; quantity: number; remark?: string }) {
  return request.post<null, null>('/inventory/adjust', null, { params: data })
}

export function getInventoryStats() {
  return request.get<null, Record<string, unknown>>('/inventory/stats')
}