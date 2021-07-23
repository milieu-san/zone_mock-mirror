<template>
  <v-container fill-height>
    <v-row class="text-center align-center">
      <v-col cols="12">
        <v-img
          :src="require('../assets/logo-512x512.png')"
          class="my-3"
          contain
          height="200"
        />
      </v-col>
      <v-col class="mb-4">
        <h1 class="display-2 font-weight-bold mb-3">
          Welcome to Zone-Mock
        </h1>

        <p class="subheading font-weight-regular">
          We eliminate the boredom of remote work!
          <br>Please try
          <a @click.prevent="href('/free_room')">
            free access
          </a>
        </p>
      </v-col>
      <v-col
        class="mb-5"
        cols="12"
      >
        <h2 class="headline font-weight-bold mb-3">
          What's next?
        </h2>

        <v-row justify="center">
          <a
            v-for="(next, i) in whatsNext"
            :key="i"
            @click.prevent="href(next.href)"
            class="subheading mx-3"
          >
            {{ next.text }}
          </a>
        </v-row>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
export default {
  name: 'Top',
  data: () => ({
    whatsNext: [
      {
        text: 'Sign up',
        href: '/signup'
      },
      {
        text: 'Log in',
        href: '/login'
      }
    ]
  }),
  methods: {
    href (path) {
      this.$router.push(path).catch(() => {})
    }
  }
}
</script>
