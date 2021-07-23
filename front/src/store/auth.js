import router from '@/router'
import {
  SIGN_UP,
  SIGN_IN,
  SIGN_OUT
} from '@/store/action_type'
import {
  SET_GLOBAL_LOADING,
  SET_AUTH_TOKEN,
  SET_USER,
  SET_FETCHED_SESSION
} from '@/store/mutation_type'
import { setSession, deleteSession } from '@/plugins/session'
import { notice } from '@/plugins/notice'
import { signIn, signUp, signOut } from '@/services/auth'

const state = {
  user: null,
  authToken: null,
  fetchedSession: false
}

const getters = {
  isLoggedIn: state => {
    return state.user !== null
  },
  currentUserName: (state, getters) => {
    return getters.isLoggedIn ? state.user.name : ''
  }
}

const actions = {
  async [SIGN_UP] ({ commit }, params) {
    try {
      const res = await signUp(params)
      await router.push('/login')
      notice('success', 'Succeeded to create account')
      return res
    } catch (e) {
      if (e.status === 422) notice('warning', 'Your name or email address has already been registered')
    }
  },
  async [SIGN_IN] ({ commit }, params) {
    commit(SET_GLOBAL_LOADING, true)
    try {
      const res = await signIn(params)
      const user = res.data.data
      commit(SET_USER, user)
      setSession(res.headers, user)
      await router.push('/mypage')
      notice('success', `Logged in as ${user.name}`)
      return res
    } finally {
      commit(SET_GLOBAL_LOADING, false)
    }
  },
  async [SIGN_OUT] ({ commit }) {
    commit(SET_GLOBAL_LOADING, true)
    try {
      const res = await signOut()
      notice('success', 'Logged out')
      return res
    } catch (e) {
      if (e.status === 404) notice('error', 'Already logged out')
    } finally {
      deleteSession()
      await router.push('/top')
      commit(SET_GLOBAL_LOADING, false)
    }
  }
}

const mutations = {
  [SET_AUTH_TOKEN] (state, payload) {
    state.authToken = payload
  },
  [SET_USER] (state, payload) {
    state.user = payload
  },
  [SET_FETCHED_SESSION] (state, payload) {
    state.fetchedSession = payload
  }
}

export default {
  state,
  getters,
  actions,
  mutations
}
