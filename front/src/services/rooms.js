import api from '@/plugins/api'

// @module createRoom
// @params {Object} params
// @params {Number} params.capacity
// @params {Date} params.start_at
// @params {Date} params.finish_at
// @params {Boolean} params.is_accepted_camera
// @params {Boolean} params.is_accepted_audio
// @params {Boolean} params.is_accepted_chat
// @params {Boolean} params.is_private
// @params {Array} params.user_ids
export function createRoom (params) {
  return api.post('/v1/users/rooms', params)
}

export function deleteRoom (id) {
  return api.delete(`/v1/users/rooms/${id}`)
}
