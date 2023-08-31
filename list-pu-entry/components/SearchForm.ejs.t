---
to: <%= rootDirectory %>/components/<%= struct.name.lowerCamelName %>/<%= struct.name.pascalName %>SearchForm.vue
---
<script setup lang="ts">
<%_ const searchConditions = [] -%>
<%_ let importDateTime = false -%>
<%_ if (struct.fields) { -%>
<%_ struct.fields.forEach(function(field, index){ -%>
  <%_ if ((field.editType === 'string' || field.editType === 'array-string' || field.editType === 'time' || field.editType === 'array-time') && field.searchType === 1) { -%>
    <%_ searchConditions.push({name: field.name.lowerCamelName, type: 'string', range: false}) -%>
  <%_ } -%>
  <%_ if ((field.editType === 'bool' || field.editType === 'array-bool') && field.searchType === 1) { -%>
    <%_ searchConditions.push({name: field.name.lowerCamelName, type: 'boolean', range: false}) -%>
  <%_ } -%>
  <%_ if ((field.editType === 'number' || field.editType === 'array-number') && field.searchType === 1) { -%>
    <%_ searchConditions.push({name: field.name.lowerCamelName, type: 'number', range: false}) -%>
  <%_ } -%>
  <%_ if ((field.editType === 'number' || field.editType === 'array-number') && 2 <= field.searchType &&  field.searchType <= 5) { -%>
    <%_ searchConditions.push({name: field.name.lowerCamelName, type: 'number', range: true}) -%>
  <%_ } -%>
  <%_ if ((field.editType === 'time' || field.editType === 'array-time') && 2 <= field.searchType &&  field.searchType <= 5) { -%>
    <%_ searchConditions.push({name: field.name.lowerCamelName, type: 'string', range: true}) -%>
  <%_ } -%>
  <%_ if ((field.editType === 'time' || field.editType === 'array-time')) { -%>
  <%_ importDateTime = true -%>
  <%_ } -%>
<%_ }) -%>
<%_ } -%>
import {cloneDeep} from 'lodash-es'
<%_ if (importDateTime) { -%>
import DateTimeForm from '@/components/form/DateTimeForm.vue'
<%_ } -%>

export interface <%= struct.name.pascalName %>SearchCondition {
  <%_ searchConditions.forEach(function(searchCondition) { -%>
    <%_ if (searchCondition.type === 'string' && !searchCondition.range) { -%>
  <%= searchCondition.name %>?: <%= searchCondition.type %>
    <%_ } -%>
    <%_ if (searchCondition.type === 'boolean' && !searchCondition.range) { -%>
  <%= searchCondition.name %>?: <%= searchCondition.type %>
    <%_ } -%>
    <%_ if (searchCondition.type === 'number' && !searchCondition.range) { -%>
  <%= searchCondition.name %>?: <%= searchCondition.type %>
    <%_ } -%>
    <%_ if (searchCondition.type === 'number' && searchCondition.range) { -%>
  <%= searchCondition.name %>?: <%= searchCondition.type %>
  <%= searchCondition.name %>From?: <%= searchCondition.type %>
  <%= searchCondition.name %>To?: <%= searchCondition.type %>
    <%_ } -%>
    <%_ if (searchCondition.type === 'string' && searchCondition.range) { -%>
  <%= searchCondition.name %>?: <%= searchCondition.type %>
  <%= searchCondition.name %>From?: <%= searchCondition.type %>
  <%= searchCondition.name %>To?: <%= searchCondition.type %>
    <%_ } -%>
  <%_ }) -%>
}

export const INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION: <%= struct.name.pascalName %>SearchCondition = {
  <%_ searchConditions.forEach(function(searchCondition) { -%>
    <%_ if (searchCondition.type === 'string' && !searchCondition.range) { -%>
  <%= searchCondition.name %>: undefined,
    <%_ } -%>
    <%_ if (searchCondition.type === 'boolean' && !searchCondition.range) { -%>
  <%= searchCondition.name %>: undefined,
    <%_ } -%>
    <%_ if (searchCondition.type === 'number' && !searchCondition.range) { -%>
  <%= searchCondition.name %>: undefined,
    <%_ } -%>
    <%_ if (searchCondition.type === 'number' && searchCondition.range) { -%>
  <%= searchCondition.name %>: undefined,
  <%= searchCondition.name %>From: undefined,
  <%= searchCondition.name %>To: undefined,
    <%_ } -%>
    <%_ if (searchCondition.type === 'string' && searchCondition.range) { -%>
  <%= searchCondition.name %>: undefined,
  <%= searchCondition.name %>From: undefined,
  <%= searchCondition.name %>To: undefined,
    <%_ } -%>
  <%_ }) -%>
}

export const INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION: <%= struct.name.pascalName %>SearchCondition = {}
<%_ } -%>

interface Props {
  /** 表示状態 (true: 表示, false: 非表示) */
  open: boolean
  /** 検索条件 */
  currentSearchCondition: <%= struct.name.pascalName %>SearchCondition
}
const props = withDefaults(defineProps<Props>(), {
  open: true,
  currentSearchCondition: (props: Props) => INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION,
})

interface Emits {
  (e: "search", searchCondition: <%= struct.name.pascalName %>SearchCondition): void;
  (e: "update:open", open: boolean): void;
}
const emit = defineEmits<Emits>()

/** 変更対象の検索条件 */
const searchCondition = ref<<%= struct.name.pascalName %>SearchCondition>(cloneDeep(INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION))

