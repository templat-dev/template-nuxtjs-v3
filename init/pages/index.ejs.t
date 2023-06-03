---
to: <%= rootDirectory %>/<%= projectName %>/pages/index.vue
force: true
---
<template>
  <v-container>
    <v-row class="align-content-start">
      <!-- メニュー -->
    </v-row>
  </v-container>
</template>

<script lang="ts">
import {Component, mixins} from 'nuxt-property-decorator'
import Base from '@/mixins/base'

@Component<%_ if (entity.plugins.includes('auth')) { -%>({middleware: 'auth'})<%_ } %>
export default class TopPage extends mixins(Base) {
}
</script>

<style scoped>
.comment {
  min-height: 20px;
}
</style>
