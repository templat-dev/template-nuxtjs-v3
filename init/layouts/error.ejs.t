---
to: <%= rootDirectory %>/layouts/error.vue
force: true
---
<script lang="ts" setup>

interface Error {
  statusCode: number
  message: string
}
interface Props {
  error: Error
}
const props = defineProps<Props>()

const pageNotFound = '404 Not Found'
const otherError = props.error.message || 'An error occurred'
const to = computed(() => {
  return '/'
})

const linkTitle = computed(() => {
  return 'Topに戻る'
})

const head = () => {
  const title = props.error.statusCode === 404 ? pageNotFound : otherError
  return {
    title
  }
}
</script>

<template>
  <v-layout align-center>
    <v-card class="auto-flex root">
      <h1 class="mb-4">Sorry, something went wrong.</h1>
      <h2 v-if="error.message">
        {{ error.message }}
      </h2>
      <h2 v-else-if="error.statusCode === 404">
        {{ pageNotFound }}
      </h2>
      <h2 v-else>
        {{ otherError }}
      </h2>
      <a :href="to" class="mt-8 top-link">
        {{ linkTitle }}
      </a>
    </v-card>
  </v-layout>
</template>

<style scoped>
.root {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 48px 24px;
}

h1 {
  font-size: 20px;
  font-weight: normal;
}

h2 {
  font-size: 16px;
  font-weight: normal;
}
</style>
