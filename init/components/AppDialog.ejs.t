---
to: <%= rootDirectory %>/components/modal/AppDialog.vue
force: true
---
<script setup lang="ts">
import {useAppDialog} from "@/composables/useDialog"

const {state: dialogState, close: dialogClose, positive: dialogPositive, neutral: dialogNeural, negative: dialogNegative} = useAppDialog()
const open = ref<boolean>(false)

const openValue = computed(() => {
  console.log(`dialogState.value.open: ${dialogState.value.open}`)
  return dialogState.value.open
})

const isPersistent = computed<boolean>(() => dialogState.value.persistent || false)

const positive = () => {
  dialogPositive()
  dialogClose()
}

const neutral = () => {
  dialogNeural()
  dialogClose()
}

const negative = () => {
  dialogNegative()
  dialogClose()
}
</script>

<template>
  <v-dialog v-model="openValue" :persistent="isPersistent" width="400">
    <v-card>
      <v-card-title class="dialog-title">{{ dialogState.title }}</v-card-title>

      <v-card-text class="dialog-text">{{ dialogState.message }}</v-card-text>

      <v-card-actions>
        <v-btn v-if="!!dialogState.negativeText" color="grey darken-1" text @click="negative">
          {{ dialogState.negativeText }}
        </v-btn>
        <v-spacer></v-spacer>
        <v-btn v-if="!!dialogState.neutralText" color="red darken-1" text @click="neutral">
          {{ dialogState.neutralText }}
        </v-btn>
        <v-spacer></v-spacer>
        <v-btn color="blue darken-1" text @click="positive">
          {{ dialogState.positiveText }}
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
