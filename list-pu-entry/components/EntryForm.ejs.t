---
to: <%= rootDirectory %>/components/<%= struct.name.lowerCamelName %>/<%= struct.name.pascalName %>EntryForm.vue
---
<script setup lang="ts">
<%_ let structForms = [] -%>
<%_ struct.fields.forEach(function (field, key) { -%>
  <%_ if (field.editType === 'struct') { -%>
    <%_ structForms.push(field.name.lowerCamelName) -%>
  <%_ } -%>
<%_ }) -%>
import {<%_ if (struct.screenType !== 'struct') { -%><%= struct.name.pascalName %>Api, <% } -%>Model<%= struct.name.pascalName %>} from '@/apis'
<%_ let importDateTime = false -%>
<%_ if (struct.fields) { -%>
<%_ struct.fields.forEach(function(field, index){ -%>
  <%_ if ((field.listType === 'time' || field.listType === 'array-time') && !importDateTime) { -%>
import DateTimeForm from '@/components/form/DateTimeForm.vue'
      <%_ importDateTime = true -%>
  <%_ } -%>
<%_ }) -%>
<%_ } -%>
<%_ if (struct.exists.edit.image) { -%>
import ImageForm from '@/components/form/ImageForm.vue'
<%_ } -%>
<%_ if (struct.exists.edit.arrayImage) { -%>
import ImageArrayForm from '@/components/form/ImageArrayForm.vue'
<%_ } -%>
<%_ const importArrayStructSet = new Set() -%>
<%_ const importStructSet = new Set() -%>
<%_ let importExpansion = false -%>
<%_ let importStructArrayForm = false -%>
<%_ let importArrayForm = false -%>
<%_ importDateTime = false -%>
<%_ const importStructTableSet = new Set() -%>
<%_ const importStructFormSet = new Set() -%>
<%_ if (struct.fields) { -%>
<%_ struct.fields.forEach(function(field, index){ -%>
  <%_ if (field.editType === 'array-struct') { -%>
    <%_ if (!importStructTableSet.has(field.structName.pascalName)) { -%>
import <%= field.structName.pascalName %>DataTable from '@/components/<%= field.structName.lowerCamelName %>/<%= field.structName.pascalName %>DataTable.vue'
      <%_ importStructTableSet.add(field.structName.pascalName) -%>
    <%_ } -%>
    <%_ if (!importStructFormSet.has(field.structName.pascalName)) { -%>
import <%= field.structName.pascalName %>EntryForm, {INITIAL_<%= field.structName.upperSnakeName %>} from '@/components/<%= field.structName.lowerCamelName %>/<%= field.structName.pascalName %>EntryForm.vue'
      <%_ importStructFormSet.add(field.structName.pascalName) -%>
    <%_ } -%>
  <%_ } -%>
  <%_ if (field.editType === 'struct') { -%>
    <%_ if (!importStructFormSet.has(field.structName.pascalName)) { -%>
import <%= field.structName.pascalName %>EntryForm, {INITIAL_<%= field.structName.upperSnakeName %>} from '@/components/<%= field.structName.lowerCamelName %>/<%= field.structName.pascalName %>EntryForm.vue'
      <%_ importStructFormSet.add(field.structName.pascalName) -%>
    <%_ } -%>
  <%_ } -%>
<%_ }) -%>
<%_ } -%>
<%_ if (struct.fields) { -%>
<%_ struct.fields.forEach(function(field, index){ -%>
  <%_ if (field.editType === 'struct') { -%>
    <%_ if (!importExpansion) { -%>
import Expansion from '@/components/form/Expansion.vue'
      <%_ importExpansion = true -%>
    <%_ } -%>
    <%_ if (!importArrayStructSet.has(field.structType) && !importStructSet.has(field.structType)) { -%>
import <%= field.structName.pascalName %>EntryForm, {INITIAL_<%= field.structName.upperSnakeName %>} from '@/components/<%= field.structName.lowerCamelName %>/<%= field.structName.pascalNam %>EntryForm.vue'
      <%_ importStructSet.add(field.structType) -%>
    <%_ } -%>
  <%_ } -%>
  <%_ if (field.editType === 'array-string' || field.editType === 'array-textarea' || field.editType === 'array-number' || field.editType === 'array-time' || field.editType === 'array-bool') { -%>
    <%_ if (!importExpansion) { -%>
import Expansion from '@/components/form/Expansion.vue'
      <%_ importExpansion = true -%>
    <%_ } -%>
    <%_ if (!importArrayForm) { -%>
import ArrayForm from '@/components/form/ArrayForm.vue'
      <%_ importArrayForm = true -%>
    <%_ } -%>
  <%_ } -%>
<%_ }) -%>
<%_ } -%>

