---
to: <%= rootDirectory %>/<%= projectName %>/components/modal/AppLoading.vue
force: true
---
<template>
  <v-overlay :value="state" :z-index="300">
    <v-progress-circular color="primary" indeterminate size="64"></v-progress-circular>
  </v-overlay>
</template>

<script lang="ts">
import {Component, Vue} from 'nuxt-property-decorator'
import {vxm} from '@/store'

@Component
export default class AppLoading extends Vue {
  get state() {
    return vxm.app.loading
  }
}
</script>

<style scoped></style>
