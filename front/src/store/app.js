import {
  SET_DRAWER,
  SET_GLOBAL_LOADING,
  SET_NOTIFICATION,
  TOGGLE_DRAWER
} from '@/store/mutation_type'

const state = {
  notification: {
    show: false,
    status: null,
    message: null
  },
  globalLoading: false,
  drawer: null
}

const mutations = {
  [SET_NOTIFICATION] (state, payload) {
    state.notification = {
      show: true,
      ...payload
    }
  },
  [SET_GLOBAL_LOADING] (state, payload) {
    state.globalLoading = payload
  },
  [TOGGLE_DRAWER] (state) {
    state.drawer = !state.drawer
  },
  [SET_DRAWER] (state, payload) {
    state.drawer = payload
  }
}

export default {
  state,
  mutations
}