export const INITIAL_<%= struct.name.upperSnakeName %>: Model<%= struct.name.pascalName %> = {
<%_ if (struct.fields) { -%>
<%_ struct.fields.forEach(function(field, index){ -%>
  <%_ if (field.editType === 'struct') { -%>
  <%= field.name.lowerCamelName %>: INITIAL_<%= field.structName.upperSnakeName %>,
  <%_ } -%>
  <%_ if (field.editType.startsWith('array')) { -%>
  <%= field.name.lowerCamelName %>: [],
  <%_ } -%>
  <%_ if (field.editType === 'string' || field.editType === 'textarea' || field.editType === 'time') { -%>
  <%= field.name.lowerCamelName %>: undefined,
  <%_ } -%>
  <%_ if (field.editType === 'bool') { -%>
  <%= field.name.lowerCamelName %>: undefined,
  <%_ } -%>
  <%_ if (field.editType === 'number') { -%>
  <%= field.name.lowerCamelName %>: undefined,
  <%_ } -%>
<%_ }) -%>
<%_ } -%>
}

interface Props {
  /** 表示状態 (true: 表示, false: 非表示) */
  open!: boolean
  /** 編集対象 */
  target!: Model<%= struct.name.pascalName %>
  /** 表示方式 (true: 埋め込み, false: ダイアログ) */
  isEmbedded!: boolean
  /** 表示方式 (true: 子要素として表示, false: 親要素として表示) */
  hasParent!: boolean
  /** 編集状態 (true: 新規, false: 更新) */
  isNew!: boolean
}
const props = withDefaults(defineProps<Props>(), {
  open: true,
  target: {},
  isEmbedded: false,
  hasParent: false,
  isNew: true,
})

interface Emits {
  (e: "updated", item: T): void;
  (e: "remove", item: T): void;
  (e: "update:open", open: boolean): void;
}
const emit = defineEmits<Emits>()

const dialog = useAppDialog()

<%_ struct.fields.forEach(function (field, key) { -%>
  <%_ if (field.editType === 'array-struct') { -%>

/** <%= field.structName.pascalName %>の初期値 */
const initial<%= field.structName.pascalName %> = ref<Model<%= struct.name.pascalName %>>(INITIAL_<%= field.structName.upperSnakeName %>)
  <%_ } -%>
<%_ }) -%>

const validationRules = ref<any>({
<%_ struct.fields.forEach(function (field, key) { -%>
  <%_ if (field.editType !== 'array-struct' && field.editType !== 'struct') { -%>
    <%= field.name.lowerCamelName %>: [],
  <%_ } -%>
<%_ }) -%>
})

watch(open, (open) => {
  if (props.open) {
    entryForm.value.resetValidation()<% if (structForms.length > 0) { %>;<% } %>
<%_ structForms.forEach(function (name, index) { -%>
    (<%= name %>Form.value?.$refs.entryForm as VForm)?.resetValidation()<% if (structForms.length - 1 !== index) { %>;<% } %>
<%_ }) -%>
  }
})

const initializeTarget = () => {
  this.target = INITIAL_<%= struct.name.upperSnakeName %>
}

