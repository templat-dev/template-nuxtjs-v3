---
to: "<%= struct.generateEnable ? `${rootDirectory}/pages/${struct.name.lowerCamelName}/[id].vue` : null %>"
---
<script setup lang="ts">
import {Model<%= struct.name.pascalName %>} from '@/apis'
import {useAppLoading} from "~/composables/useLoading"
import {useAppSnackbar} from "~/composables/useSnackbar"
import {useAppDialog} from "~/composables/useDialog";
import {NEW_INDEX} from '@/constants/appConstants'
import {cloneDeep} from "lodash-es";
import {INITIAL_<%= struct.name.upperSnakeName %>} from "~/types/CountryType";

const loading = useAppLoading()
const snackbar = useAppSnackbar()
const dialog = useAppDialog()

/** 編集対象 */
const editTarget = ref<Model<%= struct.name.pascalName %> | null>(null)
const countryID = ref<number>(NEW_INDEX)

const { $api } = useNuxtApp()
const <%= struct.name.lowerCamelName %>Api = $api.<%= struct.name.lowerCamelName %>Api()

onMounted(async () => {
  const route = useRoute()
  if (route.params.id && typeof route.params.id === 'string') {
    if (route.params.id === 'new') {
      // 新規登録
      editTarget.value = cloneDeep(INITIAL_<%= struct.name.upperSnakeName %>)
    } else {
      // 編集
      <%= struct.name.lowerCamelName %>ID.value = parseInt(route.params.id)
      editTarget.value = await <%= struct.name.lowerCamelName %>Api.get<%= struct.name.pascalName %>({id: <%= struct.name.lowerCamelName %>ID.value}).then((res) => res.data)
    }
  }
})

const remove = async(countryID: number) => {
  dialog.showDialog({
    title: '削除確認',
    message: '削除してもよろしいですか？',
    negativeText: 'Cancel',
    positive: async () => {
      loading.showLoading()
      try {
        await <%= struct.name.lowerCamelName %>Api.delete<%= struct.name.pascalName %>({id: editTarget.value!.id!})
      } finally {
        loading.hideLoading()
      }
      snackbar.showSnackbar({text: '削除しました。'})
    }
  })
}
</script>

<template>
  <<%= struct.name.lowerCamelName %>-entry-form
    v-if="editTarget"
    :dialog="false"
    :is-new="countryID === NEW_INDEX"
    v-model:target="editTarget"
    @remove="remove"
    @back="navigateTo('/<%= struct.name.lowerCamelName %>')"
  ></<%= struct.name.lowerCamelName %>-entry-form>
</template>

<style scoped></style>
