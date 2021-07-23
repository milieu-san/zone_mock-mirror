import Cookies from 'js-cookie'
import store from '@/store/index'
import {
  SET_AUTH_TOKEN,
  SET_USER,
  SET_FETCHED_SESSION
} from '@/store/mutation_type'

export function digSession () {
  if (store.state.auth.fetchedSession) return null

  const session = Cookies.get('session')
  store.commit(SET_FETCHED_SESSION, true)

  // If session is null or undefined
  if (typeof session === 'undefined' || session === null) return null

  const obj = JSON.parse(session)
  store.commit(SET_USER, obj.user)
  store.commit(SET_AUTH_TOKEN, obj.tokens)
  return obj.user
}

export function setSession (headers, user) {
  const authToken = {
    'access-token': headers['access-token'],
    client: headers.client,
    expiry: headers.expiry,
    uid: headers.uid
  }

  const session = {
    user: user,
    tokens: authToken
  }

  Cookies.set('session', session, {
    path: '/',
    maxAge: String(60 * 60 * 24 * 7)
  })
}

export function deleteSession () {
  Cookies.remove('session')
  store.commit(SET_USER, null)
  store.commit(SET_AUTH_TOKEN, null)
}

export function isLoggedIn () {
  if (store.state.auth.fetchedSession) {
    return store.state.auth.user !== null
  }

  const user = digSession()

  return user !== null
}
