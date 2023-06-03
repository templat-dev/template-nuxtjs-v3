---
to: "<%= entity.plugins.includes('image') ? `${rootDirectory}/${projectName}/components/form/ImageForm.vue` : null %>"
force: true
---
<template>
  <div
    :class="{ droppable: dragOvered }"
    @drop.prevent="dropImage"
    @dragover.prevent="dragOvered = true"
    @dragleave.prevent="dragOvered = false">
    <v-layout v-if="label" class="mb-2">
      <span>{{ label }}</span>
    </v-layout>
    <v-layout>
      <div v-if="!!syncedImageURL" class="relative mb-4 mr-4">
        <v-img :src="syncedImageURL" aspect-ratio="1" class="grey lighten-2" height="100px" width="100px">
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
    </v-layout>
  </div>
</template>

<script lang="ts">
import {Component, Prop, PropSync, Vue} from 'nuxt-property-decorator'
import {ImageApi} from '@/apis'
import appUtils from '@/utils/appUtils'
import {vxm} from '@/store'

@Component
export default class ImageForm extends Vue {
  /** 画面表示ラベル */
  @Prop({type: String, default: ''})
  label!: string

  /** 画像保存ディレクトリ名 */
  @Prop({type: String, required: true})
  dir!: string

  /** 編集対象 */
  @PropSync('imageUrl', {type: String, default: undefined})
  syncedImageURL: string | undefined

  /** サムネイル作成有無 (true: 作成する, false: 作成しない) */
  @Prop({type: Boolean, default: false})
  thumbnail!: boolean

  /** サムネイルのサイズ */
  @Prop({type: Number, default: 200})
  thumbnailSize!: number

  /** 画像ドロップエリアの表示 (true: 表示, false: 非表示) */
  dragOvered: boolean = false

  selectFile() {
    (this.$refs.fileInput as HTMLElement).click()
  }

  async uploadImage(file: File) {
    const responseImage = await new ImageApi().uploadImage({
      name: appUtils.generateRandomString(8),
      dir: this.dir,
      image: file,
      thumbnail: this.thumbnail,
      thumbnailSize: this.thumbnailSize
    }).then(res => res.data)
    if (responseImage && responseImage.url) {
      this.syncedImageURL = responseImage.url
    }
  }

  async dropImage(e: DragEvent) {
    this.dragOvered = false
    if (!e.dataTransfer || !e.dataTransfer.files || e.dataTransfer.files.length === 0) {
      return
    }
    try {
      vxm.app.showLoading()
      await this.uploadImage(e.dataTransfer.files[0])
    } finally {
      vxm.app.hideLoading()
    }
  }

  async selectImage(e: InputEvent) {
    const files = (e.target as HTMLInputElement).files
    if (!files || files.length === 0) {
      return
    }
    try {
      vxm.app.showLoading()
      await this.uploadImage(files[0])
    } finally {
      vxm.app.hideLoading()
    }
  }

  removeImage() {
    this.syncedImageURL = ''
  }
}
</script>

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
