---
to: <%= rootDirectory %>/<%= projectName %>/layouts/error.vue
force: true
---
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

<script>
export default {
  layout: 'empty',
  props: {
    error: {
      type: Object,
      default: null
    }
  },
  data() {
    return {
      pageNotFound: '404 Not Found',
      otherError: this.error.message || 'An error occurred'
    }
  },
  computed: {
    to: function () {
      return '/'
    },
    linkTitle: function () {
      return 'Topに戻る'
    }
  },
  head() {
    const title = this.error.statusCode === 404 ? this.pageNotFound : this.otherError
    return {
      title
    }
  }
}
</script>

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
