---
to: <%= rootDirectory %>/components/<%= struct.name.lowerCamelName %>/<%= struct.name.pascalName %>DataTable.vue
---
<script setup lang="ts">
import {cloneDeep} from 'lodash-es'
import {Model<%= struct.name.pascalName %>} from '@/apis'
import AppDataTable, {DataTablePageInfo, INITIAL_DATA_TABLE_PAGE_INFO} from '@/components/common/AppDataTable.vue'
<%_ if (struct.structType !== 'struct') { -%>
import <%= struct.name.pascalName %>SearchForm, {
  <%= struct.name.pascalName %>SearchCondition,
  INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION
} from '@/components/<%= struct.name.lowerCamelName %>/<%= struct.name.pascalName %>SearchForm.vue'
<%_ } -%>

  /** ヘッダー定義 */
const headers = [
<%_ struct.fields.forEach(function (field, key) { -%>
  <%_ if (field.listType !== 'none' && field.dataType !== 'struct' && field.dataType !== 'array-struct') { -%>
  {
    text: '<%= field.screenLabel ? field.screenLabel : field.name === 'id' ? 'ID' : field.name %>',
    align: '<%= field.align %>',
    value: '<%= field.name %>'
  },
  <%_ } -%>
<%_ }); -%>
  {
    text: '',
    align: 'center',
    value: 'action',
    sortable: false
  }
]

interface Props {
  /** 一覧表示用の配列 */
  items: Model<%= struct.name.pascalName %>[]
  /** 一覧の表示ページ情報 */
  pageInfo: DataTablePageInfo
  /** 一覧の合計件数 */
  totalCount: number | undefined
  /** 一覧の読み込み状態 */
  isLoading: boolean
}
const props = withDefaults(defineProps<Props>(), {
  items: (props: Props) => [],,
  pageInfo: cloneDeep(INITIAL_DATA_TABLE_PAGE_INFO),
  totalCount: undefined,
  isLoading: false,
})

<%_ if (struct.structType !== 'struct') { -%>

/** 検索フォームの表示表示状態 (true: 表示, false: 非表示) */
const isSearchFormOpen = ref<boolean>(false)

  /** 検索条件 */
  @PropSync('searchCondition', {type: Object, default: () => cloneDeep(INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION)})
  syncedSearchCondition!: <%= struct.name.pascalName %>SearchCondition

  /** 表示方式 (true: 子要素として表示, false: 親要素として表示) */
  @Prop({type: Boolean, default: false})
  hasParent!: boolean

  get previewSearchCondition() {
    const previewSearchConditions = []
    for (const [key, value] of Object.entries(this.syncedSearchCondition)) {
      if (!value.enabled) {
        continue
      }
      previewSearchConditions.push(`${key}=${value.value}`)
    }
    return previewSearchConditions.join(', ')
  }
<%_ } -%>

  @Emit('onChangePageInfo')
  onChangePageInfo() {
  }
<%_ if (struct.structType !== 'struct') { -%>

  @Emit('onChangeSearch')
  onChangeSearch() {
  }

  search(searchCondition: <%= struct.name.pascalName %>SearchCondition) {
    this.syncedSearchCondition = searchCondition
    this.onChangeSearch()
  }
<%_ } -%>

  @Emit('openEntryForm')
  openEntryForm(item?: Model<%= struct.name.pascalName %>) {
    return item
  }

  @Emit('remove')
  remove(item: Model<%= struct.name.pascalName %>) {
    return item
  }
}
</script>

<template>
  <v-flex>
    <app-data-table
      :headers="headers"
      :is-loading="isLoading"
      :items="items || []"
      :items-per-page="syncedPageInfo.itemsPerPage"
      :page-info.sync="syncedPageInfo"
      :total-count="totalCount"
      loading-text="読み込み中"
      no-data-text="該当データ無し"
      @onChangePageInfo="onChangePageInfo"
      @openEntryForm="openEntryForm">
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
          <v-btn class="action-button" color="primary" dark fab right small top @click="openEntryForm()">
            <v-icon>mdi-plus</v-icon>
          </v-btn>
        </v-toolbar>
      </template>
<%_ if (struct.fields && struct.fields.length > 0) { -%>
<%_ struct.fields.forEach(function (field, key) { -%>
<%_ if (field.listType === 'time' || field.listType === 'time-range') { -%>
      <template #item.<%= field.name %>="{ item }">
        <span>{{ formatDate(item.<%= field.name %>) }}</span>
      </template>
<%_ } -%>
<%_ if (field.listType === 'bool') { -%>
      <template #item.<%= field.name %>="{ item }">
        <v-checkbox v-model="item.<%= field.name %>" :ripple="false" class="ma-0 pa-0" hide-details readonly></v-checkbox>
      </template>
<%_ } -%>
<%_ if (field.listType === 'array-string' || field.listType === 'array-number' || field.listType === 'array-bool') { -%>
      <template #item.<%= field.name %>="{ item }">
        <span>{{ toStringArray(item.<%= field.name %>) }}</span>
      </template>
<%_ } -%>
<%_ if (field.listType === 'array-time') { -%>
      <template #item.<%= field.name %>="{ item }">
        <span>{{ toStringTimeArray(item.<%= field.name %>) }}</span>
      </template>
<%_ } -%>
<%_ if (field.listType === 'image' && field.dataType === 'string') { -%>
      <template #item.<%= field.name %>="{ item }">
        <v-img :src="item.<%= field.name %>" max-height="100px" max-width="100px"></v-img>
      </template>
<%_ } -%>
<%_ if (field.listType === 'array-image') { -%>
      <template #item.<%= field.name %>="{ item }">
        <v-carousel
          v-if="item.<%= field.name %> && item.<%= field.name %>.length > 0"
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
          <v-carousel-item v-for="(image,i) in item.<%= field.name %>" :key="i">
            <v-layout justify-center>
              <v-img :src="image" contain max-height="100px" max-width="100px"/>
            </v-layout>
          </v-carousel-item>
        </v-carousel>
      </template>
<%_ } -%>
<%_ }); -%>
<%_ } -%>
      <!-- 行操作列 -->
      <template #item.action="{ item }">
        <v-btn icon @click.stop="remove(item)">
          <v-icon>mdi-delete</v-icon>
        </v-btn>
      </template>
    </app-data-table>
<%_ if (struct.structType !== 'struct') { -%>
    <<%= struct.name.lowerCamelName %>-search-form
      :current-search-condition="syncedSearchCondition"
      :open.sync="isSearchFormOpen"
      @search="search"
    ></<%= struct.name.lowerCamelName %>-search-form>
<%_ } -%>
  </v-flex>
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
