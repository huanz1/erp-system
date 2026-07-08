import request from '../utils/request'

export interface Product {
  id?: number
  productName: string
  productCode: string
  categoryId: number | null
  categoryName?: string
  spec: string
  unit: string
  purchasePrice: number
  salePrice: number
  image: string
  remark: string
  status: number
  minStock: number
  maxStock: number
}

export function getProductPage(params: { pageNum: number; pageSize: number; keyword?: string }) {
  return request.get<null, { total: number; records: Product[] }>('/product/page', { params })
}

export function getProductList() {
  return request.get<null, Product[]>('/product/list')
}

export function getProductById(id: number) {
  return request.get<null, Product>(`/product/${id}`)
}

export function createProduct(data: Partial<Product>) {
  return request.post<null, null>('/product', data)
}

export function updateProduct(data: Partial<Product>) {
  return request.put<null, null>('/product', data)
}

export function deleteProduct(id: number) {
  return request.delete<null, null>(`/product/${id}`)
}