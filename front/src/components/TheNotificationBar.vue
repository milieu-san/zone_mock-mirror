<template>
  <v-snackbar
    v-model="show"
    :color="color"
    top
  >
    <v-icon>
      {{ icon }}
    </v-icon>
    {{ message }}
    <template v-slot:action="{ attrs }">
      <v-btn
        v-bind="attrs"
        text
        fab
        @click="disAppear"
      >
        <v-icon
          dark
        >
          mdi-close
        </v-icon>
      </v-btn>
    </template>
  </v-snackbar>
</template>

<script>
import { deleteNotification } from '@/plugins/notice'

export default {
  name: 'TheNotificationBar',
  computed: {
    show: {
      get () { return this.$store.state.app.notification.show },
      set () { this.disAppear() }
    },
    status () {
      return this.$store.state.app.notification.status
    },
    message () {
      return this.$store.state.app.notification.message
    },
    icon () {
      let icon
      switch (this.status) {
        case 'info':
          icon = 'mdi-information-outline'
          break
        case 'success':
          icon = 'mdi-check-circle-outline'
          break
        case 'warning':
          icon = 'mdi-alert-outline'
          break
        case 'error':
          icon = 'mdi-alert-octagon-outline'
          break
      }
      return icon
    },
    color () {
      let color
      switch (this.status) {
        case 'info':
          color = 'blue'
          break
        case 'success':
          color = 'green'
          break
        case 'warning':
          color = 'orange'
          break
        case 'error':
          color = 'red'
          break
      }
      return color
    }
  },
  methods: {
    disAppear () {
      deleteNotification()
    }
  }
}
</script>
