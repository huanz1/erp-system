import request from '../utils/request'

export interface Category {
  id?: number
  parentId: number
  categoryName: string
  sort: number
  remark: string
  children?: Category[]
}

export function getCategoryPage(params: { pageNum: number; pageSize: number; keyword?: string }) {
  return request.get<null, { total: number; records: Category[] }>('/category/page', { params })
}

export function getCategoryTree() {
  return request.get<null, Category[]>('/category/tree')
}

export function getCategoryList() {
  return request.get<null, Category[]>('/category/list')
}

export function createCategory(data: Partial<Category>) {
  return request.post<null, null>('/category', data)
}

export function updateCategory(data: Partial<Category>) {
  return request.put<null, null>('/category', data)
}

export function deleteCategory(id: number) {
  return request.delete<null, null>(`/category/${id}`)
}

export function getCategoryById(id: number) {
  return request.get<null, Category>(`/category/${id}`)
}