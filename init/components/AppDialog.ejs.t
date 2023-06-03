---
to: <%= rootDirectory %>/<%= projectName %>/components/modal/AppDialog.vue
force: true
---
<template>
  <v-dialog v-model="state.open" :persistent="state.persistent" width="400">
    <v-card>
      <v-card-title class="dialog-title">{{ state.title }}</v-card-title>

      <v-card-text class="dialog-text">{{ state.message }}</v-card-text>

      <v-card-actions>
        <v-btn v-if="!!state.negativeText" color="grey darken-1" text @click="negative">
          {{ state.negativeText }}
        </v-btn>
        <v-spacer></v-spacer>
        <v-btn v-if="!!state.neutralText" color="red darken-1" text @click="neutral">
          {{ state.neutralText }}
        </v-btn>
        <v-spacer></v-spacer>
        <v-btn color="blue darken-1" text @click="positive">
          {{ state.positiveText }}
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script lang="ts">
import {Component, Vue} from 'nuxt-property-decorator'
import {vxm} from '@/store'

@Component
export default class AppDialog extends Vue {
  get state() {
    return vxm.app.dialog
  }

  close() {
    this.state.open = false
    if (this.state.close) {
      this.state.close()
    }
  }

  positive() {
    if (this.state.positive) {
      this.state.positive()
    }
    this.close()
  }

  neutral() {
    if (this.state.neutral) {
      this.state.neutral()
    }
    this.close()
  }

  negative() {
    if (this.state.negative) {
      this.state.negative()
    }
    this.close()
  }
}
</script>

<style scoped>
.dialog-title {
}

.dialog-text {
  white-space: pre-wrap;
}
</style>
