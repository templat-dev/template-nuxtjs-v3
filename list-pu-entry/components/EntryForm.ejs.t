---
to: <%= rootDirectory %>/components/<%= struct.name.lowerCamelName %>/<%= struct.name.pascalName %>EntryForm.vue
---
<script setup lang="ts">
import {
<%_ if (struct.structType !== 'struct') { -%>
  <%= struct.name.pascalName %>Api,
<%_ } -%>
  Model<%= struct.name.pascalName %>,
<%_ struct.fields.forEach(function (field, key) { -%>
  <%_ if (field.editType === 'array-struct' || field.editType === 'struct') { -%>
  Model<%= field.structName.pascalName %>,
  <%_ } -%>
<%_ }) -%>
} from '@/apis'
<%_ if (struct.exists.edit.time || struct.exists.edit.arrayTime) { -%>
import DateTimeForm from '@/components/form/DateTimeForm.vue'
<%_ } -%>
<%_ if (struct.exists.edit.image) { -%>
import ImageForm from '@/components/form/ImageForm.vue'
<%_ } -%>
<%_ if (struct.exists.edit.arrayImage) { -%>
import ImageArrayForm from '@/components/form/ImageArrayForm.vue'
<%_ } -%>
<%_ if (struct.exists.edit.struct || struct.exists.edit.arrayNumber || struct.exists.edit.arrayText || struct.exists.edit.arrayTextArea || struct.exists.edit.arrayBool || struct.exists.edit.arrayTime || struct.exists.edit.arrayStruct) { -%>
import Expansion from '@/components/form/Expansion.vue'
<%_ } -%>
<%_ if (struct.exists.edit.arrayNumber || struct.exists.edit.arrayText || struct.exists.edit.arrayTextArea || struct.exists.edit.arrayBool || struct.exists.edit.arrayTime) { -%>
import ArrayForm from '@/components/form/ArrayForm.vue'
<%_ } -%>
<%_ if (struct.exists.edit.arrayStruct) { -%>
import StructArrayForm from '@/components/form/StructArrayForm.vue'
<%_ } -%>
<%_ const importStructTableSet = new Set() -%>
<%_ const importStructFormSet = new Set() -%>
<%_ struct.fields.forEach(function (field, key) { -%>
<%_ if (field.editType === 'array-struct') { -%>
<%_ if (!importStructTableSet.has(field.structName.pascalName)) { -%>
import <%= field.structName.pascalName %>DataTable from '@/components/<%= field.structName.lowerCamelName %>/<%= field.structName.pascalName %>DataTable.vue'
<%_ importStructTableSet.add(field.structName.pascalName) -%>
<%_ } -%>
<%_ if (!importStructFormSet.has(field.structName.pascalName)) { -%>
import {INITIAL_<%= field.structName.upperSnakeName %>} from '@/types/<%= field.structName.pascalName %>Type'
<%_ importStructFormSet.add(field.structName.pascalName) -%>
<%_ } -%>
<%_ } -%>
<%_ if (field.editType === 'struct') { -%>
<%_ if (!importStructFormSet.has(field.structName.pascalName)) { -%>
import {INITIAL_<%= field.structName.upperSnakeName %>} from '@/types/<%= field.structName.pascalName %>Type'
<%_ importStructFormSet.add(field.structName.pascalName) -%>
<%_ } -%>
<%_ } -%>
<%_ }) -%>
import {NEW_INDEX} from '@/constants/appConstants'

interface Props {
  /** 表示状態 (true: 表示, false: 非表示) */
  open: boolean
  /** 編集対象 */
  target: Model<%= struct.name.pascalName %>
  /** 表示方式 (true: 埋め込み, false: ダイアログ) */
  isEmbedded: boolean
  /** 表示方式 (true: 子要素として表示, false: 親要素として表示) */
  hasParent: boolean
  /** 編集状態 (true: 新規, false: 更新) */
  isNew: boolean
}
const props = withDefaults(defineProps<Props>(), {
  open: true,
  target: (props: Props) => INITIAL_<%= struct.name.upperSnakeName %>,
  isEmbedded: false,
  hasParent: false,
  isNew: true,
})

