---
to: "<%= struct.generateEnable ? `${rootDirectory}/pages/${struct.name.lowerCamelName}/index.vue` : null %>"
---
<script setup lang="ts">
<%_ const searchConditions = [] -%>
<%_ struct.fields.forEach(function(property, index){ -%>
  <%_ if ((property.listType === 'string' || property.listType === 'array-string' || property.listType === 'time' || property.listType === 'array-time') && property.searchType === 1) { -%>
    <%_ searchConditions.push({name: property.name.lowerCamelNam, type: 'string', range: false}) -%>
  <%_ } -%>
  <%_ if ((property.listType === 'bool' || property.listType === 'array-bool') && property.searchType === 1) { -%>
    <%_ searchConditions.push({name: property.name.lowerCamelNam, type: 'boolean', range: false}) -%>
  <%_ } -%>
  <%_ if ((property.listType === 'number' || property.listType === 'array-number') && property.searchType === 1) { -%>
    <%_ searchConditions.push({name: property.name.lowerCamelNam, type: 'number', range: false}) -%>
  <%_ } -%>
  <%_ if ((property.listType === 'number' || property.listType === 'array-number') && 2 <= property.searchType &&  property.searchType <= 5) { -%>
    <%_ searchConditions.push({name: property.name.lowerCamelNam, type: 'number', range: true}) -%>
  <%_ } -%>
  <%_ if ((property.listType === 'time' || property.listType === 'array-time') && 2 <= property.searchType &&  property.searchType <= 5) { -%>
    <%_ searchConditions.push({name: property.name.lowerCamelNam, type: 'string', range: true}) -%>
  <%_ } -%>
<%_ }) -%>
import {cloneDeep} from 'lodash-es'
import {Context} from '@nuxt/types'
import {<%= struct.name.pascalName %>Api, Model<%= struct.name.pascalName %>, Model<%= struct.name.pascalName %>} from '@/apis'
import {DataTablePageInfo, INITIAL_DATA_TABLE_PAGE_INFO} from '@/components/common/AppDataTable.vue'
import <%= struct.name.pascalName %>DataTable from '@/components/<%= struct.name.pascalName %>/<%= struct.name.pascalName %>DataTable.vue'
import {
  <%= struct.name.pascalName %>SearchCondition,
  INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION
} from '@/components/<%= struct.name.pascalName %>/<%= struct.name.pascalName %>SearchForm.vue'
import <%= struct.name.pascalName %>EntryForm, {INITIAL_<%= struct.name.upperSnakeName %>} from '@/components/<%= struct.name.pascalName %>/<%= struct.name.pascalName %>EntryForm.vue'

const loading = useLoading()
const snackbar = useSnackbar()

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

/** 入力フォームの表示表示状態 (true: 表示, false: 非表示) */
const isEntryFormOpen = ref<boolean>(false)

/** 編集対象 */
const editTarget = ref<Model<%= struct.name.pascalName %> | null>(null)

/** 編集対象のインデックス */
const editIndex = ref<number>(0)

