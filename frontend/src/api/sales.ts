import request from '../utils/request'

export interface SalesOrderItem {
  id?: number
  productId: number
  productName?: string
  quantity: number
  unitPrice: number
  totalPrice?: number
  remark?: string
}

export interface SalesOrder {
  id: number
  orderNo: string
  customerId: number
  customerName: string
  totalAmount: number
  status: number
  remark: string
  operator: string
  orderDate: string
  createTime: string
  items: SalesOrderItem[]
}

export function getSalesPage(params: { pageNum: number; pageSize: number; keyword?: string }) {
  return request.get<null, { total: number; records: SalesOrder[] }>('/sales-order/page', { params })
}

export function getSalesDetail(id: number) {
  return request.get<null, SalesOrder>(`/sales-order/${id}`)
}

export function createSalesOrder(data: {
  customerId: number; remark?: string; operator?: string; orderDate?: string
  items: { productId: number; quantity: number; unitPrice: number; remark?: string }[]
}) {
  return request.post<null, SalesOrder>('/sales-order', data)
}

export function updateSalesStatus(id: number, status: number) {
  return request.put<null, null>(`/sales-order/${id}/status`, null, { params: { status } })
}

export function deleteSalesOrder(id: number) {
  return request.delete<null, null>(`/sales-order/${id}`)
}