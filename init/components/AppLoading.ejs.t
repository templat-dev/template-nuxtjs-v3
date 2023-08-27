---
to: <%= rootDirectory %>/components/modal/AppLoading.vue
force: true
---
<script setup lang="ts">
import {useAppLoading} from "~/composables/states"

const appLoading = useAppLoading()
</script>

<template>
  <v-overlay :value="appLoading" :z-index="300">
    <v-progress-circular color="primary" indeterminate size="64"></v-progress-circular>
  </v-overlay>
</template>

<style scoped></style>
