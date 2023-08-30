---
to: <%= rootDirectory %>/components/form/Expansion.vue
force: true
---
<script setup lang="ts">
interface Props {
  /** ラベル */
  label: string,
  /** 開閉状態（true: 開、false:閉） */
  expanded: boolean
}
const props = withDefaults(defineProps<Props>(), {
  label: "",
  initial: {},
})
const panel = ref<number | null>(props.expanded ? 0 : null)
</script>

<template>
  <v-expansion-panels v-model="panel" class="mb-4">
    <v-expansion-panel expand>
      <v-expansion-panel-header>
        {{ props.label }}
      </v-expansion-panel-header>
      <v-expansion-panel-content class="expansion-content">
        <v-container grid-list-md>
          <slot/>
        </v-container>
      </v-expansion-panel-content>
    </v-expansion-panel>
  </v-expansion-panels>
</template>

<style scoped>
.expansion-content {
  background-color: #EEEEEE;
}
.expansion-content >>> .v-expansion-panel-content__wrap {
  padding: 0;
}
</style>
