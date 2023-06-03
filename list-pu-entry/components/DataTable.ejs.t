---
to: <%= rootDirectory %>/<%= projectName %>/components/<%= entity.name %>/<%= h.changeCase.pascal(entity.name) %>DataTable.vue
---
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
          <v-toolbar-title><%= entity.listLabel %></v-toolbar-title>
<%_ if (entity.screenType !== 'struct') { -%>
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
<%_ if (entity.listProperties.listExtraProperties) { -%>
<%_ entity.listProperties.listExtraProperties.forEach(function(property, index){ -%>
<%_ if (property.type === 'time' || property.type === 'time-range') { -%>
      <template #item.<%= property.name %>="{ item }">
        <span>{{ formatDate(item.<%= property.name %>) }}</span>
      </template>
<%_ } -%>
<%_ if (property.type === 'bool') { -%>
      <template #item.<%= property.name %>="{ item }">
        <v-checkbox v-model="item.<%= property.name %>" :ripple="false" class="ma-0 pa-0" hide-details readonly></v-checkbox>
      </template>
<%_ } -%>
<%_ if (property.type === 'array-string' || property.type === 'array-number' || property.type === 'array-bool') { -%>
      <template #item.<%= property.name %>="{ item }">
        <span>{{ toStringArray(item.<%= property.name %>) }}</span>
      </template>
<%_ } -%>
<%_ if (property.type === 'array-time') { -%>
      <template #item.<%= property.name %>="{ item }">
        <span>{{ toStringTimeArray(item.<%= property.name %>) }}</span>
      </template>
<%_ } -%>
<%_ if (property.type === 'image' && property.dataType === 'string') { -%>
      <template #item.<%= property.name %>="{ item }">
        <v-img :src="item.<%= property.name %>" max-height="100px" max-width="100px"></v-img>
      </template>
<%_ } -%>
<%_ if (property.type === 'array-image') { -%>
      <template #item.<%= property.name %>="{ item }">
        <v-carousel
          v-if="item.<%= property.name %> && item.<%= property.name %>.length > 0"
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
          <v-carousel-item v-for="(image,i) in item.<%= property.name %>" :key="i">
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
<%_ if (entity.screenType !== 'struct') { -%>
    <<%= h.changeCase.param(entity.name) %>-search-form
      :current-search-condition="syncedSearchCondition"
      :open.sync="isSearchFormOpen"
      @search="search"
    ></<%= h.changeCase.param(entity.name) %>-search-form>
<%_ } -%>
  </v-flex>
</template>

<script lang="ts">
import {Component, Emit, mixins, Prop, PropSync} from 'nuxt-property-decorator'
import {cloneDeep} from 'lodash-es'
import Base from '@/mixins/base'
import {Model<%= entity.pascalName %>} from '@/apis'
import AppDataTable, {DataTablePageInfo, INITIAL_DATA_TABLE_PAGE_INFO} from '@/components/common/AppDataTable.vue'
<%_ if (entity.screenType !== 'struct') { -%>
import <%= h.changeCase.pascal(entity.name) %>SearchForm, {
  <%= h.changeCase.pascal(entity.name) %>SearchCondition,
  INITIAL_<%= h.changeCase.constant(entity.name) %>_SEARCH_CONDITION
} from '@/components/<%= entity.name %>/<%= h.changeCase.pascal(entity.name) %>SearchForm.vue'
<%_ } -%>

<%_ if (entity.screenType !== 'struct') { -%>
@Component({
  components: {
    AppDataTable,
    <%= h.changeCase.pascal(entity.name) %>SearchForm
  }
})
<%_ } else { -%>
@Component({
  components: {AppDataTable}
})
<%_ } -%>
export default class <%= h.changeCase.pascal(entity.name) %>DataTable extends mixins(Base) {
  /** ヘッダー定義 */
  headers = [
    <%_ if (entity.listProperties.listExtraProperties) { -%>
    <%_ entity.listProperties.listExtraProperties.forEach(function(property, index){ -%>
      <%_ if (property.type !== 'none' && property.dataType !== 'struct' && property.dataType !== 'array-struct') { -%>
    {
      text: '<%= property.screenLabel ? property.screenLabel : property.name === 'id' ? 'ID' : property.name %>',
      align: '<%= property.align %>',
      value: '<%= property.name %>'
    },
    <%_ } -%>
    <%_ }); -%>
    <%_ } -%>
    {
      text: '',
      align: 'center',
      value: 'action',
      sortable: false
    }
  ]

  /** 一覧表示用の配列 */
  @Prop({type: Array})
  items!: Model<%= entity.pascalName %>[]

  /** 一覧の表示ページ情報 */
  @PropSync('pageInfo', {type: Object, default: () => cloneDeep(INITIAL_DATA_TABLE_PAGE_INFO)})
  syncedPageInfo!: DataTablePageInfo

  /** 一覧の合計件数 */
  @Prop({type: Number, default: undefined})
  totalCount!: number | undefined

  /** 一覧の読み込み状態 */
  @Prop({type: Boolean, default: false})
  isLoading!: boolean
<%_ if (entity.screenType !== 'struct') { -%>

  /** 検索フォームの表示表示状態 (true: 表示, false: 非表示) */
  isSearchFormOpen: boolean = false

  /** 検索条件 */
  @PropSync('searchCondition', {type: Object, default: () => cloneDeep(INITIAL_<%= h.changeCase.constant(entity.name) %>_SEARCH_CONDITION)})
  syncedSearchCondition!: <%= h.changeCase.pascal(entity.name) %>SearchCondition

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
<%_ if (entity.screenType !== 'struct') { -%>

  @Emit('onChangeSearch')
  onChangeSearch() {
  }

  search(searchCondition: <%= h.changeCase.pascal(entity.name) %>SearchCondition) {
    this.syncedSearchCondition = searchCondition
    this.onChangeSearch()
  }
<%_ } -%>

  @Emit('openEntryForm')
  openEntryForm(item?: Model<%= entity.pascalName %>) {
    return item
  }

  @Emit('remove')
  remove(item: Model<%= entity.pascalName %>) {
    return item
  }
}
</script>

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
