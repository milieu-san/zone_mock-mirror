<template>
  <v-text-field
    :value="password"
    :append-icon="isVisible ? 'mdi-eye' : 'mdi-eye-off'"
    :rules="[rule.required, rule.min]"
    :type="isVisible ? 'text' : 'password'"
    name="password"
    :label="label"
    :hint="hint"
    counter
    autocomplete="password"
    class="pt-5"
    @click:append="isVisible = !isVisible"
    @change="update"
  />
</template>

<script>
export default {
  name: 'InputPasswordField',
  props: {
    password: {
      type: String,
      required: true
    },
    label: {
      type: String,
      default: 'Password'
    },
    hint: {
      type: String,
      default: 'At least 8 characters'
    }
  },
  data () {
    return {
      rule: {
        required: value => !!value || 'Password is required.',
        min: v => v.length >= 8 || 'Min 8 characters'
      },
      isVisible: false
    }
  },
  methods: {
    update (v) {
      this.$emit('set', v)
    }
  }
}
</script>
