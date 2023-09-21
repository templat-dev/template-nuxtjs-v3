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
import {INITIAL_<%= struct.name.upperSnakeName %>} from "~/types/<%= struct.name.pascalName %>Type";

const loading = useAppLoading()
const snackbar = useAppSnackbar()
const dialog = useAppDialog()

/** 編集対象 */
const editTarget = ref<Model<%= struct.name.pascalName %> | null>(null)
const <%= struct.name.lowerCamelName %>ID = ref<number>(NEW_INDEX)

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

const updateTarget = (target: Model<%= struct.name.pascalName %>) => {
  editTarget.value = target
}

const save = async (target: Model<%= struct.name.pascalName %>) => {
  if (!editTarget.value) return
  loading.showLoading()
  try {
    if (<%= struct.name.lowerCamelName %>ID.value === NEW_INDEX) {
      // 新規の場合
      await <%= struct.name.lowerCamelName %>Api.create<%= struct.name.pascalName %>({
        body: target
      })
    } else {
      // 更新の場合
      await <%= struct.name.lowerCamelName %>Api.update<%= struct.name.pascalName %>({
        id: target.id!,
        body: target
      })
    }
  } finally {
    loading.hideLoading()
  }
  back()
}

const remove = async(<%= struct.name.lowerCamelName %>ID: number) => {
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

const back = () => {
  navigateTo('/<%= struct.name.lowerCamelName %>')
}
</script>

<template>
  <<%= struct.name.lowerCamelName %>-entry-form
    v-if="editTarget"
    :dialog="false"
    :is-new="<%= struct.name.lowerCamelName %>ID === NEW_INDEX"
    v-model:target="editTarget"
    @save:target="save"
    @update:target="updateTarget"
    @remove:target="remove"
    @cancel="back"
  ></<%= struct.name.lowerCamelName %>-entry-form>
</template>

<style scoped></style>
