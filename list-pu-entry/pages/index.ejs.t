---
to: "<%= struct.generateEnable ? `${rootDirectory}/pages/${struct.name.lowerCamelName}/index.vue` : null %>"
---
<script setup lang="ts">
<%_ const searchConditions = [] -%>
<%_ struct.fields.forEach(function(field, index){ -%>
  <%_ if ((field.listType === 'string' || field.listType === 'array-string' || field.listType === 'time' || field.listType === 'array-time') && field.searchType === 1) { -%>
    <%_ searchConditions.push({name: field.name.lowerCamelNam, type: 'string', range: false}) -%>
  <%_ } -%>
  <%_ if ((field.listType === 'bool' || field.listType === 'array-bool') && field.searchType === 1) { -%>
    <%_ searchConditions.push({name: field.name.lowerCamelNam, type: 'boolean', range: false}) -%>
  <%_ } -%>
  <%_ if ((field.listType === 'number' || field.listType === 'array-number') && field.searchType === 1) { -%>
    <%_ searchConditions.push({name: field.name.lowerCamelNam, type: 'number', range: false}) -%>
  <%_ } -%>
  <%_ if ((field.listType === 'number' || field.listType === 'array-number') && 2 <= field.searchType &&  field.searchType <= 5) { -%>
    <%_ searchConditions.push({name: field.name.lowerCamelNam, type: 'number', range: true}) -%>
  <%_ } -%>
  <%_ if ((field.listType === 'time' || field.listType === 'array-time') && 2 <= field.searchType &&  field.searchType <= 5) { -%>
    <%_ searchConditions.push({name: field.name.lowerCamelNam, type: 'string', range: true}) -%>
  <%_ } -%>
<%_ }) -%>
import {cloneDeep} from 'lodash-es'
import {
  Model<%= struct.name.pascalName %>,
  Model<%= struct.name.pascalPluralName %>,
<%_ struct.fields.forEach(function(field, index){ -%>
  <%_ if (field.listType === 'relation') { -%>
  Model<%= field.related.pascalName %>,
  <%_ } -%>
<%_ }) -%>
} from '@/apis'
import {DataTablePageInfo, DataTableSortItem, INITIAL_DATA_TABLE_PAGE_INFO} from "~/types/DataTableType";
import {
  <%= struct.name.pascalName %>SearchCondition,
  INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION
} from '@/types/<%= struct.name.pascalName %>Type'
import {useAppLoading} from "~/composables/useLoading"
import {useAppSnackbar} from "~/composables/useSnackbar"
import {useAppDialog} from "~/composables/useDialog";

const loading = useAppLoading()
const snackbar = useAppSnackbar()
const dialog = useAppDialog()

/** 一覧表示用の配列 */
const <%= struct.name.lowerCamelPluralName %> = ref<Model<%= struct.name.pascalName %>[]>([])

/** 一覧の表示ページ情報 */
const pageInfo = ref<DataTablePageInfo>(cloneDeep(INITIAL_DATA_TABLE_PAGE_INFO))

/** 一覧の合計件数 */
const totalCount = ref<number>(0)

/** 一覧の読み込み状態 */
const isLoading = ref<boolean>(false)

/** 検索条件 */
const searchCondition = ref<<%= struct.name.pascalName %>SearchCondition>(cloneDeep(INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION))

<%_ struct.fields.forEach(function(field, index){ -%>
  <%_ if (field.listType === 'relation') { -%>
const <%= field.related.lowerCamelPluralName %> = ref<Model<%= field.related.pascalName %>[]>([])
  <%_ } -%>
<%_ }) -%>

const { $api } = useNuxtApp()
const <%= struct.name.lowerCamelName %>Api = $api.<%= struct.name.lowerCamelName %>Api()
<%_ struct.fields.forEach(function(field, index){ -%>
  <%_ if (field.listType === 'relation') { -%>
const <%= field.related.lowerCamelName %>Api = $api.<%= field.related.lowerCamelName %>Api()
  <%_ } -%>
<%_ }) -%>

const fetch = async (
  {searchCondition = INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION, pageInfo = INITIAL_DATA_TABLE_PAGE_INFO}
    : { searchCondition: <%= struct.name.pascalName %>SearchCondition, pageInfo: DataTablePageInfo }
    = {searchCondition: INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION, pageInfo: INITIAL_DATA_TABLE_PAGE_INFO}
): Promise<Model<%= struct.name.pascalPluralName %>> => {
  return await <%= struct.name.lowerCamelName %>Api.search<%= struct.name.pascalName %>({
  <%_ struct.fields.forEach(function(field, index){ -%>
<%#_ 通常の検索 -%>
    <%_ if ((field.listType === 'string' || field.listType === 'time' || field.listType === 'bool' || field.listType === 'number' || field.listType === 'segment' || field.listType === 'relation')  && field.searchType === 1) { -%>
    <%= field.name.lowerCamelName %>: searchCondition.<%= field.name.lowerCamelName %> || undefined,
<%#_ 配列の検索 -%>
    <%_ } else if ((field.listType === 'array-string' || field.listType === 'array-time' || field.listType === 'array-bool' || field.listType === 'array-number')  && field.searchType === 1) { -%>
    <%= field.name.lowerCamelName %>: searchCondition.<%= field.name.lowerCamelName %> ? [searchCondition.<%= field.name.lowerCamelName %>] : undefined,
<%#_ 範囲検索 -%>
    <%_ } else if ((field.listType === 'time' || field.listType === 'number') && 2 <= field.searchType &&  field.searchType <= 5) { -%>
    <%= field.name.lowerCamelName %>: searchCondition.<%= field.name.lowerCamelName %> || undefined,
    <%= field.name.lowerCamelName %>From: searchCondition.<%= field.name.lowerCamelName %>From || undefined,
    <%= field.name.lowerCamelName %>To: searchCondition.<%= field.name.lowerCamelName %>To || undefined,
<%#_ 配列の範囲検索 -%>
    <%_ } else if ((field.listType === 'array-time' || field.listType === 'array-number') && 2 <= field.searchType &&  field.searchType <= 5) { -%>
    <%= field.name.lowerCamelName %>: searchCondition.<%= field.name.lowerCamelName %> ? [searchCondition.<%= field.name.lowerCamelName %>] : undefined,
    <%= field.name.lowerCamelName %>From: searchCondition.<%= field.name.lowerCamelName %>From || undefined,
    <%= field.name.lowerCamelName %>To: searchCondition.<%= field.name.lowerCamelName %>To || undefined,
    <%_ } -%>
  <%_ }) -%>
    limit: pageInfo.itemsPerPage !== -1 ? pageInfo.itemsPerPage : undefined,
<%_ if (project.dbType === 'datastore') { -%>
    cursor: pageInfo.page !== 1 ? pageInfo.cursors[pageInfo.page - 2] : undefined,
    orderBy: pageInfo.sortBy.map((sb: DataTableSortItem, i: number) => `${sb.key ? '-' : ''}${sb.order}`).join(',') || undefined
<%_ } else { -%>
    offset: (pageInfo.page - 1) * pageInfo.itemsPerPage,
    orderBy: pageInfo.sortBy.map((sb: DataTableSortItem, i: number) => `${sb.key ? '-' : ''}${sb.order}`).join(',') || undefined
<%_ } -%>
  }).then(res => res.data)
}

