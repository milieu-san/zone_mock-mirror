import axios from 'axios'
import store from '@/store/index'
import Cookies from 'js-cookie'
import { notice } from '@/plugins/notice'
import router from '@/router'
import { SET_AUTH_TOKEN, SET_USER } from '@/store/mutation_type'

const API_URL = process.env.VUE_APP_API_URL

axios.defaults.baseURL = `${API_URL}/api`

axios.interceptors.request.use(config => {
  const authToken = store.state.auth.authToken
  if (authToken) {
    config.headers = authToken
  }
  return config
})

axios.interceptors.response.use(res => {
  if (res.headers['access-token']) {
    const authToken = {
      'access-token': res.headers['access-token'],
      client: res.headers.client,
      expiry: res.headers.expiry,
      uid: res.headers.uid
    }
    store.commit(SET_AUTH_TOKEN, authToken)

    const session = Cookies.get('session')
    if (session) {
      const obj = JSON.parse(session)
      obj.tokens = authToken
      Cookies.set('session', obj, {
        path: '/',
        maxAge: String(60 * 60 * 24 * 7)
      })
    }
  }
  return res
}, e => {
  if (e.response.status === 500) {
    notice('error', 'Something get wrong.')
    console.log(e)
  } else if (e.response.status === 401) {
    Cookies.remove('session')
    store.commit(SET_USER, null)
    store.commit(SET_AUTH_TOKEN, null)
    notice('warning', 'Check your email address and password')
    router.push('/login').catch(() => {})
  } else {
    // nothing
  }
  return Promise.reject(e.response)
})

export default axios
