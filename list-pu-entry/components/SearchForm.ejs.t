---
to: <%= rootDirectory %>/<%= projectName %>/components/<%= entity.name %>/<%= h.changeCase.pascal(entity.name) %>SearchForm.vue
---
<template>
  <v-dialog v-model="syncedOpen" max-width="800px">
    <v-card :elevation="0">
      <v-card-title><%= h.changeCase.pascal(entity.name) %>検索</v-card-title>
      <v-card-text>
      <%_ if (entity.listProperties.listExtraProperties) { -%>
      <%_ entity.listProperties.listExtraProperties.forEach(function (property, key) { -%>
        <%_ if ((property.type === 'string' || property.type === 'array-string' || property.type === 'textarea' || property.type === 'array-textarea') && property.searchType === 1) { -%>
        <v-layout>
          <v-flex sm1 xs2>
            <v-switch v-model="searchCondition.<%= property.name %>.enabled"/>
          </v-flex>
          <v-flex sm11 xs10>
            <v-text-field
              v-model="searchCondition.<%= property.name %>.value"
              :disabled="!searchCondition.<%= property.name %>.enabled"
              label="<%= property.screenLabel ? property.screenLabel : property.name %>"
            ></v-text-field>
          </v-flex>
        </v-layout>
        <%_ } -%>
        <%_ if ((property.type === 'number' || property.type === 'array-number') && property.searchType !== 0) { -%>
        <v-layout>
          <v-flex sm1 xs2>
            <v-switch v-model="searchCondition.<%= property.name %>.enabled"/>
          </v-flex>
          <v-flex sm11 xs10>
            <v-text-field
              :disabled="!searchCondition.<%= property.name %>.enabled"
              :value="searchCondition.<%= property.name %>.value"
              label="<%= property.screenLabel ? property.screenLabel : property.name %>"
              type="number"
              @input="v => searchCondition.<%= property.name %>.value = v === '' ? undefined : Number(v)"
            ></v-text-field>
          </v-flex>
        </v-layout>
        <%_ } -%>
        <%_ if ((property.type === 'number' || property.type === 'array-number') && 2 <= property.searchType && property.searchType <= 5) { -%>
        <v-layout>
          <v-flex sm1 xs2>
            <v-switch v-model="searchCondition.<%= property.name %>From.enabled"/>
          </v-flex>
          <v-flex sm11 xs10>
            <v-text-field
              :disabled="!searchCondition.<%= property.name %>From.enabled"
              :value="searchCondition.<%= property.name %>From.value"
              label="<%= property.screenLabel ? property.screenLabel : property.name %>開始"
              type="number"
              @input="v => searchCondition.<%= property.name %>From.value = v === '' ? undefined : Number(v)"
            ></v-text-field>
          </v-flex>
        </v-layout>
        <v-layout>
          <v-flex sm1 xs2>
            <v-switch v-model="searchCondition.<%= property.name %>To.enabled"/>
          </v-flex>
          <v-flex sm11 xs10>
            <v-text-field
              :disabled="!searchCondition.<%= property.name %>To.enabled"
              :value="searchCondition.<%= property.name %>To.value"
              label="<%= property.screenLabel ? property.screenLabel : property.name %>終了"
              type="number"
              @input="v => searchCondition.<%= property.name %>To.value = v === '' ? undefined : Number(v)"
            ></v-text-field>
          </v-flex>
        </v-layout>
        <%_ } -%>
        <%_ if ((property.type === 'time' || property.type === 'array-time') && property.searchType !== 0) { -%>
        <v-layout>
          <v-flex sm1 xs2>
            <v-switch v-model="searchCondition.<%= property.name %>.enabled"/>
          </v-flex>
          <v-flex sm11 xs10>
            <date-time-form
              :date-time.sync="searchCondition.<%= property.name %>.value"
              :disabled="!searchCondition.<%= property.name %>.enabled"
              label="<%= property.screenLabel ? property.screenLabel : property.name %>"
            ></date-time-form>
          </v-flex>
        </v-layout>
        <%_ } -%>
        <%_ if ((property.type === 'time' || property.type === 'array-time') && 2 <= property.searchType &&  property.searchType <= 5) { -%>
        <v-layout>
          <v-flex sm1 xs2>
            <v-switch v-model="searchCondition.<%= property.name %>From.enabled"/>
          </v-flex>
          <v-flex sm11 xs10>
            <date-time-form
              :date-time.sync="searchCondition.<%= property.name %>From.value"
              :disabled="!searchCondition.<%= property.name %>From.enabled"
              label="<%= property.screenLabel ? property.screenLabel : property.name %>開始"
            ></date-time-form>
          </v-flex>
        </v-layout>
        <v-layout>
          <v-flex sm1 xs2>
            <v-switch v-model="searchCondition.<%= property.name %>To.enabled"/>
          </v-flex>
          <v-flex sm11 xs10>
            <date-time-form
              :date-time.sync="searchCondition.<%= property.name %>To.value"
              :disabled="!searchCondition.<%= property.name %>To.enabled"
              label="<%= property.screenLabel ? property.screenLabel : property.name %>終了"
            ></date-time-form>
          </v-flex>
        </v-layout>
        <%_ } -%>
        <%_ if ((property.type === 'bool' || property.type === 'array-bool') && property.searchType === 1) { -%>
        <v-layout>
          <v-flex sm1 xs2>
            <v-switch v-model="searchCondition.<%= property.name %>.enabled"/>
          </v-flex>
          <v-flex sm11 xs10>
            <v-checkbox
              v-model="searchCondition.<%= property.name %>.value"
              :disabled="!searchCondition.<%= property.name %>.enabled"
              label="<%= property.screenLabel ? property.screenLabel : property.name %>"
            ></v-checkbox>
          </v-flex>
        </v-layout>
        <%_ } -%>
      <%_ }) -%>
      <%_ } -%>
      </v-card-text>
      <v-card-actions>
        <v-btn color="grey darken-1" text @click="close">キャンセル</v-btn>
        <v-spacer></v-spacer>
        <v-btn color="red darken-1" text @click="clear">クリア</v-btn>
        <v-spacer></v-spacer>
        <v-btn color="blue darken-1" text @click="search">検索</v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script lang="ts">
