<template>
  <v-text-field
    :value="email"
    :rules="[rule.required, rule.format]"
    name="email"
    label="E-mail"
    autocomplete="email"
    class="pt-5"
    @change="update"
  />
</template>

<script>
export default {
  name: 'InputEmailField',
  props: {
    email: {
      type: String,
      required: true
    }
  },
  data () {
    return {
      rule: {
        required: v => !!v || 'E-mail is required',
        format: v => /.+@.+\..+/.test(v) || 'E-mail must be valid'
      }
    }
  },
  methods: {
    update (v) {
      this.$emit('set', v)
    }
  }
}
</script>
