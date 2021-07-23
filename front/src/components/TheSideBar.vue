<template>
  <v-navigation-drawer
    v-model="drawer"
    clipped
    app
  >
    <v-list-item-group>
      <v-list-item
        v-for="(item, i) in items"
        :key="i"
        @click="href(item.path)"
      >
        <v-list-item-icon>
          <v-icon>{{ item.icon }}</v-icon>
        </v-list-item-icon>
        <v-list-item-title>{{ item.content }}</v-list-item-title>
      </v-list-item>
    </v-list-item-group>
  </v-navigation-drawer>
</template>

<script>
import { SET_DRAWER } from '@/store/mutation_type'

export default {
  name: 'TheSideBar',
  data () {
    return {
      authItems: [
        {
          icon: 'mdi-account',
          content: 'MyPage',
          path: '/mypage'
        },
        {
          icon: 'mdi-message-video',
          content: 'Create Room',
          path: '/room/new'
        },
        {
          icon: 'mdi-account-search',
          content: 'Users',
          path: '/users'
        }
      ],
      noAuthItems: [
        {
          icon: 'mdi-home',
          content: 'Top',
          path: '/top'
        },
        {
          icon: 'mdi-message-video',
          content: 'Try Free Service',
          path: '/free_room'
        },
        {
          icon: 'mdi-help-circle-outline',
          content: 'About',
          path: '/about'
        }
      ]
    }
  },
  computed: {
    drawer: {
      get () { return this.$store.state.app.drawer },
      set (val) { this.$store.commit(SET_DRAWER, val) }
    },
    isLoggedIn () {
      return this.$store.state.auth.user !== null
    },
    items () {
      return this.isLoggedIn ? this.authItems : this.noAuthItems
    }
  },
  methods: {
    href (path) {
      this.$router.push(path).catch(() => {})
    }
  }
}
</script>
