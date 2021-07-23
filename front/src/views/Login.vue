<template>
  <v-container fill-height>
    <v-row>
      <v-col cols="12" class="align-center">
        <v-card
          class="mx-auto"
          max-width="794"
        >
          <v-card-title>
            Login
          </v-card-title>
          <v-divider />
          <v-container>
            <v-form
              ref="form"
              v-model="isValid"
              lazy-validation
            >
              <InputEmailField
                :email="params.email"
                @set="setEmail"
              />
              <InputPasswordField
                :password="params.password"
                @set="setPassword"
              />
              <v-checkbox
                v-model="params.remember_me"
                label="Keep your session?"
                required
              />
              <v-divider class="pb-4" />
              <v-btn
                :disabled="!isValid"
                color="success"
                class="mr-4"
                :loading="loading"
                @click.prevent="login"
              >
                Login
              </v-btn>
            </v-form>
          </v-container>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { SIGN_IN } from '@/store/action_type'
import InputEmailField from '@/components/InputEmailField'
import InputPasswordField from '@/components/InputPasswordField'

export default {
  name: 'Login',
  components: {
    InputEmailField,
    InputPasswordField
  },
  data () {
    return {
      params: {
        email: '',
        password: '',
        remember_me: false
      },
      isValid: false,
      loading: false
    }
  },
  methods: {
    async login () {
      this.$refs.form.validate()
      if (!this.isValid) return

      this.loading = true
      try {
        await this.$store.dispatch(SIGN_IN, this.params)
      } catch (e) {
        this.loading = false
      }
    },
    setEmail (v) {
      this.params.email = v
    },
    setPassword (v) {
      this.params.password = v
    }
  }
}
</script>
