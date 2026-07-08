import request from '../utils/request'

export function getDashboardStats() {
  return request.get<null, Record<string, unknown>>('/dashboard/stats')
}