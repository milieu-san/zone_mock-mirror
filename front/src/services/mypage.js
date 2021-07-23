import api from '@/plugins/api'

export function fetchMypageInfo () {
  return api.get('/v1/my')
}
