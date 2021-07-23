import Vue from 'vue'
import Vuex from 'vuex'
import app from '@/store/app'
import auth from '@/store/auth'

Vue.use(Vuex)

export default new Vuex.Store({
  modules: {
    app,
    auth
  }
})
