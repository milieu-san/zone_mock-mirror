<template>
  <v-app-bar
    dark
    clipped-left
    app
  >
    <v-app-bar-nav-icon @click="toggleDrawer" />
    <v-toolbar-title>
      Zone-Mock
    </v-toolbar-title>
    <v-spacer />
    {{ currentUserName }}
    <v-menu
      open-on-hover
      left
      bottom
    >
      <template v-slot:activator="{ on, attrs }">
        <v-btn
          icon
          v-bind="attrs"
          v-on="on"
        >
          <v-icon>mdi-dots-vertical</v-icon>
        </v-btn>
      </template>

      <v-list>
        <v-list-item
          v-for="(item, i) in items"
          :key="i"
          @click.prevent="item.event"
        >
          <v-list-item-icon>
            <v-icon>
              {{ item.icon }}
            </v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title>
              {{ item.content }}
            </v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list>
    </v-menu>
  </v-app-bar>
</template>

<script>
import { mapGetters } from 'vuex'
import { TOGGLE_DRAWER } from '@/store/mutation_type'
import { SIGN_OUT } from '@/store/action_type'

export default {
  name: 'TheNavigation',
  data () {
    return {
      authItems: [
        {
          icon: 'mdi-logout',
          content: 'Logout',
          event: () => this.logout()
        }
      ],
      noAuthItems: [
        {
          icon: 'mdi-account-check',
          content: 'Sign up',
          event: () => this.href('/signup')
        },
        {
          icon: 'mdi-login',
          content: 'Login',
          event: () => this.href('/login')
        }
      ]
    }
  },
  computed: {
    ...mapGetters([
      'isLoggedIn',
      'currentUserName'
    ]),
    items () {
      return this.isLoggedIn ? this.authItems : this.noAuthItems
    }
  },
  methods: {
    toggleDrawer () {
      this.$store.commit(TOGGLE_DRAWER)
    },
    logout () {
      this.$store.dispatch(SIGN_OUT)
    },
    href (path) {
      this.$router.push(path).catch(() => {})
    }
  }
}
</script>
