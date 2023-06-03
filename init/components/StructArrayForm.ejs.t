---
to: <%= rootDirectory %>/<%= projectName %>/components/form/StructArrayForm.vue
force: true
---
<template>
  <v-layout>
    <v-flex>
      <slot
        :items="syncedItems"
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

<script lang="ts">
import {Component, mixins, Prop, PropSync} from 'nuxt-property-decorator'
import {vxm} from '@/store'
import Base from '@/mixins/base'
import {cloneDeep} from 'lodash-es'

@Component
export default class StructArrayForm<T> extends mixins(Base) {
  /** 編集対象 */
  @PropSync('items', {type: Array})
  syncedItems!: T[]

  /** 単一の編集対象の初期値 */
  @Prop({type: Object, required: true})
  initial!: T

  /** 編集対象Model */
  editTarget: T | null = null

  /** 編集対象のインデックス番号 */
  editIndex: number = 0

  /** 編集ダイアログ表示状態 (true: 表示, false: 非表示) */
  isEntryFormOpen: boolean = false

  openEntryForm(item?: T) {
    if (!!item) {
      this.editTarget = cloneDeep(item)
      this.editIndex = this.syncedItems.indexOf(item)
    } else {
      this.editTarget = cloneDeep(this.initial)
      this.editIndex = this.NEW_INDEX
    }
    this.isEntryFormOpen = true
  }

  closeEntryForm() {
    this.isEntryFormOpen = false
  }

  updatedForm() {
    if (!this.editTarget) {
      return
    }
    if (!this.syncedItems) {
      this.syncedItems = [this.editTarget]
    } else if (this.editIndex === this.NEW_INDEX) {
      this.syncedItems.push(this.editTarget)
    } else {
      this.$set(this.syncedItems, this.editIndex, this.editTarget)
    }
    this.closeEntryForm()
  }

  removeRow(item: T) {
    const index = this.syncedItems.indexOf(item)
    this.remove(index)
  }

  removeForm() {
    this.remove(this.editIndex)
  }

  remove(index: number) {
    vxm.app.showDialog({
      title: '削除確認',
      message: '削除してもよろしいですか？',
      negativeText: 'Cancel',
      positive: async () => {
        this.syncedItems!.splice(index, 1)
        this.closeEntryForm()
      }
    })
  }
}
</script>

<style scoped></style>
