---
to: <%= rootDirectory %>/components/<%= struct.name.lowerCamelName %>/<%= struct.name.pascalNam %>SearchForm.vue
---
<script lang="ts">
<%_ const searchConditions = [] -%>
<%_ let importDateTime = false -%>
<%_ if (struct.listProperties.listExtraProperties && struct.listProperties.listExtraProperties.length > 0) { -%>
<%_ struct.listProperties.listExtraProperties.forEach(function (property, key) { -%>
  <%_ if ((property.listType === 'string' || property.listType === 'array-string' || property.listType === 'time' || property.listType === 'array-time') && property.searchType === 1) { -%>
    <%_ searchConditions.push({name: property.name.lowerCamelName, type: 'string', range: false}) -%>
  <%_ } -%>
  <%_ if ((property.listType === 'bool' || property.listType === 'array-bool') && property.searchType === 1) { -%>
    <%_ searchConditions.push({name: property.name.lowerCamelName, type: 'boolean', range: false}) -%>
  <%_ } -%>
  <%_ if ((property.listType === 'number' || property.listType === 'array-number') && property.searchType === 1) { -%>
    <%_ searchConditions.push({name: property.name.lowerCamelName, type: 'number', range: false}) -%>
  <%_ } -%>
  <%_ if ((property.listType === 'number' || property.listType === 'array-number') && 2 <= property.searchType &&  property.searchType <= 5) { -%>
    <%_ searchConditions.push({name: property.name.lowerCamelName, type: 'number', range: true}) -%>
  <%_ } -%>
  <%_ if ((property.listType === 'time' || property.listType === 'array-time') && 2 <= property.searchType &&  property.searchType <= 5) { -%>
    <%_ searchConditions.push({name: property.name.lowerCamelName, type: 'string', range: true}) -%>
  <%_ } -%>
  <%_ if ((property.listType === 'time' || property.listType === 'array-time')) { -%>
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
export interface <%= struct.name.pascalNam %>SearchCondition extends BaseSearchCondition {
  <%_ searchConditions.forEach(function(property) { -%>
    <%_ if (property.listType === 'string' && !property.range) { -%>
  <%= property.name.lowerCamelName %>: SingleSearchCondition<<%= property.listType %>>
    <%_ } -%>
    <%_ if (property.listType === 'boolean' && !property.range) { -%>
  <%= property.name.lowerCamelName %>: SingleSearchCondition<<%= property.listType %>>
    <%_ } -%>
    <%_ if (property.listType === 'number' && !property.range) { -%>
  <%= property.name.lowerCamelName %>: SingleSearchCondition<<%= property.listType %>>
    <%_ } -%>
    <%_ if (property.listType === 'number' && property.range) { -%>
  <%= property.name.lowerCamelName %>: SingleSearchCondition<<%= property.listType %>>
  <%= property.name.lowerCamelName %>From: SingleSearchCondition<<%= property.listType %>>
  <%= property.name.lowerCamelName %>To: SingleSearchCondition<<%= property.listType %>>
    <%_ } -%>
    <%_ if (property.listType === 'string' && property.range) { -%>
  <%= property.name.lowerCamelName %>: SingleSearchCondition<<%= property.listType %>>
  <%= property.name.lowerCamelName %>From: SingleSearchCondition<<%= property.listType %>>
  <%= property.name.lowerCamelName %>To: SingleSearchCondition<<%= property.listType %>>
    <%_ } -%>
  <%_ }) -%>
}

export const INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION: <%= struct.name.pascalNam %>SearchCondition = {
  <%_ searchConditions.forEach(function(property) { -%>
    <%_ if (property.listType === 'string' && !property.range) { -%>
  <%= property.name.lowerCamelName %>: {enabled: false, value: ''},
    <%_ } -%>
    <%_ if (property.listType === 'boolean' && !property.range) { -%>
  <%= property.name.lowerCamelName %>: {enabled: false, value: false},
    <%_ } -%>
    <%_ if (property.listType === 'number' && !property.range) { -%>
  <%= property.name.lowerCamelName %>: {enabled: false, value: 0},
    <%_ } -%>
    <%_ if (property.listType === 'number' && property.range) { -%>
  <%= property.name.lowerCamelName %>: {enabled: false, value: 0},
  <%= property.name.lowerCamelName %>From: {enabled: false, value: 0},
  <%= property.name.lowerCamelName %>To: {enabled: false, value: 0},
    <%_ } -%>
    <%_ if (property.listType === 'string' && property.range) { -%>
  <%= property.name.lowerCamelName %>: {enabled: false, value: ''},
  <%= property.name.lowerCamelName %>From: {enabled: false, value: ''},
  <%= property.name.lowerCamelName %>To: {enabled: false, value: ''},
    <%_ } -%>
  <%_ }) -%>
}
<%_ } else { -%>
export interface <%= struct.name.pascalNam %>SearchCondition {
}

export const INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION: <%= struct.name.pascalNam %>SearchCondition = {}
<%_ } -%>

interface Props {
  /** 表示状態 (true: 表示, false: 非表示) */
  open!: boolean
  /** 検索条件 */
  currentSearchCondition!: <%= struct.name.pascalNam %>SearchCondition
}
const props = withDefaults(defineProps<Props>(), {
  open: true,
  currentSearchCondition: {},
})

interface Emits {
  (e: "search", searchCondition: <%= struct.name.pascalNam %>SearchConditionT): void;
}
const emit = defineEmits<Emits>()

/** 変更対象の検索条件 */
const searchCondition = ref<<%= struct.name.pascalNam %>SearchCondition>(cloneDeep(INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION))

watch(open, (open) => {
  if (props.open) {
    searchCondition.value = cloneDeep(props.currentSearchCondition)
  }
}

const clear = () => {
  searchCondition.value = cloneDeep(INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION)
  search()
}

const close = () => {
  emit('update:open', false)
}

const search = () => {
  close()
  emit('search', searchCondition.value)
}
</script>

<template>
  <v-dialog v-model="open" max-width="800px">
    <v-card :elevation="0">
      <v-card-title><%= struct.name.pascalNam %>検索</v-card-title>
      <v-card-text>
      <%_ struct.fields.forEach(function(property, index){ -%>
        <%_ if ((property.listType === 'string' || property.listType === 'array-string' || property.listType === 'textarea' || property.listType === 'array-textarea') && property.searchType === 1) { -%>
        <v-layout>
          <v-flex sm1 xs2>
            <v-switch v-model="searchCondition.<%= property.name.lowerCamelName %>.enabled"/>
          </v-flex>
          <v-flex sm11 xs10>
            <v-text-field
              v-model="searchCondition.<%= property.name.lowerCamelName %>.value"
              :disabled="!searchCondition.<%= property.name.lowerCamelName %>.enabled"
              label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>"
            ></v-text-field>
          </v-flex>
        </v-layout>
        <%_ } -%>
        <%_ if ((property.listType === 'number' || property.listType === 'array-number') && property.searchType !== 0) { -%>
        <v-layout>
          <v-flex sm1 xs2>
            <v-switch v-model="searchCondition.<%= property.name.lowerCamelName %>.enabled"/>
          </v-flex>
          <v-flex sm11 xs10>
            <v-text-field
              :disabled="!searchCondition.<%= property.name.lowerCamelName %>.enabled"
              :value="searchCondition.<%= property.name.lowerCamelName %>.value"
              label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>"
              type="number"
              @input="v => searchCondition.<%= property.name.lowerCamelName %>.value = v === '' ? undefined : Number(v)"
            ></v-text-field>
          </v-flex>
        </v-layout>
        <%_ } -%>
        <%_ if ((property.listType === 'number' || property.listType === 'array-number') && 2 <= property.searchType && property.searchType <= 5) { -%>
        <v-layout>
          <v-flex sm1 xs2>
            <v-switch v-model="searchCondition.<%= property.name.lowerCamelName %>From.enabled"/>
          </v-flex>
          <v-flex sm11 xs10>
            <v-text-field
              :disabled="!searchCondition.<%= property.name.lowerCamelName %>From.enabled"
              :value="searchCondition.<%= property.name.lowerCamelName %>From.value"
              label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>開始"
              type="number"
              @input="v => searchCondition.<%= property.name.lowerCamelName %>From.value = v === '' ? undefined : Number(v)"
            ></v-text-field>
          </v-flex>
        </v-layout>
        <v-layout>
          <v-flex sm1 xs2>
            <v-switch v-model="searchCondition.<%= property.name.lowerCamelName %>To.enabled"/>
          </v-flex>
          <v-flex sm11 xs10>
            <v-text-field
              :disabled="!searchCondition.<%= property.name.lowerCamelName %>To.enabled"
              :value="searchCondition.<%= property.name.lowerCamelName %>To.value"
              label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>終了"
              type="number"
              @input="v => searchCondition.<%= property.name.lowerCamelName %>To.value = v === '' ? undefined : Number(v)"
            ></v-text-field>
          </v-flex>
        </v-layout>
        <%_ } -%>
        <%_ if ((property.listType === 'time' || property.listType === 'array-time') && property.searchType !== 0) { -%>
        <v-layout>
          <v-flex sm1 xs2>
            <v-switch v-model="searchCondition.<%= property.name.lowerCamelName %>.enabled"/>
          </v-flex>
          <v-flex sm11 xs10>
            <date-time-form
              :date-time.sync="searchCondition.<%= property.name.lowerCamelName %>.value"
              :disabled="!searchCondition.<%= property.name.lowerCamelName %>.enabled"
              label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>"
            ></date-time-form>
          </v-flex>
        </v-layout>
        <%_ } -%>
        <%_ if ((property.listType === 'time' || property.listType === 'array-time') && 2 <= property.searchType &&  property.searchType <= 5) { -%>
        <v-layout>
          <v-flex sm1 xs2>
            <v-switch v-model="searchCondition.<%= property.name.lowerCamelName %>From.enabled"/>
          </v-flex>
          <v-flex sm11 xs10>
            <date-time-form
              :date-time.sync="searchCondition.<%= property.name.lowerCamelName %>From.value"
              :disabled="!searchCondition.<%= property.name.lowerCamelName %>From.enabled"
              label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>開始"
            ></date-time-form>
          </v-flex>
        </v-layout>
        <v-layout>
          <v-flex sm1 xs2>
            <v-switch v-model="searchCondition.<%= property.name.lowerCamelName %>To.enabled"/>
          </v-flex>
          <v-flex sm11 xs10>
            <date-time-form
              :date-time.sync="searchCondition.<%= property.name.lowerCamelName %>To.value"
              :disabled="!searchCondition.<%= property.name.lowerCamelName %>To.enabled"
              label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>終了"
            ></date-time-form>
          </v-flex>
        </v-layout>
        <%_ } -%>
        <%_ if ((property.listType === 'bool' || property.listType === 'array-bool') && property.searchType === 1) { -%>
        <v-layout>
          <v-flex sm1 xs2>
            <v-switch v-model="searchCondition.<%= property.name.lowerCamelName %>.enabled"/>
          </v-flex>
          <v-flex sm11 xs10>
            <v-checkbox
              v-model="searchCondition.<%= property.name.lowerCamelName %>.value"
              :disabled="!searchCondition.<%= property.name.lowerCamelName %>.enabled"
              label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>"
            ></v-checkbox>
          </v-flex>
        </v-layout>
        <%_ } -%>
      <%_ }) -%>
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

<style scoped></style>