watch(open, (open) => {
  if (props.open) {
    searchCondition.value = cloneDeep(props.currentSearchCondition)
  }
})

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
      <v-card-title><%= struct.name.pascalName %>検索</v-card-title>
      <v-card-text>
      <%_ struct.fields.forEach(function(field, index){ -%>
        <%_ if ((field.listType === 'string' || field.listType === 'array-string' || field.listType === 'textarea' || field.listType === 'array-textarea') && field.searchType === 1) { -%>
        <v-layout>
          <v-flex sm1 xs2>
            <v-switch v-model="searchCondition.<%= field.name.lowerCamelName %>.enabled"/>
          </v-flex>
          <v-flex sm11 xs10>
            <v-text-field
              v-model="searchCondition.<%= field.name.lowerCamelName %>.value"
              :disabled="!searchCondition.<%= field.name.lowerCamelName %>.enabled"
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
            ></v-text-field>
          </v-flex>
        </v-layout>
        <%_ } -%>
        <%_ if ((field.listType === 'number' || field.listType === 'array-number') && field.searchType !== 0) { -%>
        <v-layout>
          <v-flex sm1 xs2>
            <v-switch v-model="searchCondition.<%= field.name.lowerCamelName %>.enabled"/>
          </v-flex>
          <v-flex sm11 xs10>
            <v-text-field
              :disabled="!searchCondition.<%= field.name.lowerCamelName %>.enabled"
              :value="searchCondition.<%= field.name.lowerCamelName %>.value"
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
              type="number"
              @input="v => searchCondition.<%= field.name.lowerCamelName %>.value = v === '' ? undefined : Number(v)"
            ></v-text-field>
          </v-flex>
        </v-layout>
        <%_ } -%>
        <%_ if ((field.listType === 'number' || field.listType === 'array-number') && 2 <= field.searchType && field.searchType <= 5) { -%>
        <v-layout>
          <v-flex sm1 xs2>
            <v-switch v-model="searchCondition.<%= field.name.lowerCamelName %>From.enabled"/>
          </v-flex>
          <v-flex sm11 xs10>
            <v-text-field
              :disabled="!searchCondition.<%= field.name.lowerCamelName %>From.enabled"
              :value="searchCondition.<%= field.name.lowerCamelName %>From.value"
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>開始"
              type="number"
              @input="(v) => searchCondition.<%= field.name.lowerCamelName %>From.value = (v === '' ? -1 : Number(v))"
            ></v-text-field>
          </v-flex>
        </v-layout>
        <v-layout>
          <v-flex sm1 xs2>
            <v-switch v-model="searchCondition.<%= field.name.lowerCamelName %>To.enabled"/>
          </v-flex>
          <v-flex sm11 xs10>
            <v-text-field
              :disabled="!searchCondition.<%= field.name.lowerCamelName %>To.enabled"
              :value="searchCondition.<%= field.name.lowerCamelName %>To.value"
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>終了"
              type="number"
              @input="v => searchCondition.<%= field.name.lowerCamelName %>To.value = v === '' ? undefined : Number(v)"
            ></v-text-field>
          </v-flex>
        </v-layout>
        <%_ } -%>
        <%_ if ((field.listType === 'time' || field.listType === 'array-time') && field.searchType !== 0) { -%>
        <v-layout>
          <v-flex sm1 xs2>
            <v-switch v-model="searchCondition.<%= field.name.lowerCamelName %>.enabled"/>
          </v-flex>
          <v-flex sm11 xs10>
            <date-time-form
              :date-time.sync="searchCondition.<%= field.name.lowerCamelName %>.value"
              :disabled="!searchCondition.<%= field.name.lowerCamelName %>.enabled"
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
            ></date-time-form>
          </v-flex>
        </v-layout>
        <%_ } -%>
        <%_ if ((field.listType === 'time' || field.listType === 'array-time') && 2 <= field.searchType &&  field.searchType <= 5) { -%>
        <v-layout>
          <v-flex sm1 xs2>
            <v-switch v-model="searchCondition.<%= field.name.lowerCamelName %>From.enabled"/>
          </v-flex>
          <v-flex sm11 xs10>
            <date-time-form
              :date-time.sync="searchCondition.<%= field.name.lowerCamelName %>From.value"
              :disabled="!searchCondition.<%= field.name.lowerCamelName %>From.enabled"
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>開始"
            ></date-time-form>
          </v-flex>
        </v-layout>
        <v-layout>
          <v-flex sm1 xs2>
            <v-switch v-model="searchCondition.<%= field.name.lowerCamelName %>To.enabled"/>
          </v-flex>
          <v-flex sm11 xs10>
            <date-time-form
              :date-time.sync="searchCondition.<%= field.name.lowerCamelName %>To.value"
              :disabled="!searchCondition.<%= field.name.lowerCamelName %>To.enabled"
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>終了"
            ></date-time-form>
          </v-flex>
        </v-layout>
        <%_ } -%>
        <%_ if ((field.listType === 'bool' || field.listType === 'array-bool') && field.searchType === 1) { -%>
        <v-layout>
          <v-flex sm1 xs2>
            <v-switch v-model="searchCondition.<%= field.name.lowerCamelName %>.enabled"/>
          </v-flex>
          <v-flex sm11 xs10>
            <v-checkbox
              v-model="searchCondition.<%= field.name.lowerCamelName %>.value"
              :disabled="!searchCondition.<%= field.name.lowerCamelName %>.enabled"
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
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