const fetch = async (
  {searchCondition = INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION, pageInfo = INITIAL_DATA_TABLE_PAGE_INFO}
    : { searchCondition: <%= struct.name.pascalName %>SearchCondition, pageInfo: DataTablePageInfo }
    = {searchCondition: INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION, pageInfo: INITIAL_DATA_TABLE_PAGE_INFO}
): Promise<Model<%= struct.name.pascalPluralName %>> => {
  return await new <%= struct.name.pascalName %>Api().search<%= struct.name.pascalName %>({
  <%_ struct.fields.forEach(function(property, index){ -%>
<%#_ 通常の検索 -%>
    <%_ if ((property.listType === 'string' || property.listType === 'time' || property.listType === 'bool' || property.listType === 'number')  && property.searchType === 1) { -%>
    <%= property.name.lowerCamelName %>: searchCondition.<%= property.name.lowerCamelName %>.enabled ? searchCondition.<%= property.name.lowerCamelName %>.value : undefined,
<%#_ 配列の検索 -%>
    <%_ } else if ((property.listType === 'array-string' || property.listType === 'array-time' || property.listType === 'array-bool' || property.listType === 'array-number')  && property.searchType === 1) { -%>
    <%= property.name.lowerCamelName %>: searchCondition.<%= property.name.lowerCamelName %>.enabled ? [searchCondition.<%= property.name.lowerCamelName %>.value] : undefined,
<%#_ 範囲検索 -%>
    <%_ } else if ((property.listType === 'time' || property.listType === 'number') && 2 <= property.searchType &&  property.searchType <= 5) { -%>
    <%= property.name.lowerCamelName %>: searchCondition.<%= property.name.lowerCamelName %>.enabled ? searchCondition.<%= property.name.lowerCamelName %>.value : undefined,
    <%= property.name.lowerCamelName %>From: searchCondition.<%= property.name.lowerCamelName %>From.enabled ? searchCondition.<%= property.name.lowerCamelName %>From.value : undefined,
    <%= property.name.lowerCamelName %>To: searchCondition.<%= property.name.lowerCamelName %>To.enabled ? searchCondition.<%= property.name.lowerCamelName %>To.value : undefined,
<%#_ 配列の範囲検索 -%>
    <%_ } else if ((property.listType === 'array-time' || property.listType === 'array-number') && 2 <= property.searchType &&  property.searchType <= 5) { -%>
    <%= property.name.lowerCamelName %>: searchCondition.<%= property.name.lowerCamelName %>.enabled ? [searchCondition.<%= property.name.lowerCamelName %>.value] : undefined,
    <%= property.name.lowerCamelName %>From: searchCondition.<%= property.name.lowerCamelName %>From.enabled ? searchCondition.<%= property.name.lowerCamelName %>From.value : undefined,
    <%= property.name.lowerCamelName %>To: searchCondition.<%= property.name.lowerCamelName %>To.enabled ? searchCondition.<%= property.name.lowerCamelName %>To.value : undefined,
    <%_ } -%>
  <%_ }) -%>
    limit: pageInfo.itemsPerPage !== -1 ? pageInfo.itemsPerPage : undefined,
<%_ if (project.dbType === 'datastore') { -%>
    cursor: pageInfo.page !== 1 ? pageInfo.cursors[pageInfo.page - 2] : undefined,
    orderBy: pageInfo.sortBy.map((sb, i) => `${(pageInfo.sortDesc)[i] ? '-' : ''}${sb}`).join(',') || undefined
<%_ } else { -%>
    offset: (pageInfo.page - 1) * pageInfo.itemsPerPage,
    orderBy: pageInfo.sortBy.map((sb, i) => `${sb} ${(pageInfo.sortDesc)[i] ? 'desc' : 'asc'}`).join(',') || undefined
<%_ } -%>
  }).then(res => res.data)
}

onMounted(async () => {
  const data = await <%= struct.name.pascalPluralName %>.fetch()
  const pageInfo = cloneDeep(INITIAL_DATA_TABLE_PAGE_INFO)
<%_ if (project.dbType === 'datastore') { -%>
  if (data.cursor) {
    pageInfo.cursors[0] = data.cursor
  }
<%_ } -%>
  <%= struct.name.lowerCamelPluralName %>.value = data.<%= struct.name.lowerCamelPluralName %>
  totalCount.value = data.count
  pageInfo.value = pageInfo
})

const reFetch = async () => {
  loading.isLoading = true
  try {
    const data = await <%= struct.name.pascalPluralName %>.fetch({
      searchCondition: searchCondition.value,
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

const openEntryForm = (<%= struct.name.lowerCamelPluralName %>?: Model<%= struct.name.pascalName %>) => {
  if (!!<%= struct.name.lowerCamelPluralName %>) {
    editTarget.value = cloneDeep(<%= struct.name.lowerCamelPluralName %>)
    editIndex.value = <%= struct.name.lowerCamelPluralName %>.value.indexOf(<%= struct.name.lowerCamelPluralName %>)
  } else {
    editTarget.value = cloneDeep(INITIAL_<%= struct.name.upperSnakeName %>)
    editIndex.value = NEW_INDEX
  }
  isEntryFormOpen.value = true
}

const removeRow = (item: Model<%= struct.name.pascalName %>) => {
  const index = <%= struct.name.lowerCamelPluralName %>.value.indexOf(item)
  remove(index)
}

const removeForm = () => {
  remove(editIndex.value)
}

const remove = async(index: number) => {
  dialog.showDialog({
    title: '削除確認',
    message: '削除してもよろしいですか？',
    negativeText: 'Cancel',
    positive: async () => {
      loading.showLoading()
      try {
        await new <%= struct.name.pascalName %>Api().delete<%= struct.name.pascalName %>({id: <%= struct.name.lowerCamelPluralName %>.value[index].id!})
        isEntryFormOpen.value = false
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
      v-model:page-info="pageInfo"
      v-model:search-condition="searchCondition"
      :total-count="totalCount"
      class="elevation-1"
      @onChangePageInfo="reFetch"
      @onChangeSearch="reFetch"
      @openEntryForm="openEntryForm"
      @remove="removeRow"
    ></<%= struct.name.lowerCamelName %>-data-table>
    <v-dialog v-model="isEntryFormOpen" max-width="800px" persistent>
      <<%= struct.name.lowerCamelName %>-entry-form
        :dialog="true"
        :is-new="editIndex === NEW_INDEX"
        v-model:open="isEntryFormOpen"
        v-model:target="editTarget"
        @remove="removeForm"
        @updated="reFetch"
      ></<%= struct.name.lowerCamelName %>-entry-form>
    </v-dialog>
  </v-layout>
</template>

<style scoped></style>
