import store from '@/store'
import { SET_NOTIFICATION } from '@/store/mutation_type'

export function notice (status, message) {
  store.commit(SET_NOTIFICATION, { show: true, status: status, message: message })
}

export function deleteNotification () {
  store.commit(SET_NOTIFICATION, { show: false, status: null, message: null })
}
