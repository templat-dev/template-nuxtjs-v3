---
to: <%= rootDirectory %>/components/modal/AppDialog.vue
force: true
---
<script setup lang="ts">
import {useAppDialog} from "@/composables/useDialog"

const appDialog = useAppDialog()

const close = () => {
  appDialog.close()
}

const positive = () => {
  appDialog.positive()
  close()
}

const neutral = () => {
  appDialog.neutral()
  close()
}

const negative = () => {
  appDialog.negative()
  close()
}
</script>

<template>
  <v-dialog v-model="appDialog.isOpen" :persistent="appDialog.isPersistent" width="400">
    <v-card>
      <v-card-title class="dialog-title">{{ appDialog.title }}</v-card-title>

      <v-card-text class="dialog-text">{{ appDialog.message }}</v-card-text>

      <v-card-actions>
        <v-btn v-if="!!appDialog.negativeText" color="grey darken-1" text @click="negative">
          {{ appDialog.negativeText }}
        </v-btn>
        <v-spacer></v-spacer>
        <v-btn v-if="!!appDialog.neutralText" color="red darken-1" text @click="neutral">
          {{ appDialog.neutralText }}
        </v-btn>
        <v-spacer></v-spacer>
        <v-btn color="blue darken-1" text @click="positive">
          {{ appDialog.positiveText }}
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<style scoped>
.dialog-title {
}

.dialog-text {
  white-space: pre-wrap;
}
</style>
