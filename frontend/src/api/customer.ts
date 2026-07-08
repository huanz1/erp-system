import request from '../utils/request'

export interface Customer {
  id?: number
  customerName: string
  contactPerson: string
  phone: string
  address: string
  remark: string
  status: number
}

export function getCustomerPage(params: { pageNum: number; pageSize: number; keyword?: string }) {
  return request.get<null, { total: number; records: Customer[] }>('/customer/page', { params })
}

export function getCustomerList() {
  return request.get<null, Customer[]>('/customer/list')
}

export function createCustomer(data: Partial<Customer>) {
  return request.post<null, null>('/customer', data)
}

export function updateCustomer(data: Partial<Customer>) {
  return request.put<null, null>('/customer', data)
}

export function deleteCustomer(id: number) {
  return request.delete<null, null>(`/customer/${id}`)
}

export function getCustomerById(id: number) {
  return request.get<null, Customer>(`/customer/${id}`)
}