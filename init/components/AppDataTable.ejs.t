---
to: <%= rootDirectory %>/components/common/AppDataTable.vue
force: true
---
<script setup lang="ts" generic="I, S">
import appUtils from '@/utils/appUtils'
import {DataTableHeader} from 'vuetify'

export interface SingleSearchCondition<T> {
  enabled: boolean
  value: T
}

export interface BaseSearchCondition {
  [key: string]: SingleSearchCondition<string | number | boolean>
}

export interface DataTablePageInfo {
  /** ページ番号 (初期ページは1) */
  page: number
  /** ページサイズ (全件指定時は-1) */
  itemsPerPage: number
<%_ if (struct.dbType === 'datastore') { -%>
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
<%_ if (struct.dbType === 'datastore') { -%>
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

interface Props {
  /** ヘッダー定義 */
  headers!: DataTableHeader[],
  /** フッター定義 */
  footerProps!: {},
  /** 一覧表示用の配列 */
  items!: I[],
  /** ベージ表示情報 */
  pageInfo!: DataTablePageInfo,
  /** 全ての件数 */
  totalCount!: number | undefined,
  /** 一覧の読み込み状態 */
  isLoading!: boolean
}
const props = withDefaults(defineProps<Props>(), {
  headers: [],
  footerProps: DEFAULT_FOOTER_PROPS,
  items: [],
  pageInfo: {},
  totalCount: undefined
  isLoading: true
})

interface Emits {
  (e: "update:pageInfo"): void
  (e: "openEntryForm", item: I): void
}
const emit = defineEmits<Emits>()

/** onChangePageInfo発火制御フラグ */
const changeAccepted = ref<boolean>(false)

const handleChangePageInfo = async (event?: string) => {
  // sortByとsortDescが同時に来るため制御する
  // （sortBy → sortDescの順番でイベントがくる）
  if (event === 'sortBy') {
    changeAccepted.value = true
    await appUtils.wait(100)
    if (!changeAccepted.value) {
      return
    }
  }
  if (event === 'sortDesc') {
    changeAccepted.value = false
  }
  onChangePageInfo()
}

const onChangePageInfo = () => {
  emit('onChangePageInfo')
}

const openEntryForm = (item: I) => {
  emit('openEntryForm', item)
}
</script>

<template>
  <v-data-table
    v-bind="$attrs"
    :footer-props="footerProps"
    :headers="headers"
    :items="items || []"
    :items-per-page.sync="pageInfo.itemsPerPage"
    :loading="isLoading"
    :page.sync="pageInfo.page"
    :server-items-length="totalCount"
    :sort-by.sync="pageInfo.sortBy"
    :sort-desc.sync="pageInfo.sortDesc"
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

<style scoped>
.data-table >>> tbody tr:not(.v-data-table__empty-wrapper) {
  cursor: pointer;
}
</style>
