<template>
  <v-app>
    <TheSideBar />
    <TheNavigation />
    <v-main>
      <slot />
    </v-main>
    <TheNotificationBar />
    <TheGlobalLoader />
  </v-app>
</template>

<script>
import TheSideBar from '@/components/TheSideBar'
import TheNavigation from '@/components/TheNavigation'
import TheNotificationBar from '@/components/TheNotificationBar'
import TheGlobalLoader from '@/components/TheGlobalLoader'

export default {
  name: 'Layout',
  components: {
    TheSideBar,
    TheNavigation,
    TheNotificationBar,
    TheGlobalLoader
  }
}
</script>
