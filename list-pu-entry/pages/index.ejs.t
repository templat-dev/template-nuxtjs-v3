---
to: "<%= entity.enable ? `${rootDirectory}/${projectName}/pages/${entity.name}/index.vue` : null %>"
---
<template>
  <v-layout>
    <<%= h.changeCase.param(entity.name) %>-data-table
      :is-loading="isLoading"
      :items="<%= entity.pluralName %>"
      :page-info.sync="pageInfo"
      :search-condition.sync="searchCondition"
      :total-count="totalCount"
      class="elevation-1"
      @onChangePageInfo="reFetch"
      @onChangeSearch="reFetch"
      @openEntryForm="openEntryForm"
      @remove="removeRow"
    ></<%= h.changeCase.param(entity.name) %>-data-table>
    <v-dialog v-model="isEntryFormOpen" max-width="800px" persistent>
      <<%= h.changeCase.param(entity.name) %>-entry-form
        :dialog="true"
        :is-new="editIndex === NEW_INDEX"
        :open.sync="isEntryFormOpen"
        :target.sync="editTarget"
        @remove="removeForm"
        @updated="reFetch"
      ></<%= h.changeCase.param(entity.name) %>-entry-form>
    </v-dialog>
  </v-layout>
</template>

<script lang="ts">
<%_ const searchConditions = [] -%>
<%_ if (entity.listProperties.listExtraProperties && entity.listProperties.listExtraProperties.length > 0) { -%>
<%_ entity.listProperties.listExtraProperties.forEach(function (property, key) { -%>
  <%_ if ((property.type === 'string' || property.type === 'array-string' || property.type === 'time' || property.type === 'array-time') && property.searchType === 1) { -%>
    <%_ searchConditions.push({name: property.name, type: 'string', range: false}) -%>
  <%_ } -%>
  <%_ if ((property.type === 'bool' || property.type === 'array-bool') && property.searchType === 1) { -%>
    <%_ searchConditions.push({name: property.name, type: 'boolean', range: false}) -%>
  <%_ } -%>
  <%_ if ((property.type === 'number' || property.type === 'array-number') && property.searchType === 1) { -%>
    <%_ searchConditions.push({name: property.name, type: 'number', range: false}) -%>
  <%_ } -%>
  <%_ if ((property.type === 'number' || property.type === 'array-number') && 2 <= property.searchType &&  property.searchType <= 5) { -%>
    <%_ searchConditions.push({name: property.name, type: 'number', range: true}) -%>
  <%_ } -%>
  <%_ if ((property.type === 'time' || property.type === 'array-time') && 2 <= property.searchType &&  property.searchType <= 5) { -%>
    <%_ searchConditions.push({name: property.name, type: 'string', range: true}) -%>
  <%_ } -%>
<%_ }) -%>
<%_ } -%>
import {Component, mixins} from 'nuxt-property-decorator'
import {cloneDeep} from 'lodash-es'
import {Context} from '@nuxt/types'
import {vxm} from '@/store'
import Base from '@/mixins/base'
import {<%= h.changeCase.upperCaseFirst(entity.name) %>Api, Model<%= h.changeCase.pascal(entity.pluralName) %>, Model<%= entity.pascalName %>} from '@/apis'
import {DataTablePageInfo, INITIAL_DATA_TABLE_PAGE_INFO} from '@/components/common/AppDataTable.vue'
import <%= h.changeCase.pascal(entity.name) %>DataTable from '@/components/<%= entity.name %>/<%= h.changeCase.pascal(entity.name) %>DataTable.vue'
import {
  <%= h.changeCase.pascal(entity.name) %>SearchCondition,
  INITIAL_<%= h.changeCase.constant(entity.name) %>_SEARCH_CONDITION
} from '@/components/<%= entity.name %>/<%= h.changeCase.pascal(entity.name) %>SearchForm.vue'
import <%= h.changeCase.pascal(entity.name) %>EntryForm, {INITIAL_<%= h.changeCase.constant(entity.name) %>} from '@/components/<%= entity.name %>/<%= h.changeCase.pascal(entity.name) %>EntryForm.vue'

@Component({
  components: {
    <%= h.changeCase.pascal(entity.name) %>DataTable,
    <%= h.changeCase.pascal(entity.name) %>EntryForm
  },
<%_ if (entity.plugins.includes('auth')) { -%>
  middleware: 'auth'
<%_ } -%>
})
export default class <%= h.changeCase.pascal(entity.pluralName) %> extends mixins(Base) {
  /** 一覧表示用の配列 */
  <%= entity.pluralName %>: Model<%= entity.pascalName %>[] = []

  /** 一覧の表示ページ情報 */
  pageInfo = cloneDeep(INITIAL_DATA_TABLE_PAGE_INFO)

  /** 一覧の合計件数 */
  totalCount: number = 0

  /** 一覧の読み込み状態 */
  isLoading: boolean = false

  /** 検索条件 */
  searchCondition: <%= h.changeCase.pascal(entity.name) %>SearchCondition = cloneDeep(INITIAL_<%= h.changeCase.constant(entity.name) %>_SEARCH_CONDITION)

  /** 入力フォームの表示表示状態 (true: 表示, false: 非表示) */
  isEntryFormOpen: boolean = false

  /** 編集対象 */
  editTarget: Model<%= entity.pascalName %> | null = null

  /** 編集対象のインデックス */
  editIndex: number = 0

