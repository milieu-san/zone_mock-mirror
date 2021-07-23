<template>
  <v-container>
    <v-row align="center">
      <v-col class="d-flex" cols="12" sm="6">
        <v-card id="remote-stream" class="d-flex">
          <video id="remote-video" width="100%" autoplay playsinline></video>
        </v-card>
      </v-col>
      <v-col class="d-flex" cols="12" sm="6">
        <v-card id="local-stream" class="d-flex">
          <video id="my-video" width="100%" autoplay playsinline></video>
        </v-card>
      </v-col>

      <v-col class="d-flex" cols="12">
        <v-btn
          color="error"
          fab
          @click.prevent="close()">
          <v-icon>mdi-phone-hangup</v-icon>
        </v-btn>
      </v-col>

      <v-col class="d-flex" cols="12" sm="6">
        <v-select
          label="microphone"
          v-model="selectedAudio"
          :items="audios"
          item-text="text"
          item-value="value"
          @change="onChange()"
        />
      </v-col>

      <v-col class="d-flex" cols="12" sm="6">
        <v-select
          label="camera"
          v-model="selectedVideo"
          :items="videos"
          item-text="text"
          item-value="value"
          @change="onChange()"
        />
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import Peer from 'skyway-js'
import { getOnetimeToken } from '@/services/users'
import { createConsumer } from '@/services/cable'

const API_KEY = process.env.VUE_APP_SKYWAY_API_KEY

export default {
  name: 'Room',
  data () {
    return {
      audios: [],
      videos: [],
      selectedAudio: '',
      selectedVideo: '',
      peerId: '',
      callId: '',
      localStream: null,
      localVideo: null,
      remoteVideo: null,
      remoteMediaConnection: null,
      mediaConnection: null,
      consumer: null,
      roomChannel: null
    }
  },
  async created () {
    await this.setDevices()
    await this.createConnection()
    await this.initializeStream()
  },
  beforeDestroy () {
    this.disconnectRoom()
    this.localStream.getTracks().forEach(track => {
      track.stop()
    })
  },
  watch: {
    peerId () {
      this.setChannel()
    }
  },
  methods: {
    async createConnection () {
      const res = await getOnetimeToken()
      return await this.setConsumer(
        this.$store.state.auth.user.uid,
        res.headers['x-zonemock-wstoken']
      )
    },
    setConsumer (uid, token) {
      return new Promise(resolve => {
        this.consumer = createConsumer(uid, token)
        resolve()
      })
    },
    setChannel () {
      this.roomChannel = this.consumer.subscriptions.create({
        channel: 'RoomChannel',
        id: this.$route.params.id,
        callId: this.peerId
      }, {
        received: (res) => {
          if (res.data === this.peerId) return
          this.call(res.data)
        }
      })
    },
    disconnectRoom () {
      this.close()
      this.roomChannel.perform('unsubscribed')
    },
    async setLocalStreamByDevice () {
      const audio = this.selectedAudio ? { deviceId: { exact: this.selectedAudio } } : true
      const video = this.selectedVideo ? { deviceId: { exact: this.selectedVideo } } : true
      this.localStream = await window.navigator.mediaDevices.getUserMedia({
        audio: audio,
        video: video
      })
    },
    async playLocalVideo () {
      this.localVideo = document.getElementById('my-video')
      this.localVideo.muted = true
      this.localVideo.srcObject = this.localStream
      this.localVideo.playsInline = true
      await this.localVideo.play().catch(console.error)
    },
    createPeerSetting () {
      this.peer = new Peer({ key: API_KEY, debug: 3 })
      this.peer.on('open', () => { this.peerId = this.peer.id })

      this.remoteVideo = document.getElementById('remote-video')
      this.peer.on('call', remoteMediaConnection => {
        remoteMediaConnection.answer(this.localStream)

        remoteMediaConnection.on('stream', async stream => {
          this.remoteVideo.srcObject = stream
          this.remoteVideo.playsInline = true
          await this.remoteVideo.play().catch(console.error)
        })

        remoteMediaConnection.once('close', () => {
          this.remoteVideo.srcObject.getTracks().forEach(track => track.stop())
          this.remoteVideo.srcObject = null
        })

        this.remoteMediaConnection = remoteMediaConnection
      })
      this.peer.on('error', console.error)
    },
    async initializeStream () {
      await this.setLocalStreamByDevice()
      await this.playLocalVideo()
      this.createPeerSetting()
    },
    setDevices () {
      return window.navigator.mediaDevices
        .enumerateDevices()
        .then((deviceInfos) => {
          deviceInfos
            .filter(deviceInfo => deviceInfo.kind === 'audioinput')
            .map(audio => this.audios.push({
              text: audio.label || `Microphone ${this.audios.length + 1}`,
              value: audio.deviceId
            }))

          deviceInfos
            .filter(deviceInfo => deviceInfo.kind === 'videoinput')
            .map(video => this.videos.push({
              text: video.label || `Camera ${this.videos.length + 1}`,
              value: video.deviceId
            }))
        })
        .finally(() => {
          this.selectedAudio = this.audios[0].value
          this.selectedVideo = this.videos[0].value
        })
    },
    async onChange () {
      await this.setLocalStreamByDevice()
      await this.playLocalVideo()
    },
    call (callId) {
      if (!this.peer.open) {
        return true
      }

      const mediaConnection = this.peer.call(callId, this.localStream)

      mediaConnection.on('stream', async stream => {
        this.remoteVideo.srcObject = stream
        this.remoteVideo.playsInline = true
        this.remoteVideo.play().catch(console.error)
      })

      mediaConnection.once('close', () => {
        this.remoteVideo.srcObject.getTracks().forEach(track => track.stop())
        this.remoteVideo.srcObject = null
      })

      this.mediaConnection = mediaConnection
    },
    close () {
      if (this.mediaConnection) {
        this.mediaConnection.close(true)
      }

      if (this.remoteMediaConnection) {
        this.remoteMediaConnection.close(true)
      }
    }
  }
}
</script>
