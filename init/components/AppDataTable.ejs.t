---
to: <%= rootDirectory %>/components/common/AppDataTable.vue
force: true
---
<script setup lang="ts" generic="I, S">
import appUtils from '@/utils/appUtils'
import {DataTablePageInfo, DEFAULT_FOOTER_PROPS} from "~/types/DataTableType"

interface Props {
  /** ヘッダー定義 */
  headers: any[],
  /** フッター定義 */
  footerProps?: {},
  /** 一覧表示用の配列 */
  items: I[],
  /** ベージ表示情報 */
  pageInfo: DataTablePageInfo,
  /** 全ての件数 */
  totalCount: number | undefined,
  /** 一覧の読み込み状態 */
  isLoading: boolean
}
const props = withDefaults(defineProps<Props>(), {
  headers: (props: Props) => [],
  footerProps: (props: Props) => DEFAULT_FOOTER_PROPS,
  items: (props: Props) => [],
  pageInfo: (props: Props) => ({} as DataTablePageInfo),
  totalCount: undefined,
  isLoading: true,
})

interface Emits {
  (e: "reFetch"): void
  (e: "update:itemsPerPage", count: number): void
  (e: "click:row", item: I): void
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
  emit('reFetch')
}

const handleItemPerPage = (itemsPerPage: number) => {
  emit('update:itemsPerPage', itemsPerPage)
}

const clickRow = (item: I) => {
  emit('click:row', item)
}
</script>

<template>
  <v-data-table
    :footer-props="footerProps"
    :headers="headers"
    :items="items || []"
    :items-per-page="pageInfo.itemsPerPage"
    :loading="isLoading"
    :page="pageInfo.page"
    :server-items-length="totalCount"
    :sort-by="pageInfo.sortBy"
    class="data-table"
    @click:row="(event: Event, item: any) => clickRow(item.item)"
    @update:page="handleChangePageInfo()"
    @update:items-per-page="handleItemPerPage"
    @update:sort-by="handleChangePageInfo('sortBy')"
  >
    <template v-for="(_, slotName) in $slots" v-slot:[slotName]="props">
      <slot v-bind="props" :name="slotName"/>
    </template>
  </v-data-table>
</template>

<style scoped>
.data-table {
  width: 900px;
}
.data-table >>> tbody tr:not(.v-data-table__empty-wrapper) {
  cursor: pointer;
}
</style>
