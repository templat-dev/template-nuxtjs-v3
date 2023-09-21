---
to: <%= rootDirectory %>/components/<%= struct.name.lowerCamelName %>/<%= struct.name.pascalName %>DataTable.vue
---
<script setup lang="ts">
import {cloneDeep} from 'lodash-es'
import {Model<%= struct.name.pascalName %>} from '@/apis'
import {DataTablePageInfo, INITIAL_DATA_TABLE_PAGE_INFO} from '@/types/DataTableType'
<%_ if (struct.screenType !== 'struct') { -%>
import {
  <%= struct.name.pascalName %>SearchCondition,
  INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION
} from '@/types/<%= struct.name.pascalName %>Type'
<%_ } -%>
<%_ if (struct.exists.list.segment) { -%>
<%_ struct.fields.forEach(function (field, key) { -%>
<%_ if (field.editType === 'segment') { -%>
import {<%= field.name.upperSnakeName %>_LIST} from "~/constants/segmentConstants"
<%_ } -%>
<%_ }) -%>
<%_ } -%>
<%_ if (struct.exists.list.time) { -%>
import AppUtils from '@/utils/appUtils'
<%_ } -%>

/** ヘッダー定義 */
const headers = ref<any[]>([
  <%_ if (struct.fields) { -%>
  <%_ struct.fields.forEach(function(field, index){ -%>
    <%_ if (field.listType !== 'none' && field.dataType !== 'struct' && field.dataType !== 'array-struct') { -%>
  {
    title: '<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName === 'id' ? 'ID' : field.name.lowerCamelName %>',
    align: '<%= field.align %>',
    key: '<%= field.name.lowerCamelName %>'
  },
    <%_ } -%>
  <%_ }) -%>
  <%_ } -%>
  {
    text: '',
    align: 'center',
    key: 'action',
    sortable: false
  }
])

interface Props {
  /** 一覧表示用の配列 */
  items: Model<%= struct.name.pascalName %>[]
  /** 一覧の表示ページ情報 */
  pageInfo: DataTablePageInfo
  /** 一覧の合計件数 */
  totalCount: number | undefined
  /** 一覧の読み込み状態 */
  isLoading: boolean
<%_ if (struct.structType !== 'struct') { -%>
  /** 検索条件 */
  searchCondition: <%= struct.name.pascalName %>SearchCondition
  /** 表示方式 (true: 子要素として表示, false: 親要素として表示) */
  hasParent?: boolean
<%_ } -%>
}
const props = withDefaults(defineProps<Props>(), {
  items: (props: Props) => [],
  pageInfo: (props: Props) => cloneDeep(INITIAL_DATA_TABLE_PAGE_INFO),
  totalCount: undefined,
  isLoading: false,
<%_ if (struct.structType !== 'struct') { -%>
  searchCondition: (props: Props) => cloneDeep(INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION),
  hasParent: false,
<%_ } -%>
})

interface Emits {
  (e: "changed:pageInfo"): void;
  (e: "update:pageInfo", pageInfo: DataTablePageInfo): void;
  (e: "update:itemsPerPage", itemsPerPage: number): void;
<%_ if (struct.structType !== 'struct') { -%>
  (e: "update:searchCondition", searchCondition: <%= struct.name.pascalName %>SearchCondition): void;
<%_ } -%>
  (e: "click:row", item?: Model<%= struct.name.pascalName %>): void;
  (e: "remove", id: number): void;
  (e: "create:<%= struct.name.lowerCamelName %>"): void;
}
const emit = defineEmits<Emits>()

const currentPageInfo = computed({
  get: () => props.pageInfo,
  set: (v) => emit('update:pageInfo', v)
})

<%_ if (struct.structType !== 'struct') { -%>

/** 検索フォームの表示表示状態 (true: 表示, false: 非表示) */
const isSearchFormOpen = ref<boolean>(false)

const previewSearchCondition = computed(() => {
  const previewSearchConditions = []
  for (const [key, value] of Object.entries(props.searchCondition)) {
    if (!value) {
      continue
    }
    previewSearchConditions.push(`${key}=${value}`)
  }
  return previewSearchConditions.join(', ')
})
<%_ } -%>

const onChangePageInfo = () => {
  emit('changed:pageInfo')
}

const handleItemPerPage = (itemsPerPage: number) => {
  emit('update:itemsPerPage', itemsPerPage)
}

<%_ if (struct.structType !== 'struct') { -%>

const search = (searchCondition: <%= struct.name.pascalName %>SearchCondition) => {
  emit('update:searchCondition', searchCondition)
}
<%_ } -%>

const clickRow = (item?: Model<%= struct.name.pascalName %>) => {
  emit('click:row', item)
}

const create<%= struct.name.pascalName %> = () => {
  emit('create:<%= struct.name.lowerCamelName %>')
}

const remove = (item: Model<%= struct.name.pascalName %>) => {
  emit('remove', item.id!)
}
<%_ if (struct.fields) { -%>
<%_ struct.fields.forEach(function(field, index){ -%>
<%_ if (field.listType === 'segment') { -%>
const <%= field.name.lowerCamelName %>Name = (<%= field.name.lowerCamelName %>: number) => {
  const segment = <%= field.name.upperSnakeName %>_LIST.find(
          (item) => item.value === <%= field.name.lowerCamelName %>
  )
  if (segment) {
    return segment.name
  } else {
    return ''
  }
}
<%_ } -%>
<%_ }) -%>
<%_ } -%>
</script>

