---
to: <%= rootDirectory %>/components/form/ArrayForm.vue
force: true
---
<script setup lang="ts" generic="T">
import {useAppDialog} from '~/composables/useDialog'
import {useAppLoading} from '~/composables/useLoading'

const loading = useAppLoading()
const dialog = useAppDialog()

interface Props {
  /** 編集対象 */
  items?: T[],
  /** 単一の編集対象の初期値 */
  initial: T,
}
const props = withDefaults(defineProps<Props>(), {
  items: (props: Props) => [],
})

interface Emits {
  (e: "add-item", item: T): void;
  (e: "update-item", index: number, item: T): void;
  (e: 'remove-item', index: number): void;
}
const emit = defineEmits<Emits>()

const addItem = () => {
  emit('add-item', props.initial)
}

const updatedForm = (index: number, item: T) => {
  emit('update-item', index, item)
}

const remove = (index: number) => {
  dialog.showDialog({
    title: '削除確認',
    message: '削除してもよろしいですか？',
    negativeText: 'Cancel',
    positive: async () => {
      emit('remove-item', index)
    }
  })
}
</script>

<template>
  <v-layout>
    <v-flex>
      <v-toolbar color="white" flat>
        <v-spacer></v-spacer>
        <v-btn class="action-button" color="primary" dark fab small top @click="addItem">
          <v-icon>mdi-plus</v-icon>
        </v-btn>
      </v-toolbar>
      <v-list v-if="props.items && props.items.length > 0">
        <v-list-item v-for="(item, index) in props.items" :key="index">
          <v-list-item-content class="list-content">
            <slot :editTarget="item"
                  :updatedForm="value => updatedForm(index, value)"></slot>
          </v-list-item-content>
          <v-list-item-action>
            <v-btn icon @click="remove(index)">
              <v-icon>mdi-delete</v-icon>
            </v-btn>
          </v-list-item-action>
        </v-list-item>
      </v-list>
    </v-flex>
  </v-layout>
</template>

<style scoped>
.list-content {
  padding: 0 12px;
}
</style>
