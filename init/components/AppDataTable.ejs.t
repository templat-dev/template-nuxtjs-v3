---
to: <%= rootDirectory %>/<%= projectName %>/components/common/AppDataTable.vue
force: true
---
<template>
  <v-data-table
    v-bind="$attrs"
    :footer-props="footerProps"
    :headers="headers"
    :items="items || []"
    :items-per-page.sync="syncedPageInfo.itemsPerPage"
    :loading="isLoading"
    :page.sync="syncedPageInfo.page"
    :server-items-length="totalCount"
    :sort-by.sync="syncedPageInfo.sortBy"
    :sort-desc.sync="syncedPageInfo.sortDesc"
    class="data-table"
    @click:row="item => openEntryForm(item)"
    @update:page="handleChangePageInfo()"
    @update:items-per-page="handleChangePageInfo()"
    @update:sort-by="handleChangePageInfo('sortBy')"
    @update:sort-desc="handleChangePageInfo('sortDesc')"
  >
    <template v-for="(_, slotName) in $scopedSlots" v-slot:[slotName]="props">
      <slot v-bind="props" :name="slotName"/>
    </template>
  </v-data-table>
</template>

<script lang="ts">
import {Component, Emit, mixins, Prop, PropSync} from 'nuxt-property-decorator'
import Base from '@/mixins/base'
import appUtils from '@/utils/appUtils'
import {DataTableHeader} from 'vuetify'

export interface DataTablePageInfo {
  /** ページ番号 (初期ページは1) */
  page: number
  /** ページサイズ (全件指定時は-1) */
  itemsPerPage: number
<%_ if (entity.dbType === 'datastore') { -%>
  /** ページング用のcursor配列 */
  cursors: string[]
<%_ } -%>
  /** ソートカラム配列 */
  sortBy: string[]
  /** ソート順序配列 */
  sortDesc: boolean[]
}

export const INITIAL_DATA_TABLE_PAGE_INFO: DataTablePageInfo = {
  page: 1,
  itemsPerPage: 30,
<%_ if (entity.dbType === 'datastore') { -%>
  cursors: [],
<%_ } -%>
  sortBy: [],
  sortDesc: [],
}

export const DEFAULT_FOOTER_PROPS = {
  'items-per-page-options': [INITIAL_DATA_TABLE_PAGE_INFO.itemsPerPage, 50, 100, -1],
  'items-per-page-text': '1ページあたりの件数',
  'page-text': '{2}件中の{0}~{1}件を表示中'
}

@Component
export default class AppDataTable<I, S> extends mixins(Base) {
  /** ヘッダー定義 */
  @Prop({type: Array, required: true})
  headers!: DataTableHeader[]

  /** フッター定義 */
  @Prop({type: Object, default: () => DEFAULT_FOOTER_PROPS})
  footerProps!: {}

  /** 一覧表示用の配列 */
  @Prop({type: Array})
  items!: I[]

  /** ベージ表示情報 */
  @PropSync('pageInfo', {type: Object, required: true})
  syncedPageInfo!: DataTablePageInfo

  /** 全ての件数 */
  @Prop({type: Number, default: undefined})
  totalCount!: number | undefined

  /** 一覧の読み込み状態 */
  @Prop({type: Boolean, required: true})
  isLoading!: boolean

  /** onChangePageInfo発火制御フラグ */
  changeAccepted: boolean = false

  async handleChangePageInfo(event?: string) {
    // sortByとsortDescが同時に来るため制御する
    // （sortBy → sortDescの順番でイベントがくる）
    if (event === 'sortBy') {
      this.changeAccepted = true
      await appUtils.wait(100)
      if (!this.changeAccepted) {
        return
      }
    }
    if (event === 'sortDesc') {
      this.changeAccepted = false
    }
    this.onChangePageInfo()
  }

  @Emit('onChangePageInfo')
  onChangePageInfo() {
  }

  @Emit('openEntryForm')
  openEntryForm(item: I) {
    return item
  }
}
</script>

<style scoped>
.data-table >>> tbody tr:not(.v-data-table__empty-wrapper) {
  cursor: pointer;
}
</style>
