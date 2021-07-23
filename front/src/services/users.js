import api from '@/plugins/api'

// @module getUsers
// @params {Object} params
// @params {String} params.query
// @params {Number} params.page
export function getUsers (params) {
  return api.get('/v1/users', { params: params })
}

export function getFriends () {
  return api.get('/v1/users/friends')
}

// Get onetime token for ActionCable.createConsumer()
export function getOnetimeToken () {
  return api.post('/v1/users/onetime_token')
}
