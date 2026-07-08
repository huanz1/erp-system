import request from '../utils/request'

export interface UserInfo {
  id: number
  username: string
  realName: string | null
  phone: string | null
  email: string | null
  avatar: string | null
  status: number
  roleId: number
  roleName: string | null
  createTime: string
}

export interface LoginResult {
  token: string
  userInfo: UserInfo
}

export function login(data: { username: string; password: string }) {
  return request.post<null, LoginResult>('/auth/login', data)
}

export function getCurrentUser() {
  return request.get<null, LoginResult>('/auth/me')
}