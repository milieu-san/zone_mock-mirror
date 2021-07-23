<template>
  <Layout>
    <router-view></router-view>
  </Layout>
</template>

<script>
import Layout from '@/components/Layout'
import { digSession } from '@/plugins/session'

export default {
  name: 'App',
  components: {
    Layout
  },
  created () {
    digSession()
  }
}
</script>
