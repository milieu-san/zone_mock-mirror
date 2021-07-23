<template>
  <v-overlay :value="globalLoading">
    <v-progress-circular
      indeterminate
      size="64"
    />
  </v-overlay>
</template>

<script>
export default {
  name: 'TheGlobalLoader',
  computed: {
    globalLoading () {
      return this.$store.state.app.globalLoading
    }
  }
}
</script>
