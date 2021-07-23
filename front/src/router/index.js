import Vue from 'vue'
import VueRouter from 'vue-router'
import { isLoggedIn } from '@/plugins/session'
import { notice } from '@/plugins/notice'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'Home',
    component: () => {
      if (isLoggedIn()) {
        return import('@/views/MyPage.vue')
      } else {
        return import('@/views/Top.vue')
      }
    }
  },
  {
    path: '/top',
    name: 'Top',
    component: () => import('@/views/Top.vue'),
    meta: { rejectAuth: true }
  },
  {
    path: '/about',
    name: 'About',
    component: () => import('@/views/About.vue'),
    meta: { rejectAuth: true }
  },
  {
    path: '/signup',
    name: 'SignUp',
    component: () => import('@/views/SignUp.vue'),
    meta: { rejectAuth: true }
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/Login.vue'),
    meta: { rejectAuth: true }
  },
  {
    path: '/free_room',
    name: 'FreeRoom',
    component: () => import('@/views/FreeRoom.vue'),
    meta: { rejectAuth: true }
  },
  {
    path: '/mypage',
    name: 'MyPage',
    component: () => import('@/views/MyPage.vue'),
    meta: { auth: true }
  },
  {
    path: '/room/new',
    name: 'RoomNew',
    component: () => import('@/views/RoomNew.vue'),
    meta: { auth: true }
  },
  {
    path: '/room/:id',
    name: 'Room',
    component: () => import('@/views/Room.vue'),
    meta: { auth: true }
  },
  {
    path: '/users',
    name: 'Users',
    component: () => import('@/views/Users.vue'),
    meta: { auth: true }
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

router.beforeEach((to, from, next) => {
  if (to.matched.some(route => route.meta.auth) && !isLoggedIn()) {
    notice('warning', 'Please log in.')
    next({ name: 'Login' })
  } else if (to.matched.some(route => route.meta.rejectAuth) && isLoggedIn()) {
    notice('warning', 'You already logged in.')
    next({ name: 'MyPage' })
  } else next()
})

export default router
