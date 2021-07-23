import api from '@/plugins/api'

// Post registration params to Auth Server to create new account.
// @module signUp
// @params {Object} params
// @params {string} params.name
// @params {string} params.email
// @params {string} params.password
// @params {string} params.passwordConfirmation
export function signUp (params) {
  return api.post('/v1/auth', params)
}

// Post session params to Auth Server to get session tokens.
// @module signIn
// @params {Object} params
// @params {string} params.email
// @params {string} params.password
// @params {boolean} params.remember_me
export function signIn (params) {
  return api.post('/v1/auth/sign_in', params)
}

// Send delete request to Auth Server.
export function signOut () {
  return api.delete('/v1/auth/sign_out')
}
