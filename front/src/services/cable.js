import ActionCable from 'actioncable'

const WS_URL = process.env.VUE_APP_WS_URL

export function createConsumer (uid, token) {
  return ActionCable.createConsumer(`${WS_URL}/api/v1/cable?uid=${uid}&token=${token}`)
}
