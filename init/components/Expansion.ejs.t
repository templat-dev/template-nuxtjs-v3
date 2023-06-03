---
to: <%= rootDirectory %>/<%= projectName %>/components/form/Expansion.vue
force: true
---
<template>
  <v-expansion-panels v-model="panel" class="mb-4">
    <v-expansion-panel expand>
      <v-expansion-panel-header>
        {{ label }}
      </v-expansion-panel-header>
      <v-expansion-panel-content class="expansion-content">
        <v-container grid-list-md>
          <slot/>
        </v-container>
      </v-expansion-panel-content>
    </v-expansion-panel>
  </v-expansion-panels>
</template>

<script lang="ts">
import {Component, Prop, Vue} from 'nuxt-property-decorator'

@Component
export default class Expansion extends Vue {
  @Prop({type: String, required: true})
  readonly label!: string

  @Prop({type: Boolean, default: false})
  expanded!: boolean

  panel: number | null = this.expanded ? 0 : null
}
</script>

<style scoped>
.expansion-content {
  background-color: #EEEEEE;
}

.expansion-content >>> .v-expansion-panel-content__wrap {
  padding: 0;
}
</style>
