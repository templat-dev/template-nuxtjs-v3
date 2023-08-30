---
to: <%= rootDirectory %>/components/form/StructArrayForm.vue
force: true
---
<script setup lang="ts" generic="T">
import {cloneDeep} from 'lodash-es'
import {useAppDialog} from '@/composables/useDialog'
import {NEW_INDEX} from '@/constants/appConstants'

const dialog = useAppDialog()

interface Props {
  /** 編集対象 */
  items?: T[],
  /** 単一の編集対象の初期値 */
  initial: T
  /** 編集対象Model */
  editTarget: T | null
  /** 編集対象のインデックス番号 */
  editIndex: number
}
const props = withDefaults(defineProps<Props>(), {
  items: (props: Props) => [],
  editTarget: null,
  editIndex: 0
})

interface Emits {
  (e: "add-item", item: T): void;
  (e: "update-item", item: T, index: number): void;
  (e: "remove-item", index: number): void;
  (e: "edit-item", item: T, index: number): void;
}
const emit = defineEmits<Emits>()

/** 編集ダイアログ表示状態 (true: 表示, false: 非表示) */
const isEntryFormOpen = ref<boolean>(false)

const openEntryForm = (item?: T) => {
  if (!!item) {
    emit('edit-item', item, props.items.indexOf(item))
  } else {
    emit('edit-item', cloneDeep(props.initial), NEW_INDEX)
  }
  isEntryFormOpen.value = true
}

const closeEntryForm = () => {
  isEntryFormOpen.value = false
}

const updatedForm = () => {
  if (!props.editTarget) {
    return
  }
  if (!props.items) {
    emit('add-item', props.editTarget)
  } else if (props.editIndex === NEW_INDEX) {
    emit('add-item', props.editTarget)
  } else {
    emit('update-item', props.editTarget, props.editIndex)
  }
  closeEntryForm()
}

const removeRow = (item: T) => {
  const index = props.items.indexOf(item)
  remove(index)
}

const removeForm = () => {
  remove(props.editIndex)
}

const remove = (index: number) => {
  dialog.showDialog({
    title: '削除確認',
    message: '削除してもよろしいですか？',
    negativeText: 'Cancel',
    positive: async () => {
      emit('remove-item', index)
      closeEntryForm()
    }
  })
}
</script>

<template>
  <v-layout>
    <v-flex>
      <slot
        :items="props.items"
        :openEntryForm="openEntryForm"
        :removeRow="removeRow"
        name="table"
      ></slot>
    </v-flex>
    <v-dialog v-model="isEntryFormOpen" max-width="800px" persistent>
      <slot
        :closeForm="closeEntryForm"
        :editIndex="editIndex"
        :editTarget="editTarget"
        :isEntryFormOpen="isEntryFormOpen"
        :removeForm="removeForm"
        :updatedForm="updatedForm"
        name="form"
      ></slot>
    </v-dialog>
  </v-layout>
</template>

<style scoped></style>
