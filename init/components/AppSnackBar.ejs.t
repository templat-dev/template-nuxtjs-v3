---
to: <%= rootDirectory %>/components/modal/AppSnackBar.vue
force: true
---
<script setup lang="ts">
import {useAppSnackbar} from "~/composables/useSnackbar"

const appSnackbar = useAppSnackbar()

const close = () => {
  appSnackbar.close()
}

const action = () => {
  appSnackbar.action()
  close()
}
</script>

<template>
  <v-snackbar v-model="appSnackbar.isOpen" :timeout="appSnackbar.timeout">
    {{ appSnackbar.text }}
    <template v-if="appSnackbar.actionText" v-slot:action="{ attrs }">
      <v-btn v-bind="attrs" color="primary" text @click="action">
        {{ appSnackbar.actionText }}
      </v-btn>
    </template>
  </v-snackbar>
</template>

<style scoped></style>
