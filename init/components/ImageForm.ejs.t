---
to: "<%= project.plugins.find(p => p.name === 'image')?.enable ? `${rootDirectory}/components/form/ImageForm.vue` : null %>"
force: true
---
<script setup lang="ts">

import {useNuxtApp} from "#app";
import {ref} from "vue";
import appUtils from '~/utils/appUtils'
import {useAppLoading} from "~/composables/useLoading";

const {$api} = useNuxtApp()
const imageApi = $api.imageApi()

const loading = useAppLoading()

const fileInput = ref<HTMLInputElement | null>(null)

interface Props {
  label?: string,
  dir?: string,
  imageURL?: string,
  thumbnail?: boolean,
  thumbnailSize?: number,
}
const props = withDefaults(defineProps<Props>(), {
  label: '',
  dir: '',
  imageURL: '',
  thumbnail: false,
  thumbnailSize: 200,
})

interface Emits {
  (e: "update:imageUrl", url: string): void;
}
const emit = defineEmits<Emits>()

const dragOvered = ref<boolean>(false)

const selectFile = () => {
  (fileInput.value as HTMLInputElement).click()
}

const uploadImage = async (file: File) => {
  const responseImage = await imageApi.uploadImage({
    name: appUtils.generateRandomString(8),
    dir: props.dir,
    image: file,
    thumbnail: props.thumbnail,
    thumbnailSize: props.thumbnailSize
  }).then((res: any) => res.data)
  if (responseImage && responseImage.url) {
    updateImageURL(responseImage.url)
  }
}

const dropImage = async (e: DragEvent) => {
  dragOvered.value = false
  if (!e.dataTransfer || !e.dataTransfer.files || e.dataTransfer.files.length === 0) {
    return
  }
  try {
    loading.showLoading()
    await uploadImage(e.dataTransfer.files[0])
  } finally {
    loading.hideLoading()
  }
}

const selectImage = async (e: InputEvent) => {
  const files = (e.target as HTMLInputElement).files
  if (!files || files.length === 0) {
    return
  }
  try {
    loading.showLoading()
    await uploadImage(files[0])
  } finally {
    loading.hideLoading()
  }
}

const removeImage = () => {
  updateImageURL('')
}

const updateImageURL = (imageURL: string) => {
  console.log(`updateImageURL ${imageURL}`)
  emit('update:imageUrl', imageURL)
}
</script>

<template>
  <div
      :class="{ droppable: dragOvered }"
      @drop.prevent="dropImage"
      @dragover.prevent="dragOvered = true"
      @dragleave.prevent="dragOvered = false">
    <v-container v-if="label" class="mb-2">
      <span>{{ label }}</span>
    </v-container>
    <v-container>
      <div v-if="!!imageURL" class="relative mb-4 mr-4">
        <v-img :src="imageURL" aspect-ratio="1" class="grey lighten-2" height="100px" width="100px">
          <template #placeholder>
            <v-row align="center" class="fill-height ma-0" justify="center">
              <v-progress-circular color="grey lighten-5" indeterminate></v-progress-circular>
            </v-row>
          </template>
        </v-img>
        <v-btn class="img-delete-button" color="error" depressed fab height="20px" width="20px">
          <v-icon x-small @click.stop="removeImage">mdi-delete</v-icon>
        </v-btn>
      </div>
      <div v-else class="mb-4 mr-4">
        <input ref="fileInput" accept="image/x-png,image/gif,image/jpeg" class="d-none" type="file"
               @change="selectImage">
        <v-btn depressed height="100px" width="100px" @click="selectFile">
          <v-icon color="grey darken-1" x-large>mdi-plus-thick</v-icon>
        </v-btn>
      </div>
    </v-container>
  </div>

</template>

<style scoped>
.droppable {
  background-color: #EEEEEE;
}

.img-delete-button {
  position: absolute;
  right: -6px;
  top: -6px;
}
</style>
