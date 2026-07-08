import request from '../utils/request'

export interface PurchaseOrderItem {
  id?: number
  productId: number
  productName?: string
  quantity: number
  unitPrice: number
  totalPrice?: number
  remark?: string
}

export interface PurchaseOrder {
  id: number
  orderNo: string
  supplierId: number
  supplierName: string
  totalAmount: number
  status: number
  remark: string
  operator: string
  orderDate: string
  createTime: string
  items: PurchaseOrderItem[]
}

export function getPurchasePage(params: { pageNum: number; pageSize: number; keyword?: string }) {
  return request.get<null, { total: number; records: PurchaseOrder[] }>('/purchase-order/page', { params })
}

export function getPurchaseDetail(id: number) {
  return request.get<null, PurchaseOrder>(`/purchase-order/${id}`)
}

export function createPurchaseOrder(data: {
  supplierId: number; remark?: string; operator?: string; orderDate?: string
  items: { productId: number; quantity: number; unitPrice: number; remark?: string }[]
}) {
  return request.post<null, PurchaseOrder>('/purchase-order', data)
}

export function updatePurchaseStatus(id: number, status: number) {
  return request.put<null, null>(`/purchase-order/${id}/status`, null, { params: { status } })
}

export function deletePurchaseOrder(id: number) {
  return request.delete<null, null>(`/purchase-order/${id}`)
}