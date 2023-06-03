---
to: <%= rootDirectory %>/<%= projectName %>/components/modal/AppSnackBar.vue
force: true
---
<template>
  <v-snackbar v-model="state.open" :timeout="state.timeout">
    {{ state.text }}
    <template v-if="state.actionText" v-slot:action="{ attrs }">
      <v-btn v-bind="attrs" color="primary" text @click="action">
        {{ state.actionText }}
      </v-btn>
    </template>
  </v-snackbar>
</template>

<script lang="ts">
import {Component, Vue} from 'nuxt-property-decorator'
import {vxm} from '@/store'

@Component
export default class AppSnackBar extends Vue {
  get state() {
    return vxm.app.snackbar
  }

  close() {
    this.state.open = false
  }

  action() {
    if (this.state.action) {
      this.state.action()
    }
    this.close()
  }
}
</script>

<style scoped></style>
