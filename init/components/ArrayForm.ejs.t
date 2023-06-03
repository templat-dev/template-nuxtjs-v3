---
to: <%= rootDirectory %>/<%= projectName %>/components/form/ArrayForm.vue
force: true
---
<template>
  <v-layout>
    <v-flex>
      <v-toolbar color="white" flat>
        <v-spacer></v-spacer>
        <v-btn class="action-button" color="primary" dark fab small top @click="addItem">
          <v-icon>mdi-plus</v-icon>
        </v-btn>
      </v-toolbar>
      <v-list v-if="syncedItems && syncedItems.length > 0">
        <v-list-item v-for="(item, index) in syncedItems" :key="index">
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

<script lang="ts">
import {Component, mixins, Prop, PropSync} from 'nuxt-property-decorator'
import {vxm} from '@/store'
import Base from '@/mixins/base'

@Component
export default class ArrayForm<T> extends mixins(Base) {
  /** 編集対象 */
  @PropSync('items', {type: Array})
  syncedItems!: T[]

  /** 単一の編集対象の初期値 */
  @Prop()
  initial!: T

  addItem() {
    if (!this.syncedItems) {
      this.syncedItems = [this.initial]
    } else {
      this.syncedItems.push(this.initial)
    }
  }

  updatedForm(index: number, item: T) {
    this.$set(this.syncedItems, index, item)
  }

  remove(index: number) {
    vxm.app.showDialog({
      title: '削除確認',
      message: '削除してもよろしいですか？',
      negativeText: 'Cancel',
      positive: async () => {
        this.syncedItems.splice(index, 1)
      }
    })
  }
}
</script>

<style scoped>
.list-content {
  padding: 0 12px;
}
</style>
