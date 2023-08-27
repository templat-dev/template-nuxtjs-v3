---
to: <%= rootDirectory %>/components/modal/AppSnackBar.vue
force: true
---
<script setup lang="ts">
import {useAppDialog} from "~/composables/states"

const appDialog = useAppDialog()

const close = () => {
  appDialog.open = false
}

const action = () => {
  if (appDialog.action) {
    appDialog.action()
  }
  close()
}
</script>

<template>
  <v-snackbar v-model="appDialog.open" :timeout="appDialog.timeout">
    {{ state.text }}
    <template v-if="appDialog.actionText" v-slot:action="{ attrs }">
      <v-btn v-bind="attrs" color="primary" text @click="action">
        {{ appDialog.actionText }}
      </v-btn>
    </template>
  </v-snackbar>
</template>

<style scoped></style>