  static async fetch(
    {searchCondition = INITIAL_<%= h.changeCase.constant(entity.name) %>_SEARCH_CONDITION, pageInfo = INITIAL_DATA_TABLE_PAGE_INFO}
      : { searchCondition: <%= h.changeCase.pascal(entity.name) %>SearchCondition, pageInfo: DataTablePageInfo }
      = {searchCondition: INITIAL_<%= h.changeCase.constant(entity.name) %>_SEARCH_CONDITION, pageInfo: INITIAL_DATA_TABLE_PAGE_INFO}
  ): Promise<Model<%= h.changeCase.upperCaseFirst(entity.pluralName) %>> {
    return await new <%= h.changeCase.upperCaseFirst(entity.name) %>Api().search<%= entity.pascalName %>({
    <%_ entity.listProperties.listExtraProperties.forEach(function(property, index){ -%>
<%#_ 通常の検索 -%>
      <%_ if ((property.type === 'string' || property.type === 'time' || property.type === 'bool' || property.type === 'number')  && property.searchType === 1) { -%>
      <%= property.name %>: searchCondition.<%= property.name %>.enabled ? searchCondition.<%= property.name %>.value : undefined,
<%#_ 配列の検索 -%>
      <%_ } else if ((property.type === 'array-string' || property.type === 'array-time' || property.type === 'array-bool' || property.type === 'array-number')  && property.searchType === 1) { -%>
      <%= property.name %>: searchCondition.<%= property.name %>.enabled ? [searchCondition.<%= property.name %>.value] : undefined,
<%#_ 範囲検索 -%>
      <%_ } else if ((property.type === 'time' || property.type === 'number') && 2 <= property.searchType &&  property.searchType <= 5) { -%>
      <%= property.name %>: searchCondition.<%= property.name %>.enabled ? searchCondition.<%= property.name %>.value : undefined,
      <%= property.name %>From: searchCondition.<%= property.name %>From.enabled ? searchCondition.<%= property.name %>From.value : undefined,
      <%= property.name %>To: searchCondition.<%= property.name %>To.enabled ? searchCondition.<%= property.name %>To.value : undefined,
<%#_ 配列の範囲検索 -%>
      <%_ } else if ((property.type === 'array-time' || property.type === 'array-number') && 2 <= property.searchType &&  property.searchType <= 5) { -%>
      <%= property.name %>: searchCondition.<%= property.name %>.enabled ? [searchCondition.<%= property.name %>.value] : undefined,
      <%= property.name %>From: searchCondition.<%= property.name %>From.enabled ? searchCondition.<%= property.name %>From.value : undefined,
      <%= property.name %>To: searchCondition.<%= property.name %>To.enabled ? searchCondition.<%= property.name %>To.value : undefined,
      <%_ } -%>
    <%_ }) -%>
      limit: pageInfo.itemsPerPage !== -1 ? pageInfo.itemsPerPage : undefined,
<%_ if (entity.dbType === 'datastore') { -%>
      cursor: pageInfo.page !== 1 ? pageInfo.cursors[pageInfo.page - 2] : undefined,
      orderBy: pageInfo.sortBy.map((sb, i) => `${(pageInfo.sortDesc)[i] ? '-' : ''}${sb}`).join(',') || undefined
<%_ } else { -%>
      offset: (pageInfo.page - 1) * pageInfo.itemsPerPage,
      orderBy: pageInfo.sortBy.map((sb, i) => `${sb} ${(pageInfo.sortDesc)[i] ? 'desc' : 'asc'}`).join(',') || undefined
<%_ } -%>
    }).then(res => res.data)
  }

  async asyncData({}: Context) {
    const data = await <%= h.changeCase.pascal(entity.pluralName) %>.fetch()
    const pageInfo = cloneDeep(INITIAL_DATA_TABLE_PAGE_INFO)
<%_ if (entity.dbType === 'datastore') { -%>
    if (data.cursor) {
      pageInfo.cursors[0] = data.cursor
    }
<%_ } -%>
    return {
      <%= entity.pluralName %>: data.<%= entity.pluralName %>,
      totalCount: data.count,
      pageInfo
    }
  }

  async reFetch() {
    this.isLoading = true
    try {
      const data = await <%= h.changeCase.pascal(entity.pluralName) %>.fetch({
        searchCondition: this.searchCondition,
        pageInfo: this.pageInfo
      })
<%_ if (entity.dbType === 'datastore') { -%>
      if (data.cursor) {
        this.pageInfo.cursors[this.pageInfo.page - 1] = data.cursor
      }
<%_ } -%>
      this.<%= entity.pluralName %> = data.<%= entity.pluralName %> || []
      this.totalCount = data.count || 0
    } finally {
      this.isLoading = false
    }
  }

  openEntryForm(<%= entity.name %>?: Model<%= entity.pascalName %>) {
    if (!!<%= entity.name %>) {
      this.editTarget = cloneDeep(<%= entity.name %>)
      this.editIndex = this.<%= entity.pluralName %>.indexOf(<%= entity.name %>)
    } else {
      this.editTarget = cloneDeep(INITIAL_<%= h.changeCase.constant(entity.name) %>)
      this.editIndex = this.NEW_INDEX
    }
    this.isEntryFormOpen = true
  }

  removeRow(item: Model<%= entity.pascalName %>) {
    const index = this.<%= entity.pluralName %>.indexOf(item)
    this.remove(index)
  }

  removeForm() {
    this.remove(this.editIndex)
  }

  async remove(index: number) {
    vxm.app.showDialog({
      title: '削除確認',
      message: '削除してもよろしいですか？',
      negativeText: 'Cancel',
      positive: async () => {
        vxm.app.showLoading()
        try {
          await new <%= h.changeCase.upperCaseFirst(entity.name) %>Api().delete<%= entity.pascalName %>({id: this.<%= entity.pluralName %>[index].id!})
          this.isEntryFormOpen = false
          await this.reFetch()
        } finally {
          vxm.app.hideLoading()
        }
        vxm.app.showSnackbar({text: '削除しました。'})
      }
    })
  }
}
</script>

<style scoped></style>
