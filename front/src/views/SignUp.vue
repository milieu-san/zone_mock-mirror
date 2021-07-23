<template>
  <v-container fill-height>
    <v-row>
      <v-col cols="12" class="align-center">
        <v-card
          class="mx-auto"
          max-width="794"
        >
          <v-card-title>
            SignUp
          </v-card-title>
          <v-divider />
          <v-container>
            <v-form
              ref="form"
              v-model="isValid"
              lazy-validation
            >
              <InputUserNameField
                :name="params.name"
                @set="setName"
              />
              <InputEmailField
                :email="params.email"
                @set="setEmail"
              />
              <InputPasswordField
                :password="params.password"
                @set="setPassword"
              />
              <InputPasswordField
                :password="params.password_confirmation"
                label="Password Confirmation"
                hint="Try to type same password above"
                @set="setPasswordConf"
              />
              <v-divider class="pb-4" />
              <v-btn
                :disabled="!isValid"
                color="primary"
                class="mr-4"
                :loading="loading"
                @click="signUp"
              >
                SignUp
              </v-btn>
            </v-form>
          </v-container>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { SIGN_UP } from '@/store/action_type'
import InputUserNameField from '@/components/InputUserNameField'
import InputEmailField from '@/components/InputEmailField'
import InputPasswordField from '@/components/InputPasswordField'

export default {
  name: 'SignUp',
  components: {
    InputUserNameField,
    InputEmailField,
    InputPasswordField
  },
  data () {
    return {
      params: {
        name: '',
        email: '',
        password: '',
        password_confirmation: ''
      },
      isValid: false,
      loading: false
    }
  },
  methods: {
    async signUp () {
      this.$refs.form.validate()
      if (!this.isValid) return

      this.loading = true
      try {
        await this.$store.dispatch(SIGN_UP, this.params)
      } catch {
        this.loading = false
      }
    },
    setName (v) {
      this.params.name = v
    },
    setEmail (v) {
      this.params.email = v
    },
    setPassword (v) {
      this.params.password = v
    },
    setPasswordConf (v) {
      this.params.password_confirmation = v
    }
  }
}
</script>