<%_ struct.fields.forEach(function(field, index){ -%>
  <%_ if (field.listType === 'relation') { -%>
const fetch<%= field.related.pascalPluralName %> = async () => {
  return await <%= field.related.lowerCamelName %>Api.search<%= field.related.pascalName %>({}).then((res: any) => res.data.<%= field.related.lowerCamelPluralName %>) || []
}
  <%_ } -%>
<%_ }) -%>

onMounted(async () => {
  const data = await fetch()
  const pi = cloneDeep(INITIAL_DATA_TABLE_PAGE_INFO)
<%_ if (project.dbType === 'datastore') { -%>
  if (data.cursor) {
    pi.cursors[0] = data.cursor
  }
<%_ } -%>
  <%= struct.name.lowerCamelPluralName %>.value = data.<%= struct.name.lowerCamelPluralName %> || []
  totalCount.value = data.count || 0
  pageInfo.value = pi || 0
<%_ struct.fields.forEach(function(field, index){ -%>
  <%_ if (field.listType === 'relation') { -%>
  <%= field.related.lowerCamelPluralName %>.value = await fetch<%= field.related.pascalPluralName %>()
  <%_ } -%>
<%_ }) -%>
})

const handleItemPerPage = (itemsPerPage: number) => {
  pageInfo.value.itemsPerPage = itemsPerPage
}

const handlePageInfo = (pi: DataTablePageInfo) => {
  pageInfo.value = pi
}

const reFetch = async (searchCondition: <%= struct.name.pascalName %>SearchCondition) => {
  loading.isLoading = true
  try {
    const data = await fetch({
      searchCondition: searchCondition,
      pageInfo: pageInfo.value
    })
<%_ if (project.dbType === 'datastore') { -%>
    if (data.cursor) {
      pageInfo.value.cursors[pageInfo.value.page - 1] = data.cursor
    }
<%_ } -%>
    <%= struct.name.lowerCamelPluralName %>.value = data.<%= struct.name.lowerCamelPluralName %> || []
    totalCount.value = data.count || 0
  } finally {
    loading.isLoading = false
  }
}

const navigateEntryForm = (target?: Model<%= struct.name.pascalName %>) => {
  navigateTo(`/<%= struct.name.lowerCamelName %>/${target?.id || 'new'}`)
}

const remove = async(id: number) => {
  const <%= struct.name.lowerCamelName %> = <%= struct.name.lowerCamelPluralName %>.value.find((c: Model<%= struct.name.pascalName %>) => c.id === id)
  if (!<%= struct.name.lowerCamelName %>) {
    return
  }
  dialog.showDialog({
    title: '削除確認',
    message: '削除してもよろしいですか？',
    negativeText: 'Cancel',
    positive: async () => {
      loading.showLoading()
      try {
        await <%= struct.name.lowerCamelName %>Api.delete<%= struct.name.pascalName %>({id: <%= struct.name.lowerCamelName %>.id!})
        await reFetch()
      } finally {
        loading.hideLoading()
      }
      snackbar.showSnackbar({text: '削除しました。'})
    }
  })
}
</script>

<template>
  <v-layout>
    <<%= struct.name.lowerCamelName %>-data-table
      :is-loading="isLoading"
      :items="<%= struct.name.lowerCamelPluralName %>"
<%_ struct.fields.forEach(function(field, index){ -%>
  <%_ if (field.listType === 'relation') { -%>
      :<%= field.related.lowerCamelPluralName %>="<%= field.related.lowerCamelPluralName %>"
  <%_ } -%>
<%_ }) -%>
      v-model:page-info="pageInfo"
      v-model:search-condition="searchCondition"
      :total-count="totalCount"
      class="elevation-1"
      @changed:pageInfo="reFetch"
      @update:pageInfo="handlePageInfo"
      @update:items-per-page="handleItemPerPage"
      @update:searchCondition="reFetch"
      @click:row="navigateEntryForm"
      @remove="remove"
      @create:<%= struct.name.lowerCamelName %>="navigateEntryForm"
    ></<%= struct.name.lowerCamelName %>-data-table>
  </v-layout>
</template>

<style scoped></style>
