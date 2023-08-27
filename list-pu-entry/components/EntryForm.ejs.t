---
to: <%= rootDirectory %>/components/<%= struct.name.lowerCamelName %>/<%= struct.name.pascalName %>EntryForm.vue
---
<script setup lang="ts">
<%_ let structForms = [] -%>
<%_ struct.fields.forEach(function (property, key) { -%>
  <%_ if (property.editType === 'struct') { -%>
    <%_ structForms.push(property.name.lowerCamelName) -%>
  <%_ } -%>
<%_ }) -%>
import {<%_ if (struct.screenType !== 'struct') { -%><%= struct.name.pascalName %>Api, <% } -%>Model<%= struct.name.pascalName %>} from '@/apis'
<%_ let importDateTime = false -%>
<%_ if (struct.fields) { -%>
<%_ struct.fields.forEach(function(property, index){ -%>
  <%_ if ((property.listType === 'time' || property.listType === 'array-time') && !importDateTime) { -%>
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
<%_ if (struct.fields) { -%>
<%_ struct.fields.forEach(function(property, index){ -%>
  <%_ if (property.editType === 'array-struct') { -%>
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
  <%_ } -%>
<%_ }) -%>
<%_ } -%>
<%_ if (struct.fields) { -%>
<%_ struct.fields.forEach(function(property, index){ -%>
  <%_ if (property.editType === 'struct') { -%>
    <%_ if (!importExpansion) { -%>
import Expansion from '@/components/form/Expansion.vue'
      <%_ importExpansion = true -%>
    <%_ } -%>
    <%_ if (!importArrayStructSet.has(property.structType) && !importStructSet.has(property.structType)) { -%>
import <%= h.changeCase.pascal(property.structType) %>EntryForm, {INITIAL_<%= h.changeCase.constant(property.structType) %>} from '@/components/<%= h.changeCase.camel(property.structType) %>/<%= h.changeCase.pascal(property.structType) %>EntryForm.vue'
      <%_ importStructSet.add(property.structType) -%>
    <%_ } -%>
  <%_ } -%>
  <%_ if (property.editType === 'array-string' || property.editType === 'array-textarea' || property.editType === 'array-number' || property.editType === 'array-time' || property.editType === 'array-bool') { -%>
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

export const INITIAL_<%= struct.name.upperSnakeName %>: Model<%= struct.pascalName %> = {
<%_ if (struct.fields) { -%>
<%_ struct.fields.forEach(function(property, index){ -%>
  <%_ if (property.editType === 'struct') { -%>
  <%= property.name.lowerCamelName %>: INITIAL_<%= h.changeCase.constant(property.structType) %>,
  <%_ } -%>
  <%_ if (property.editType.startsWith('array')) { -%>
  <%= property.name.lowerCamelName %>: [],
  <%_ } -%>
  <%_ if (property.editType === 'string' || property.editType === 'textarea' || property.editType === 'time') { -%>
  <%= property.name.lowerCamelName %>: undefined,
  <%_ } -%>
  <%_ if (property.editType === 'bool') { -%>
  <%= property.name.lowerCamelName %>: undefined,
  <%_ } -%>
  <%_ if (property.editType === 'number') { -%>
  <%= property.name.lowerCamelName %>: undefined,
  <%_ } -%>
<%_ }) -%>
<%_ } -%>
}

interface Props {
  /** 表示状態 (true: 表示, false: 非表示) */
  open!: boolean
  /** 編集対象 */
  target!: Model<%= struct.pascalName %>
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

<%_ struct.fields.forEach(function (property, key) { -%>
  <%_ if (property.editType === 'array-struct') { -%>

/** <%= property.structName.pascalName %>の初期値 */
const initial<%= property.structName.pascalName %> = ref<Model<%= struct.pascalName %>>(INITIAL_<%= property.structName.upperSnakeName %>)
  <%_ } -%>
<%_ }) -%>

const validationRules = ref<any>({
<%_ struct.fields.forEach(function (property, key) { -%>
  <%_ if (property.editType !== 'array-struct' && property.editType !== 'struct') { -%>
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
        <%_ struct.fields.forEach(function (property, key) { -%>
          <%_ if (property.editType === 'string' && property.name.lowerCamelName === 'id') { -%>
          <v-flex md12 sm12 xs12>
            <v-text-field
              v-model="target.<%= property.name.lowerCamelName %>"
              :disabled="!isNew"
              :rules="validationRules.<%= property.name.lowerCamelName %>"
              label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>"
              required
            ></v-text-field>
          </v-flex>
          <%_ } -%>
          <%_ if (property.editType === 'string' && property.name.lowerCamelName !== 'id') { -%>
          <v-flex md12 sm12 xs12>
            <v-text-field
              v-model="target.<%= property.name.lowerCamelName %>"
              :rules="validationRules.<%= property.name.lowerCamelName %>"
              label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>"
            ></v-text-field>
          </v-flex>
          <%_ } -%>
          <%_ if (property.editType === 'number' && property.name.lowerCamelName === 'id') { -%>
          <v-flex md12 sm12 xs12>
            <v-text-field
              :disabled="!isNew"
              :rules="validationRules.<%= property.name.lowerCamelName %>"
              :value="target.<%= property.name.lowerCamelName %>"
              label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>"
              required
              type="number"
              @input="v => target.<%= property.name.lowerCamelName %> = v === '' ? undefined : Number(v)"
            ></v-text-field>
          </v-flex>
          <%_ } -%>
          <%_ if (property.editType === 'number' && property.name.lowerCamelName !== 'id') { -%>
          <v-flex md12 sm12 xs12>
            <v-text-field
              :rules="validationRules.<%= property.name.lowerCamelName %>"
              :value="target.<%= property.name.lowerCamelName %>"
              label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>"
              type="number"
              @input="v => target.<%= property.name.lowerCamelName %> = v === '' ? undefined : Number(v)"
            ></v-text-field>
          </v-flex>
          <%_ } -%>
          <%_ if (property.editType === 'time') { -%>
          <date-time-form
            :date-time.sync="target.<%= property.name.lowerCamelName %>"
            :rules="validationRules.<%= property.name.lowerCamelName %>"
            label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>"
          ></date-time-form>
          <%_ } -%>
          <%_ if (property.editType === 'textarea') { -%>
          <v-flex md12 sm12 xs12>
            <v-textarea
              v-model="target.<%= property.name.lowerCamelName %>"
              :rules="validationRules.<%= property.name.lowerCamelName %>"
              label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>"
            ></v-textarea>
          </v-flex>
          <%_ } -%>
          <%_ if (property.editType === 'bool') { -%>
          <v-flex md12 sm12 xs12>
            <v-checkbox
              v-model="target.<%= property.name.lowerCamelName %>"
              :rules="validationRules.<%= property.name.lowerCamelName %>"
              label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>"
            ></v-checkbox>
          </v-flex>
          <%_ } -%>
          <%_ if (property.editType === 'image' && property.dataType === 'string') { -%>
          <v-flex xs12>
            <image-form
              :image-url.sync="target.<%= property.name.lowerCamelName %>"
              :rules="validationRules.<%= property.name.lowerCamelName %>"
              dir="<%= struct.name.lowerCamelName %>/<%= property.name.lowerCamelName %>"
              label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>"
            ></image-form>
          </v-flex>
          <%_ } -%>
          <%_ if (property.editType === 'array-image') { -%>
          <v-flex xs12>
            <image-array-form
              :image-urls.sync="target.<%= property.name.lowerCamelName %>"
              :rules="validationRules.<%= property.name.lowerCamelName %>"
              dir="<%= struct.name.lowerCamelName %>/<%= property.name.lowerCamelName %>"
              label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>"
            ></image-array-form>
          </v-flex>
          <%_ } -%>
          <%_ if (property.editType === 'array-string' || property.editType === 'array-textarea' || property.editType === 'array-number' || property.editType === 'array-time' || property.editType === 'array-bool') { -%>
          <v-flex xs12>
            <expansion label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>一覧">
              <%_ if (property.childType === 'string') { -%>
              <array-form
                v-slot="{editTarget, updatedForm}"
                :items.sync="target.<%= property.name.lowerCamelName %>"
                initial="">
                <v-text-field
                  :rules="validationRules.<%= property.name.lowerCamelName %>"
                  :value="editTarget"
                  label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>"
                  @input="updatedForm"
                ></v-text-field>
              </array-form>
              <%_ } -%>
              <%_ if (property.childType === 'textarea') { -%>
              <array-form
                v-slot="{editTarget, updatedForm}"
                :items.sync="target.<%= property.name.lowerCamelName %>"
                initial="">
                <v-textarea
                  :rules="validationRules.<%= property.name.lowerCamelName %>"
                  :value="editTarget"
                  label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>"
                  @input="updatedForm"
                ></v-textarea>
              </array-form>
              <%_ } -%>
              <%_ if (property.childType === 'number') { -%>
              <array-form
                v-slot="{editTarget, updatedForm}"
                :initial="0"
                :items.sync="target.<%= property.name.lowerCamelName %>">
                <v-text-field
                  :rules="validationRules.<%= property.name.lowerCamelName %>"
                  :value="editTarget"
                  label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>"
                  type="number"
                  @input="v => updatedForm(v === '' ? undefined : Number(v))"
                ></v-text-field>
              </array-form>
              <%_ } -%>
              <%_ if (property.childType === 'bool') { -%>
              <array-form
                v-slot="{editTarget, updatedForm}"
                :initial="false"
                :items.sync="target.<%= property.name.lowerCamelName %>">
                <v-checkbox
                  :rules="validationRules.<%= property.name.lowerCamelName %>"
                  :value="editTarget"
                  label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>"
                  @change="updatedForm"
                ></v-checkbox>
              </array-form>
              <%_ } -%>
              <%_ if (property.childType === 'time') { -%>
              <array-form
                v-slot="{editTarget, updatedForm}"
                :initial="formatISO(new Date())"
                :items.sync="target.<%= property.name.lowerCamelName %>">
                <date-time-form
                  :date-time.sync="editTarget"
                  :rules="validationRules.<%= property.name.lowerCamelName %>"
                  label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>"
                  @update:dateTime="updatedForm"
                ></date-time-form>
              </array-form>
              <%_ } -%>
            </expansion>
          </v-flex>
          <%_ } -%>
          <%_ if (property.editType === 'array-struct') { -%>
          <v-flex xs12>
            <expansion label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>一覧">
              <struct-array-form
                :initial="initial<%= h.changeCase.pascal(property.structType) %>"
                :items.sync="target.<%= property.name.lowerCamelName %>">
                <template v-slot:table="{items, openEntryForm, removeRow}">
                  <<%= h.changeCase.param(property.structType) %>-data-table
                    :has-parent="true"
                    :items="items"
                    @openEntryForm="openEntryForm"
                    @remove="removeRow"
                  ></<%= h.changeCase.param(property.structType) %>-data-table>
                </template>
                <template v-slot:form="{editIndex, isEntryFormOpen, editTarget, closeForm, removeForm, updatedForm}">
                  <<%= h.changeCase.param(property.structType) %>-entry-form
                    :has-parent="true"
                    :is-new="editIndex === NEW_INDEX"
                    :open="isEntryFormOpen"
                    :target="editTarget"
                    @close="closeForm"
                    @remove="removeForm"
                    @updated="updatedForm"
                  ></<%= h.changeCase.param(property.structType) %>-entry-form>
                </template>
              </struct-array-form>
            </expansion>
          </v-flex>
          <%_ } -%>
          <%_ if (property.editType === 'struct') { -%>
          <v-flex xs12>
            <expansion expanded label="<%= property.screenLabel ? property.screenLabel : property.name.lowerCamelName %>">
              <<%= h.changeCase.param(property.structType) %>-entry-form
                ref="<%= property.name.lowerCamelName %>Form"
                :has-parent="true"
                :is-embedded="true"
                :target.sync="target.<%= property.name.lowerCamelName %>"
              ></<%= h.changeCase.param(property.structType) %>-entry-form>
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
