import api from '@/plugins/api'

export function createFriendShip (id) {
  return api.post('/v1/friendships', {
    followee_id: id
  })
}

export function deleteFriendShip (id) {
  return api.delete('/v1/friendships', {
    params: {
      followee_id: id
    }
  })
}
