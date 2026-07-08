import { defineStore } from 'pinia'
import { ref } from 'vue'
import { login as loginApi, getCurrentUser, type UserInfo } from '../api/auth'

export const useAuthStore = defineStore('auth', () => {
  const token = ref(localStorage.getItem('token') || '')
  const userInfo = ref<UserInfo | null>(null)

  const isLoggedIn = () => !!token.value

  async function login(username: string, password: string) {
    const result = await loginApi({ username, password })
    token.value = result.token
    userInfo.value = result.userInfo
    localStorage.setItem('token', result.token)
  }

  async function fetchUserInfo() {
    const result = await getCurrentUser()
    userInfo.value = result.userInfo
    token.value = result.token
    localStorage.setItem('token', result.token)
  }

  function logout() {
    token.value = ''
    userInfo.value = null
    localStorage.removeItem('token')
  }

  return { token, userInfo, isLoggedIn, login, fetchUserInfo, logout }
})