<template>
  <v-avatar
    :color="getColorById"
    :size="size"
  >
    <span class="white--text" :class="textSize">
      {{ headTwoStr }}
    </span>
  </v-avatar>
</template>

<script>
export default {
  name: 'IconUser',
  props: {
    id: {
      type: Number,
      required: true
    },
    name: {
      type: String,
      required: true
    },
    size: {
      type: Number,
      default: 40
    },
    textSize: {
      type: String,
      default: ''
    }
  },
  data () {
    return {
      colors: ['blue', 'indigo', 'deep-purple', 'cyan', 'green', 'orange', 'grey darken-1']
    }
  },
  computed: {
    headTwoStr () {
      return this.name.slice(0, 2)
    },
    getColorById () {
      return this.colors[this.id % this.colors.length]
    }
  }
}
</script>
