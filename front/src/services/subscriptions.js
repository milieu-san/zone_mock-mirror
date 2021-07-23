import api from '@/plugins/api'

export function deleteSubscription (roomId) {
  return api.delete(`/v1/users/rooms/${roomId}/subscriptions`)
}
