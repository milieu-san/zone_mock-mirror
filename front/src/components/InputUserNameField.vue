<template>
  <v-text-field
    :value="name"
    :counter="255"
    :rules="[rule.required, rule.max]"
    name="name"
    label="Name"
    autocomplete="user-name"
    class="pt-5"
    @change="update"
  />
</template>

<script>
export default {
  name: 'InputUserNameField',
  props: {
    name: {
      type: String,
      required: true
    }
  },
  data () {
    return {
      rule: {
        required: v => !!v || 'Name is required',
        max: v => (v && v.length <= 255) || 'Name must be less than 255 characters'
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
