---
to: "<%= project.plugins.find(p => p.name === 'image')?.enable ? `${rootDirectory}/components/form/ImageArrayForm.vue` : null %>"
force: true
---
<script setup lang="ts">
import {ImageApi} from '@/apis'
import appUtils from '@/utils/appUtils'
import {useAppLoading} from "@/composables/useLoading";

const loading = useAppLoading()

interface Props {
  /** 画面表示ラベル */
  label?: string,
  /** 画像保存ディレクトリ名 */
  dir?: string,
  /** 編集対象 */
  imageURLs?: string[],
  /** サムネイル作成有無 (true: 作成する, false: 作成しない) */
  thumbnail?: boolean,
  /** サムネイルのサイズ */
  thumbnailSize?: number,
}
const props = withDefaults(defineProps<Props>(), {
  label: '',
  dir: '',
  imageURLs: (props: Props) => [],
  thumbnail: false,
  thumbnailSize: 200,
})

interface Emits {
  (e: "add-image-url", url: string): void;
  (e: "remove-image", index: number): void;
}
const emit = defineEmits<Emits>()

/** 画像ドロップエリアの表示 (true: 表示, false: 非表示) */
const dragOvered = ref<boolean>(false)

const fileInput = ref<HTMLInputElement | null>(null)

const selectFile = () => {
  (fileInput.value as HTMLInputElement).click()
}

const uploadImage = async (file: File) => {
  const responseImage = await new ImageApi().uploadImage({
    name: appUtils.generateRandomString(8),
    dir: `${props.dir}/${props.label}`,
    image: file,
    thumbnail: props.thumbnail,
    thumbnailSize: props.thumbnailSize
  }).then(res => res.data)
  if (responseImage && responseImage.url) {
    addImageURL(responseImage.url)
  }
}

const dropImages = async (e: DragEvent) => {
  dragOvered.value = false
  if (!e.dataTransfer || !e.dataTransfer.files || e.dataTransfer.files.length === 0) {
    return
  }
  try {
    loading.showLoading()
    for (const file of Array.from(e.dataTransfer.files)) {
      await uploadImage(file)
    }
  } finally {
    loading.hideLoading()
  }
}

const selectImages = async (e: InputEvent) => {
  const files = (e.target as HTMLInputElement).files
  if (!files || files.length === 0) {
    return
  }
  try {
    loading.showLoading()
    for (const file of Array.from(files)) {
      await uploadImage(file)
    }
  } finally {
    loading.hideLoading()
  }
}

const removeImage = (index: number) => {
  if (!props.imageURLs) {
    return
  }
  emit('remove-image', index)
}

const addImageURL = (imageURL: string) => {
  console.log(`addImageURL ${imageURL}`)
  emit('add-image-url', imageURL)
}
</script>

<template>
  <div
    :class="{ droppable: dragOvered }"
    @drop.prevent="dropImages"
    @dragover.prevent="dragOvered = true"
    @dragleave.prevent="dragOvered = false">
    <v-layout v-if="label" class="mb-2">
      <span>{{ label }}</span>
    </v-layout>
    <v-layout wrap>
      <div v-for="(imageURL, index) in imageURLs" :key="index" class="relative mb-4 mr-4">
        <v-img :src="imageURL" aspect-ratio="1" class="grey lighten-2" height="100px" width="100px">
          <template #placeholder>
            <v-row align="center" class="fill-height ma-0" justify="center">
              <v-progress-circular color="grey lighten-5" indeterminate></v-progress-circular>
            </v-row>
          </template>
        </v-img>
        <v-btn class="img-delete-button" color="error" depressed fab height="20px" width="20px">
          <v-icon x-small @click="removeImage(index)">mdi-delete</v-icon>
        </v-btn>
      </div>
      <div class="mb-4 mr-4">
        <input ref="fileInput" accept="image/x-png,image/gif,image/jpeg" class="d-none" multiple type="file"
               @change="selectImages">
        <v-btn depressed height="100px" width="100px" @click="selectFile">
          <v-icon color="grey darken-1" x-large>mdi-plus-thick</v-icon>
        </v-btn>
      </div>
    </v-layout>
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