<template>
  <div>
    <common-app-data-table
      :headers="headers"
      :is-loading="isLoading"
      :items="items || []"
      :items-per-page="pageInfo.itemsPerPage"
      v-model:page-info="currentPageInfo"
      :total-count="totalCount"
      loading-text="読み込み中"
      no-data-text="該当データ無し"
      @re-fetch="onChangePageInfo"
      @update:items-per-page="handleItemPerPage"
      @click:row="clickRow"
    >
      <!-- ヘッダー -->
      <template #top>
        <v-toolbar color="white" flat>
          <v-toolbar-title><%= struct.listLabel %></v-toolbar-title>
<%_ if (struct.structType !== 'struct') { -%>
          <template v-if="!hasParent">
            <v-divider class="mx-4" inset vertical></v-divider>
            <v-btn icon @click="isSearchFormOpen = true">
              <v-icon>mdi-magnify</v-icon>
            </v-btn>
            <span>{{ previewSearchCondition }}</span>
          </template>
<%_ } -%>
          <v-spacer></v-spacer>
          <v-btn
            density="compact"
            icon="mdi-plus"
            color="primary"
            size="x-large"
            flat
            @click="create<%= struct.name.pascalName %>()"
          >
          </v-btn>
        </v-toolbar>
      </template>
<%_ if (struct.fields) { -%>
<%_ struct.fields.forEach(function(field, index){ -%>
<%_ if (field.listType === 'segment') { -%>
  <template #item.<%= field.name.lowerCamelName %>="{ item }">
    <span>{{ companyTypeName(item.raw.<%= field.name.lowerCamelName %>) }}</span>
  </template>
<%_ } -%>
<%_ if (field.listType === 'time' || field.listType === 'time-range') { -%>
      <template #item.<%= field.name.lowerCamelName %>="{ item }">
        <span>{{ AppUtils.formatDate(item.raw.<%= field.name.lowerCamelName %>) }}</span>
      </template>
<%_ } -%>
<%_ if (field.listType === 'bool') { -%>
      <template #item.<%= field.name.lowerCamelName %>="{ item }">
        <v-checkbox v-model="item.raw.<%= field.name.lowerCamelName %>" :ripple="false" class="ma-0 pa-0" hide-details readonly></v-checkbox>
      </template>
<%_ } -%>
<%_ if (field.listType === 'array-string' || field.listType === 'array-number' || field.listType === 'array-bool') { -%>
      <template #item.<%= field.name.lowerCamelName %>="{ item }">
        <span>{{ toStringArray(item.raw.<%= field.name.lowerCamelName %>) }}</span>
      </template>
<%_ } -%>
<%_ if (field.listType === 'array-time') { -%>
      <template #item.<%= field.name.lowerCamelName %>="{ item }">
        <span>{{ toStringTimeArray(item.raw.<%= field.name.lowerCamelName %>) }}</span>
      </template>
<%_ } -%>
<%_ if (field.listType === 'image' && field.dataType === 'string') { -%>
      <template #item.<%= field.name.lowerCamelName %>="{ item }">
        <v-img :src="item.raw.<%= field.name.lowerCamelName %>" max-height="100px" max-width="100px"></v-img>
      </template>
<%_ } -%>
<%_ if (field.listType === 'array-image') { -%>
      <template #item.<%= field.name.lowerCamelName %>="{ item }">
        <v-carousel
          v-if="item.raw.<%= field.name.lowerCamelName %> && item.raw.<%= field.name.lowerCamelName %>.length > 0"
          class="carousel" height="100px" hide-delimiters>
          <template #prev="{ on, attrs }">
            <v-btn v-bind="attrs" v-on="on" icon x-small>
              <v-icon>mdi-chevron-left</v-icon>
            </v-btn>
          </template>
          <template #next="{ on, attrs }">
            <v-btn v-bind="attrs" v-on="on" icon x-small>
              <v-icon>mdi-chevron-right</v-icon>
            </v-btn>
          </template>
          <v-carousel-item v-for="(image,i) in item.raw.<%= field.name.lowerCamelName %>" :key="i">
            <v-layout justify-center>
              <v-img :src="image" contain max-height="100px" max-width="100px"/>
            </v-layout>
          </v-carousel-item>
        </v-carousel>
      </template>
<%_ } -%>
<%_ }) -%>
<%_ } -%>
      <!-- 行操作列 -->
      <template #item.action="{ item }">
        <v-btn icon="mdi-delete" flat @click.stop="remove(item.raw)"/>
      </template>
    </common-app-data-table>
<%_ if (struct.structType !== 'struct') { -%>
    <<%= struct.name.lowerCamelName %>-search-form
      :current-search-condition="searchCondition"
      :open="isSearchFormOpen"
      @search="search"
      @update:open="isSearchFormOpen = $event"
    ></<%= struct.name.lowerCamelName %>-search-form>
<%_ } -%>
  </div>
</template>

<style scoped>
.action-button {
  pointer-events: auto;
}

.carousel >>> .v-responsive__content {
  display: flex;
}

.carousel >>> .v-window__prev, .carousel >>> .v-window__next {
  margin: 0;
  top: calc(50% - 10px);
}
</style>