<%_ const searchConditions = [] -%>
<%_ let importDateTime = false -%>
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
  <%_ if ((property.type === 'time' || property.type === 'array-time')) { -%>
  <%_ importDateTime = true -%>
  <%_ } -%>
<%_ }) -%>
<%_ } -%>
import {Component, Emit, mixins, Prop, PropSync, Watch} from 'nuxt-property-decorator'
import {cloneDeep} from 'lodash-es'
<%_ if (searchConditions.length > 0) { -%>
import Base, {BaseSearchCondition, SingleSearchCondition} from '@/mixins/base'
<%_ } else { -%>
import Base from '@/mixins/base'
<%_ } -%>
<%_ if (importDateTime) { -%>
import DateTimeForm from '@/components/form/DateTimeForm.vue'
<%_ } -%>

<%_ if (searchConditions.length > 0) { -%>
export interface <%= h.changeCase.pascal(entity.name) %>SearchCondition extends BaseSearchCondition {
  <%_ searchConditions.forEach(function(property) { -%>
    <%_ if (property.type === 'string' && !property.range) { -%>
  <%= property.name %>: SingleSearchCondition<<%= property.type %>>
    <%_ } -%>
    <%_ if (property.type === 'boolean' && !property.range) { -%>
  <%= property.name %>: SingleSearchCondition<<%= property.type %>>
    <%_ } -%>
    <%_ if (property.type === 'number' && !property.range) { -%>
  <%= property.name %>: SingleSearchCondition<<%= property.type %>>
    <%_ } -%>
    <%_ if (property.type === 'number' && property.range) { -%>
  <%= property.name %>: SingleSearchCondition<<%= property.type %>>
  <%= property.name %>From: SingleSearchCondition<<%= property.type %>>
  <%= property.name %>To: SingleSearchCondition<<%= property.type %>>
    <%_ } -%>
    <%_ if (property.type === 'string' && property.range) { -%>
  <%= property.name %>: SingleSearchCondition<<%= property.type %>>
  <%= property.name %>From: SingleSearchCondition<<%= property.type %>>
  <%= property.name %>To: SingleSearchCondition<<%= property.type %>>
    <%_ } -%>
  <%_ }) -%>
}

export const INITIAL_<%= h.changeCase.constant(entity.name) %>_SEARCH_CONDITION: <%= h.changeCase.pascal(entity.name) %>SearchCondition = {
  <%_ searchConditions.forEach(function(property) { -%>
    <%_ if (property.type === 'string' && !property.range) { -%>
  <%= property.name %>: {enabled: false, value: ''},
    <%_ } -%>
    <%_ if (property.type === 'boolean' && !property.range) { -%>
  <%= property.name %>: {enabled: false, value: false},
    <%_ } -%>
    <%_ if (property.type === 'number' && !property.range) { -%>
  <%= property.name %>: {enabled: false, value: 0},
    <%_ } -%>
    <%_ if (property.type === 'number' && property.range) { -%>
  <%= property.name %>: {enabled: false, value: 0},
  <%= property.name %>From: {enabled: false, value: 0},
  <%= property.name %>To: {enabled: false, value: 0},
    <%_ } -%>
    <%_ if (property.type === 'string' && property.range) { -%>
  <%= property.name %>: {enabled: false, value: ''},
  <%= property.name %>From: {enabled: false, value: ''},
  <%= property.name %>To: {enabled: false, value: ''},
    <%_ } -%>
  <%_ }) -%>
}
<%_ } else { -%>
export interface <%= h.changeCase.pascal(entity.name) %>SearchCondition {
}

export const INITIAL_<%= h.changeCase.constant(entity.name) %>_SEARCH_CONDITION: <%= h.changeCase.pascal(entity.name) %>SearchCondition = {}
<%_ } -%>

<%_ if (importDateTime) { -%>
@Component({
  components: {
    DateTimeForm,
  }
})
<%_ } else { -%>
@Component
<%_ } -%>
export default class <%= h.changeCase.pascal(entity.name) %>SearchForm extends mixins(Base) {
  /** 表示状態 (true: 表示, false: 非表示) */
  @PropSync('open', {type: Boolean, required: true})
  syncedOpen!: boolean

  /** 検索条件 */
  @Prop({type: Object, required: true})
  currentSearchCondition!: <%= h.changeCase.pascal(entity.name) %>SearchCondition

  /** 変更対象の検索条件 */
  searchCondition: <%= h.changeCase.pascal(entity.name) %>SearchCondition = cloneDeep(INITIAL_<%= h.changeCase.constant(entity.name) %>_SEARCH_CONDITION)

  @Watch('syncedOpen')
  initialize() {
    if (this.syncedOpen) {
      this.searchCondition = cloneDeep(this.currentSearchCondition)
    }
  }

  clear() {
    this.searchCondition = cloneDeep(INITIAL_<%= h.changeCase.constant(entity.name) %>_SEARCH_CONDITION)
    this.search()
  }

  close() {
    this.syncedOpen = false
  }

  @Emit('search')
  search() {
    this.close()
    return this.searchCondition
  }
}
</script>

<style scoped></style>