interface Emits {
  (e: "updated", item: Model<%= struct.name.pascalName %>): void;
  (e: "update:target", item: Model<%= struct.name.pascalName %>): void;
  (e: "remove", item: Model<%= struct.name.pascalName %>): void;
  (e: "update:open", open: boolean): void;
}
const emit = defineEmits<Emits>()

const dialog = useAppDialog()
const loading = useAppLoading()

<%_ struct.fields.forEach(function (field, key) { -%>
  <%_ if (field.editType === 'array-struct') { -%>

/** <%= field.structName.pascalName %>の初期値 */
const initial<%= field.structName.pascalName %> = ref<Model<%= field.structName.pascalName %>>(INITIAL_<%= field.structName.upperSnakeName %>)
  <%_ } -%>
<%_ }) -%>

// フォームとバリデーション状況
const <%= struct.name.lowerCamelName %>Form = ref<any>(null)
const valid<%= struct.name.pascalName %>Form = ref<boolean>(false)

// 子フォームとバリデーション状況
<%_ struct.fields.forEach(function (field, key) { -%>
  <%_ if (field.editType === 'struct') { -%>
/** <%= field.structName.pascalName %>のフォームとバリデーション状況 */
const <%= field.structName.lowerCamelName %>Form = ref<any>(null)
const valid<%= field.structName.pascalName %>Form = ref<boolean>(false)

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
    <%= struct.name.lowerCamelName %>Form.value.resetValidation()
<%_ struct.fields.forEach(function (field, key) { -%>
  <%_ if (field.editType === 'struct') { -%>
    ;<%= field.name.lowerCamelName %>Form.value.resetValidation()
  <%_ } -%>
<%_ }) -%>
  }
})

const initializeTarget = () => {
  emit('update:target', INITIAL_<%= struct.name.upperSnakeName %>)
}

const save = async () => {
<%_ if (!struct.exists.edit.struct) { -%>
  if (!<%= struct.name.lowerCamelName %>Form.value.validate()) {
<%_ } else { -%>
    if (!<%= struct.name.lowerCamelName %>Form.value.validate()
<%_ struct.fields.forEach(function (field, key) { -%>
  <%_ if (field.editType === 'struct') { -%>
    || valid<%= field.name.pascalName %>Form.validate() === false
  <%_ } -%>
<%_ }) -%>
  ) {
<%_ } -%>
      dialog.showDialog({
        title: 'エラー',
        message: '入力項目を確認して下さい。'
      })
      return
    }
<%_ if (struct.structType !== 'struct') { -%><%#_ Structでない場合 -%>
    if (props.hasParent) {
      // 親要素側で保存
      return
    }
    loading.showLoading()
    try {
      if (props.isNew) {
        // 新規の場合
        await new <%= struct.name.pascalName %>Api().create<%= struct.name.pascalName %>({
          body: props.target
        })
      } else {
        // 更新の場合
        await new <%= struct.name.pascalName %>Api().update<%= struct.name.pascalName %>({
          id: props.target.id!,
          body: props.target
        })
      }
      close()
      emit('updated', props.target)
    } finally {
      loading.hideLoading()
    }
<%_ } else { -%>
  close()
<%_ } -%>
}

const remove = async () => {
  emit('remove', props.target)
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
        <v-form ref="<%= struct.name.lowerCamelName %>Form"  v-model="valid<%= struct.name.pascalName %>Form" class="full-width" lazy-validation>
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
                :initial="initial<%= field.structName.pascalName %>"
                :items.sync="target.<%= field.name.lowerCamelName %>">
                <template #table="{items, openEntryForm, removeRow}">
                  <<%= field.structName.lowerCamelName %>-data-table
                    :has-parent="true"
                    :items="items"
                    @openEntryForm="openEntryForm"
                    @remove="removeRow"
                  ></<%= field.structName.lowerCamelName %>-data-table>
                </template>
                <template #form="{editIndex, isEntryFormOpen, editTarget, closeForm, removeForm, updatedForm}">
                  <<%= field.structName.lowerCamelName %>-entry-form
                    :has-parent="true"
                    :is-new="editIndex === NEW_INDEX"
                    :open="isEntryFormOpen as boolean"
                    :target="editTarget as Model<%= field.structName.pascalName %>"
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
      <v-btn color="blue darken-1" text @click="save">保存</v-btn>
    </v-card-actions>
  </v-card>
</template>

<style scoped>
.action-button {
  pointer-events: auto;
}
</style>
