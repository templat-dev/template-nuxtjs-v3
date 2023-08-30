---
to: <%= rootDirectory %>/components/modal/AppLoading.vue
force: true
---
<script setup lang="ts">
import {useAppLoading} from "~/composables/useLoading"

const appLoading = useAppLoading()
</script>

<template>
  <v-overlay :value="appLoading.isLoading" :z-index="300">
    <v-progress-circular color="primary" indeterminate size="64"></v-progress-circular>
  </v-overlay>
</template>

<style scoped></style>