const validateForm = () => {
<%_ if (structForms.length === 0) { -%>
  if (!(this.$refs.entryForm as VForm).validate()) {
<%_ } else { -%>
  if (!(this.$refs.entryForm as VForm).validate()
<%_ structForms.forEach(function (name, index) { -%>
    || ((this.$refs.<%= name %>Form as Vue)?.$refs.entryForm as VForm)?.validate() === false<% if (structForms.length - 1 === index) { %>) {<% } %>
<%_ }) -%>
<%_ } -%>
    dialog.showDialog({
      title: 'エラー',
      message: '入力項目を確認して下さい。'
    })
    return
  }
  this.save()
}

const save = async () => {
<%_ if (struct.screenType !== 'struct') { -%><%#_ Structでない場合 -%>
  if (hasParent) {
    // 親要素側で保存
    return
  }
  loading.showLoading()
  try {
    if (props.isNew) {
      // 新規の場合
      await new <%= struct.name.pascalName %>Api().create<%= struct.name.pascalName %>({
        body: this.target
      })
    } else {
      // 更新の場合
      await new <%= struct.name.pascalName %>Api().update<%= struct.name.pascalName %>({
        id: target.id!,
        body: target
      })
    }
    close()
  } finally {
    loading.hideLoading()
  }
<%_ } else { -%>
  close()
<%_ } -%>
}

const remove = async () => {
  emit('remove', target)
}

const close = () => {
  if (!props.isEmbedded) {
    emit('update:open', false)
  }
}
</script>

<template>
  <v-card :elevation="0">
    <v-card-title v-if="!isEmbedded"><%= struct.label || struct.name.pascalName %>{{ isNew ? '追加' : '編集' }}</v-card-title>
    <v-card-text>
      <v-layout v-if="target" wrap>
        <v-form ref="entryForm" class="full-width" lazy-validation>
        <%_ struct.fields.forEach(function (field, key) { -%>
          <%_ if (field.editType === 'string' && field.name.lowerCamelName === 'id') { -%>
          <v-flex md12 sm12 xs12>
            <v-text-field
              v-model="target.<%= field.name.lowerCamelName %>"
              :disabled="!isNew"
              :rules="validationRules.<%= field.name.lowerCamelName %>"
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
              required
            ></v-text-field>
          </v-flex>
          <%_ } -%>
          <%_ if (field.editType === 'string' && field.name.lowerCamelName !== 'id') { -%>
          <v-flex md12 sm12 xs12>
            <v-text-field
              v-model="target.<%= field.name.lowerCamelName %>"
              :rules="validationRules.<%= field.name.lowerCamelName %>"
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
            ></v-text-field>
          </v-flex>
          <%_ } -%>
          <%_ if (field.editType === 'number' && field.name.lowerCamelName === 'id') { -%>
          <v-flex md12 sm12 xs12>
            <v-text-field
              :disabled="!isNew"
              :rules="validationRules.<%= field.name.lowerCamelName %>"
              :value="target.<%= field.name.lowerCamelName %>"
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
              required
              type="number"
              @input="v => target.<%= field.name.lowerCamelName %> = v === '' ? undefined : Number(v)"
            ></v-text-field>
          </v-flex>
          <%_ } -%>
          <%_ if (field.editType === 'number' && field.name.lowerCamelName !== 'id') { -%>
          <v-flex md12 sm12 xs12>
            <v-text-field
              :rules="validationRules.<%= field.name.lowerCamelName %>"
              :value="target.<%= field.name.lowerCamelName %>"
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
              type="number"
              @input="v => target.<%= field.name.lowerCamelName %> = v === '' ? undefined : Number(v)"
            ></v-text-field>
          </v-flex>
          <%_ } -%>
          <%_ if (field.editType === 'time') { -%>
          <date-time-form
            :date-time.sync="target.<%= field.name.lowerCamelName %>"
            :rules="validationRules.<%= field.name.lowerCamelName %>"
            label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
          ></date-time-form>
          <%_ } -%>
          <%_ if (field.editType === 'textarea') { -%>
          <v-flex md12 sm12 xs12>
            <v-textarea
              v-model="target.<%= field.name.lowerCamelName %>"
              :rules="validationRules.<%= field.name.lowerCamelName %>"
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
            ></v-textarea>
          </v-flex>
          <%_ } -%>
          <%_ if (field.editType === 'bool') { -%>
          <v-flex md12 sm12 xs12>
            <v-checkbox
              v-model="target.<%= field.name.lowerCamelName %>"
              :rules="validationRules.<%= field.name.lowerCamelName %>"
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
            ></v-checkbox>
          </v-flex>
          <%_ } -%>
          <%_ if (field.editType === 'image' && field.dataType === 'string') { -%>
          <v-flex xs12>
            <image-form
              :image-url.sync="target.<%= field.name.lowerCamelName %>"
              :rules="validationRules.<%= field.name.lowerCamelName %>"
              dir="<%= struct.name.lowerCamelName %>/<%= field.name.lowerCamelName %>"
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
            ></image-form>
          </v-flex>
          <%_ } -%>
          <%_ if (field.editType === 'array-image') { -%>
          <v-flex xs12>
            <image-array-form
              :image-urls.sync="target.<%= field.name.lowerCamelName %>"
              :rules="validationRules.<%= field.name.lowerCamelName %>"
              dir="<%= struct.name.lowerCamelName %>/<%= field.name.lowerCamelName %>"
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
            ></image-array-form>
          </v-flex>
          <%_ } -%>
          <%_ if (field.editType === 'array-string' || field.editType === 'array-textarea' || field.editType === 'array-number' || field.editType === 'array-time' || field.editType === 'array-bool') { -%>
          <v-flex xs12>
            <expansion label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>一覧">
              <%_ if (field.childType === 'string') { -%>
              <array-form
                v-slot="{editTarget, updatedForm}"
                :items.sync="target.<%= field.name.lowerCamelName %>"
                initial="">
                <v-text-field
                  :rules="validationRules.<%= field.name.lowerCamelName %>"
                  :value="editTarget"
                  label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
                  @input="updatedForm"
                ></v-text-field>
              </array-form>
              <%_ } -%>
              <%_ if (field.childType === 'textarea') { -%>
              <array-form
                v-slot="{editTarget, updatedForm}"
                :items.sync="target.<%= field.name.lowerCamelName %>"
                initial="">
                <v-textarea
                  :rules="validationRules.<%= field.name.lowerCamelName %>"
                  :value="editTarget"
                  label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
                  @input="updatedForm"
                ></v-textarea>
              </array-form>
              <%_ } -%>
              <%_ if (field.childType === 'number') { -%>
              <array-form
                v-slot="{editTarget, updatedForm}"
                :initial="0"
                :items.sync="target.<%= field.name.lowerCamelName %>">
                <v-text-field
                  :rules="validationRules.<%= field.name.lowerCamelName %>"
                  :value="editTarget"
                  label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
                  type="number"
                  @input="v => updatedForm(v === '' ? undefined : Number(v))"
                ></v-text-field>
              </array-form>
              <%_ } -%>
              <%_ if (field.childType === 'bool') { -%>
              <array-form
                v-slot="{editTarget, updatedForm}"
                :initial="false"
                :items.sync="target.<%= field.name.lowerCamelName %>">
                <v-checkbox
                  :rules="validationRules.<%= field.name.lowerCamelName %>"
                  :value="editTarget"
                  label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
                  @change="updatedForm"
                ></v-checkbox>
              </array-form>
              <%_ } -%>
              <%_ if (field.childType === 'time') { -%>
              <array-form
                v-slot="{editTarget, updatedForm}"
                :initial="formatISO(new Date())"
                :items.sync="target.<%= field.name.lowerCamelName %>">
                <date-time-form
                  :date-time.sync="editTarget"
                  :rules="validationRules.<%= field.name.lowerCamelName %>"
                  label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
                  @update:dateTime="updatedForm"
                ></date-time-form>
              </array-form>
              <%_ } -%>
            </expansion>
          </v-flex>
          <%_ } -%>
          <%_ if (field.editType === 'array-struct') { -%>
          <v-flex xs12>
            <expansion label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>一覧">
              <struct-array-form
                :initial="initial<%= field.structName.pascalNam %>"
                :items.sync="target.<%= field.name.lowerCamelName %>">
                <template v-slot:table="{items, openEntryForm, removeRow}">
                  <<%= field.structName.lowerCamelName %>-data-table
                    :has-parent="true"
                    :items="items"
                    @openEntryForm="openEntryForm"
                    @remove="removeRow"
                  ></<%= field.structName.lowerCamelName %>-data-table>
                </template>
                <template v-slot:form="{editIndex, isEntryFormOpen, editTarget, closeForm, removeForm, updatedForm}">
                  <<%= field.structName.lowerCamelName %>-entry-form
                    :has-parent="true"
                    :is-new="editIndex === NEW_INDEX"
                    :open="isEntryFormOpen"
                    :target="editTarget"
                    @close="closeForm"
                    @remove="removeForm"
                    @updated="updatedForm"
                  ></<%= field.structName.lowerCamelName %>-entry-form>
                </template>
              </struct-array-form>
            </expansion>
          </v-flex>
          <%_ } -%>
          <%_ if (field.editType === 'struct') { -%>
          <v-flex xs12>
            <expansion expanded label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>">
              <<%= field.structName.lowerCamelName %>-entry-form
                ref="<%= field.name.lowerCamelName %>Form"
                :has-parent="true"
                :is-embedded="true"
                :target.sync="target.<%= field.name.lowerCamelName %>"
              ></<%= field.structName.lowerCamelName %>-entry-form>
            </expansion>
          </v-flex>
          <%_ } -%>
        <%_ }) -%>
        </v-form>
      </v-layout>
      <v-layout v-else>
        <v-spacer></v-spacer>
        <v-btn class="action-button" color="primary" dark fab small top @click="initializeTarget">
          <v-icon>mdi-plus</v-icon>
        </v-btn>
      </v-layout>
    </v-card-text>
    <v-card-actions v-if="!isEmbedded">
      <v-btn color="grey darken-1" text @click="close">キャンセル</v-btn>
      <v-spacer></v-spacer>
      <v-btn v-if="!isNew" color="red darken-1" text @click="remove">削除</v-btn>
      <v-spacer></v-spacer>
      <v-btn color="blue darken-1" text @click="validateForm">保存</v-btn>
    </v-card-actions>
  </v-card>
</template>

<style scoped>
.action-button {
  pointer-events: auto;
}
</style>
